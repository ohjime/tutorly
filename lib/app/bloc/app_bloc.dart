import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tutorly/core/core.dart' as core;

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required core.AuthenticationRepository authenticationRepository,
    required core.UserRepository userRepository,
  }) : _authenticationRepository = authenticationRepository,
       _userRepository = userRepository,
       super(Starting()) {
    on<CredentialSubscriptionRequested>(_onCredentialSubscriptionRequested);
    on<LogoutPressed>(_onLogoutPressed);
    on<VerifyOnboardingStatus>(_onVerifyOnboardingStatus);
  }

  final core.AuthenticationRepository _authenticationRepository;
  final core.UserRepository _userRepository;

  Future<void> _onCredentialSubscriptionRequested(
    CredentialSubscriptionRequested event,
    Emitter<AppState> emit,
  ) async {
    // await Future.delayed(Duration(milliseconds: 2000));
    return emit.onEach(
      _authenticationRepository.credential,
      onData: (credential) async {
        if (credential == core.AuthCredential.empty) {
          emit(const Unauthenticated());
        } else {
          try {
            final user = await _userRepository.getUser(credential.id);
            if (user == core.User.empty || user.role == core.UserRole.unknown) {
              emit(OnboardingRequired(credential: credential));
            } else {
              emit(Onboarded(credential: credential));
            }
          } catch (_) {
            emit(const Unauthenticated());
          }
        }
      },
      onError: (_, __) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onVerifyOnboardingStatus(
    VerifyOnboardingStatus event,
    Emitter<AppState> emit,
  ) async {
    final credential = _authenticationRepository.currentCredential;
    if (credential == core.AuthCredential.empty) {
      emit(const Unauthenticated());
      return;
    }

    try {
      final user = await _userRepository.getUser(credential.id);
      if (user == core.User.empty || user.role == core.UserRole.unknown) {
        emit(OnboardingRequired(credential: credential));
      } else {
        emit(Onboarded(credential: credential));
      }
    } catch (_) {
      emit(const Unauthenticated());
    }
  }

  void _onLogoutPressed(LogoutPressed event, Emitter<AppState> emit) {
    _authenticationRepository.logOut();
    emit(const Unauthenticated());
  }
}
