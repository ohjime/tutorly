import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tutorly/shared/exports.dart';

// Assume these are all exported via your `App/_exports.dart`
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authRepo;
  final TutorRepository _tutorRepo;
  final UserRepository _userRepo;
  final StudentRepository _studentRepo;
  late final StreamSubscription<firebase_auth.User?> _userSubscription;

  AppBloc({
    required AuthenticationRepository authRepo,
    required TutorRepository tutorRepo,
    required UserRepository userRepo,
    required StudentRepository studentRepo,
  }) : _authRepo = authRepo,
       _tutorRepo = tutorRepo,
       _userRepo = userRepo,
       _studentRepo = studentRepo,
       super(AppInitial()) {
    // Register event handlers:
    on<StartUp>(_onStartUp);
    on<_UserChanged>(_onUserChanged);
    on<Logout>(_onLogout);
    on<SelectApp>(_onSelectApp);
    on<TutorMode>(_onTutorMode);
    on<StudentMode>(_onStudentMode);
    on<Failure>(_onFailure);

    _userSubscription = _authRepo.user.listen((firebaseUser) {
      add(_UserChanged(firebaseUser: firebaseUser));
    });
  }

  /// Handles the initial "boot up" event.
  Future<void> _onStartUp(StartUp event, Emitter<AppState> emit) async {
    await Future.delayed(Duration(seconds: 4));
    emit(NewbieIntro());
  }

  /// Handles the event for selecting the app type.
  Future<void> _onSelectApp(SelectApp event, Emitter<AppState> emit) async {
    emit(AppUnselected());
  }

  Future<void> _onTutorMode(TutorMode event, Emitter<AppState> emit) async {
    emit(AppUnauthenticated(appType: TutorlyRole.tutor));
  }

  Future<void> _onStudentMode(StudentMode event, Emitter<AppState> emit) async {
    emit(AppUnauthenticated(appType: TutorlyRole.student));
  }

  Future<void> _onUserChanged(
    _UserChanged event,
    Emitter<AppState> emit,
  ) async {
    if (state is AppSelected && event.firebaseUser != null) {
      final fbuser = event.firebaseUser!;
      final appType = (state as AppSelected).appType;
      if (await _userRepo.checkUserExists(uid: fbuser.uid) == false) {
        return emit(OnlyAuthenticated(fbuser: fbuser, appType: appType));
      } else {
        switch (appType) {
          case TutorlyRole.tutor:
            if (await _tutorRepo.checkTutorExists(uid: fbuser.uid) == false) {
              return emit(FullyAuthorized(fbuser: fbuser, appType: appType));
            } else {
              return emit(OnlyAuthenticated(fbuser: fbuser, appType: appType));
            }
          case TutorlyRole.student:
            if (await _studentRepo.checkStudentExists(uid: fbuser.uid)) {
              return emit(FullyAuthorized(fbuser: fbuser, appType: appType));
            } else {
              return emit(OnlyAuthenticated(fbuser: fbuser, appType: appType));
            }
        }
      }
    } else if (state is AppInitial && event.firebaseUser != null) {
      emit(AppUnselected());
    }
  }

  /// Event handler for logging out.
  Future<void> _onLogout(Logout event, Emitter<AppState> emit) async {
    try {
      await _authRepo.logOut();
      emit(AppUnselected());
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  /// Handler for the generic 'Failed' event => emits a AppError
  Future<void> _onFailure(Failure event, Emitter<AppState> emit) async {
    emit(AppError(event.message));
  }

  /// As soon as we emit or add any event, always handle cancellation
  /// of the subscription upon close.
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
