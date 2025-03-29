import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorly/app/logic/app_bloc.dart';

class SelectAppPage extends StatelessWidget {
  const SelectAppPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SelectAppPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TODO\n Come up with a Design for a Select Screen\n\n',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 200,
              child: Text(
                "Please select your role to continue.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AppBloc>().add(StudentMode());
              },
              child: const Text(
                "I'm a Student",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AppBloc>().add(TutorMode());
              },
              child: const Text("I'm a Tutor", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
