part of 'app_bloc.dart';

// The base sealed class for all App states.
sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

/// Example: If you need an initial or idle state (e.g., the app just started).
final class AppInitial extends AppState {}

/// User starts app by viewing the Introduction Animation.
final class NewbieIntro extends AppInitial {}

/// User starts app by viewing the Standard Get Started Screen.
final class RegularIntro extends AppInitial {}

/// User app is not in inital state and is unselected.
final class AppUnselected extends AppState {}

// The different app modes of Tutorly.
enum TutorlyRole { tutor, student }

// User App Type has been defined.
final class AppSelected extends AppState {
  final TutorlyRole appType;

  const AppSelected({required this.appType});

  @override
  List<Object> get props => [appType];
}

/// State representing an unauthenticated user (explicitly).
final class AppUnauthenticated extends AppSelected {
  const AppUnauthenticated({required super.appType});
}

/// Common parent class for all “authenticated” states.
/// It stores the user and the app mode.
sealed class AppAuthenticated extends AppSelected {
  final firebase_auth.User fbuser;

  const AppAuthenticated({required this.fbuser, required super.appType});

  @override
  List<Object> get props => [fbuser, appType];
}

/// The user is authenticated by Firebase, but is not yet authorized
/// to proceed to the home screen of TutorlyRole because they do not have a
/// TutorlyUser Account.
final class OnlyAuthenticated extends AppAuthenticated {
  const OnlyAuthenticated({required super.fbuser, required super.appType});
}

/// The user is fully authenticated AND has a complete profile and
/// is authorized to proceed to the home screen of TutorlyRole
final class FullyAuthorized extends AppAuthenticated {
  const FullyAuthorized({required super.fbuser, required super.appType});
}

/// User is being Onboarded to the app (Tutorial Screen).
final class AppOnboarding extends AppAuthenticated {
  const AppOnboarding({required super.fbuser, required super.appType});
}

/// User encountered a critical error or undefined behaviour.
/// This state can only be reached by sending a [Failure] event
/// to [AppBloc]. When this state is reached, the app will display
/// an error message to the user, then Terminate itself.
/// Not to be used for non-critical errors, instead handle those
/// errors at the feature level.
final class AppError extends AppState {
  final String message;
  const AppError(this.message);

  @override
  List<Object> get props => [message];
}

/// Global state to represent the app exiting.
final class AppExit extends AppState {}
