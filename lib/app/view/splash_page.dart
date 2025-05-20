import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    debugPrint('SplashPage build called');
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
