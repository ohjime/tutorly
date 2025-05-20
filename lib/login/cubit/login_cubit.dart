import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tutorly/core/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authenticationRepository.logInWithGoogle();
    } catch (e) {
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void resetError() {
    emit(state.copyWith(status: LoginStatus.initial, errorMessage: null));
  }
}
