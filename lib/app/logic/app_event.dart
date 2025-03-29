// App_event.dart

part of 'app_bloc.dart';

sealed class AppEvent {}

// Public events that you dispatch from outside:
final class StartUp extends AppEvent {}

final class Logout extends AppEvent {}

final class SelectApp extends AppEvent {}

final class TutorMode extends AppEvent {}

final class StudentMode extends AppEvent {}

final class Authorize extends AppEvent {}

final class _UserChanged extends AppEvent {
  final firebase_auth.User? firebaseUser;
  _UserChanged({required this.firebaseUser});
}

final class Failure extends AppEvent {
  final String message;
  Failure(this.message);
}
