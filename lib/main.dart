import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tutorly/firebase_options.dart';
import 'package:tutorly/core/core.dart';
import 'package:tutorly/app/app.dart';
import 'package:tutorly/login/login.dart';
import 'package:tutorly/signup/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize the Bloc Observer for our Application
  Bloc.observer = CoreObserver();

  // Initialize Authentication Repository and wait for the first user's credentials
  // to be emitted.
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.credential.first;

  // Initialize User Repository
  final userRepository = UserRepository();

  runApp(
    Tutorly(
      authenticationRepository: authenticationRepository,
      userRepository: userRepository,
    ),
  );
}

class Tutorly extends StatelessWidget {
  const Tutorly({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository,
       _userRepository = userRepository;

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case '/home':
        return MaterialPageRoute(
          builder:
              (_) => Placeholder(
                child: AppButton.black(
                  text: 'Log Out',
                  onPressed: () {
                    _authenticationRepository.logOut();
                  },
                ),
              ),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final colorScheme = isDark ? darkTheme.colorScheme : lightTheme.colorScheme;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: colorScheme.primary,
        systemNavigationBarColor: colorScheme.surface,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _userRepository),
      ],
      child: AppView(onGenerateRoute: _onGenerateRoute),
    );
  }
}
