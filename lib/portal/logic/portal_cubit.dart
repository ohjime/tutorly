import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tutorly/shared/exports.dart';

part 'portal_state.dart';

class PortalCubit extends Cubit<PortalState> {
  final AuthenticationRepository authRepo;

  PortalCubit({required this.authRepo}) : super(PortalState.initial());

  Future<void> submitLogInForm({
    required String email,
    required String password,
  }) async {
    emit(state.requesting());
    try {
      await authRepo.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return emit(state.success());
    } catch (e) {
      emit(state.error(error: e.toString()));
      return emit(state.reset());
    }
  }

  Future<void> submitSignUpForm({
    required String email,
    required String password,
  }) async {
    emit(state.requesting());
    try {
      await authRepo.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      return emit(state.success());
    } catch (e) {
      emit(state.error(error: e.toString()));
      return emit(state.reset());
    }
  }

  void obscurePassword() {
    emit(state.copyWith(obscurePassword: !(state.obscurePassword)));
  }

  void signupMode() {
    emit(
      state.copyWith(
        mode: PortalMode.signup,
        status: PortalStatus.intial,
        message: '',
      ),
    );
  }

  void loginMode() {
    emit(
      state.copyWith(
        mode: PortalMode.login,
        status: PortalStatus.intial,
        message: '',
      ),
    );
  }

  void resetError() {
    emit(state.reset());
  }

  void signInWithGoogle() {}

  void signInWithApple() {}

  void signUpWithGoogle() {}

  void signUpWithApple() {}

  @override
  void onChange(Change<PortalState> change) {
    super.onChange(change);
  }
}
