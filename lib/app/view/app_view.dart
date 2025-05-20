import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorly/app/app.dart';
import 'package:tutorly/core/core.dart';

class AppView extends StatefulWidget {
  const AppView({super.key, required this.onGenerateRoute});
  final Route? Function(RouteSettings settings) onGenerateRoute;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final AppBloc _bloc;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    _bloc = AppBloc(
      authenticationRepository: context.read<AuthenticationRepository>(),
      userRepository: context.read<UserRepository>(),
    );
    // Delay the subscription request until after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(CredentialSubscriptionRequested());
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        navigatorKey: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: widget.onGenerateRoute,
        builder: (context, child) {
          return BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              switch (state) {
                case Unauthenticated():
                  _navigator.pushNamedAndRemoveUntil('/welcome', (_) => false);
                case Authenticated():
                  if (state is OnboardingRequired) {
                    _navigator.pushNamedAndRemoveUntil('/signup', (_) => false);
                    break;
                  } else if (state is Onboarded) {
                    _navigator.pushNamedAndRemoveUntil('/home', (_) => false);
                    break;
                  }
                  break;
                default:
                  // go back to the welcome screen if state is not handled
                  _navigator.pushNamedAndRemoveUntil('/welcome', (_) => false);
              }
            },
            child: child,
          );
        },
      ),
    );
  }
}
