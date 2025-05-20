part of 'app_bloc.dart';

/// ------------------------------------------------------------------
/// 1. Root App State ­– no fields → empty `props`.
///    This is the base class for all app states.
/// ------------------------------------------------------------------
sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => []; // ⬅️ nothing to compare yet
}

/// ------------------------------------------------------------------
/// 2. Starting app state – no fields → empty `props`.
///    This is the initial state of the app, before any authentication
///    or user data is loaded. It is used to show a splash screen or
///    loading indicator.
/// ------------------------------------------------------------------
final class Starting extends AppState {
  const Starting();
}

/// ------------------------------------------------------------------
/// 3. Unauthenticated app state – no fields → empty `props`.
///    This state is used when the user is not logged in and has not
///    completed onboarding.
/// ------------------------------------------------------------------
final class Unauthenticated extends AppState {
  const Unauthenticated();
}

/// ------------------------------------------------------------------
/// 4. Authenticated Root State that carries a credential field.
///    This state is the parent class for all authenticated app states.
/// ------------------------------------------------------------------
final class Authenticated extends AppState {
  const Authenticated({required this.credential});

  final core.AuthCredential credential;

  @override
  List<Object?> get props => [credential];
}

/// ------------------------------------------------------------------
/// 5. A type of authenticated state that indicates the user is
///    authenticated but has not completed onboarding. This state is
///    used to redirect the user to the onboarding process, which in
///    our case is the signup screen.
/// ------------------------------------------------------------------
final class OnboardingRequired extends Authenticated {
  const OnboardingRequired({required super.credential});
}

/// ------------------------------------------------------------------
/// 6. A type of authenticated state that indicates the user is
///    authenticated and has completed onboarding. This state is
///    used to redirect the user to the home screen.
/// ------------------------------------------------------------------
final class Onboarded extends Authenticated {
  const Onboarded({required super.credential});
}
