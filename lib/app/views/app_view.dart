import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorly/app/exports.dart';
import 'package:tutorly/intro/exports.dart';
import 'package:tutorly/onboarding/exports.dart';
import 'package:tutorly/portal/exports.dart';
import 'package:tutorly/shared/exports.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});
  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  // Use this variable to keep track of the current route.
  String? _currentRoute;
  NavigatorState get _navigator => _navigatorKey.currentState!;
  // Helper to push a route only if it's different from the current one.
  void _pushRouteIfNeeded(String routeName, Route<dynamic> route) {
    if (_currentRoute != routeName) {
      _navigator.pushAndRemoveUntil<void>(route, (route) => false);
      _currentRoute = routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AppBloc(
            authRepo: context.read<AuthenticationRepository>(),
            tutorRepo: context.read<TutorRepository>(),
            userRepo: context.read<UserRepository>(),
            studentRepo: context.read<StudentRepository>(),
          )..add(StartUp()),
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        title: 'Tutorly',
        home: BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            // Depending on your state, push the appropriate route.
            if (state is AppInitial) {
              _pushRouteIfNeeded('intro', IntroPage.route());
            } else if (state is AppUnselected) {
              _pushRouteIfNeeded('selectApp', SelectAppPage.route());
            } else if (state is AppSelected) {
              if (state is AppUnauthenticated) {
                _pushRouteIfNeeded('authenticate', PortalPage.route());
              } else if (state is AppAuthenticated) {
                if (state is OnlyAuthenticated) {
                  _pushRouteIfNeeded('signup', OnboardingPage.route());
                } else if (state is FullyAuthorized) {
                  _pushRouteIfNeeded('dashboard', Dashboard.route());
                } else {
                  context.read<AppBloc>().add(
                    Failure(
                      "A System Error Occurred. If you see this, please contact our support team.",
                    ),
                  );
                }
              }
            } else if (state is AppError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AppExit) {
              SystemNavigator.pop();
            }
          },
          child: Navigator(
            key: _navigatorKey,
            onGenerateRoute: (_) {
              // The default route; typically a splash or loading screen.
              return MaterialPageRoute(
                builder:
                    (context) => Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    ),
              );
            },
          ),
        ),
      ),
    );
  }
}
