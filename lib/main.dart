// =================== Imports =================== //

// External Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This import will give you access to the all of Tutorly's
// repositories, models, widgets, utils, themes, and providers.
import 'package:tutorly/shared/exports.dart';

// By default, the App() widget to be exported to main.dart for
// execution is located in the lib/app/exports.dart file.

// If you want to run a different App() to preview a feature
// during development, comment out the Main App Line and uncomment
// the Feature Preview Line, and change '<feature>' to the name
// of the feature you want to preview.

// Main App Line
import 'package:tutorly/app/exports.dart';

// Feature Preview Line
// import 'package:tutorly/portal/preview.dart';
// import 'package:tutorly/schedule/preview.dart';
// import 'package:tutorly/onboarding/preview.dart';
// import 'package:tutorly/into/preview.dart';
// import 'package:tutorly/<feature>/preview.dart';

// ================= End Imports ================= //

// =================== Logging =================== //

// This is a custom observer that will print all State transitions.
class GlobalObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}

// ================ End Logging ================== //

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // You need to generate the Firebase Options first. For more information,
  // visit: https://firebase.google.com/docs/flutter/setup?platform=web

  // Initialize Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize the Bloc Observer for our Application
  Bloc.observer = GlobalObserver();

  // Initialize Authentication Repository and wait for the first user to be emitted.
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  // Initialize User Repository
  final userRepository = UserRepository();

  // Initialize Tutor Repository
  final tutorRepository = TutorRepository();

  // Initialize Student Repository
  final studentRepository = StudentRepository();

  runApp(
    App(
      authRepo: authenticationRepository,
      userRepo: userRepository,
      tutorRepo: tutorRepository,
      studentRepo: studentRepository,
    ),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authRepo,
    required this.tutorRepo,
    required this.userRepo,
    required this.studentRepo,
  });

  final AuthenticationRepository authRepo;
  final UserRepository userRepo;
  final TutorRepository tutorRepo;
  final StudentRepository studentRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(value: authRepo),
        RepositoryProvider<UserRepository>.value(value: userRepo),
        RepositoryProvider<TutorRepository>.value(value: tutorRepo),
        RepositoryProvider<StudentRepository>.value(value: studentRepo),
      ],
      child: const AppView(),
    );
  }
}
