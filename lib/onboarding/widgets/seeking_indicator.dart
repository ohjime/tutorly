import 'package:tutorly/app/exports.dart';
import 'package:tutorly/onboarding/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeekingIndicator extends StatefulWidget {
  const SeekingIndicator({super.key});

  @override
  State<SeekingIndicator> createState() => _SeekingIndicatorState();
}

class _SeekingIndicatorState extends State<SeekingIndicator> {
  @override
  void initState() {
    super.initState();
    // Use a post frame callback to safely access the context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Read the uid from CoreBloc via the context
      final coreSnap = context.read<AppBloc>().state as AppAuthenticated;
      final uid = coreSnap.fbuser.uid;
      // Trigger the onboarding event
      context.read<OnboardingCubit>().seekStartStep(uid: uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Getting Signup Information...'),
        ],
      ),
    );
  }
}
