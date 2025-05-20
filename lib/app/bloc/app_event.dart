part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class CredentialSubscriptionRequested extends AppEvent {
  const CredentialSubscriptionRequested();
}

final class LogoutPressed extends AppEvent {
  const LogoutPressed();
}

final class VerifyOnboardingStatus extends AppEvent {
  const VerifyOnboardingStatus();
}
