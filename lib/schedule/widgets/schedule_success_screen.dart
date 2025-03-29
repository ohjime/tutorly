import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ScheduleSuccessScreen extends StatelessWidget {
  const ScheduleSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: Column(
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: const RiveAnimation.asset(
                'assets/animations/shared/success.riv',
                speedMultiplier: 0.7,
              ),
            ),
            DelayedDisplay(
              delay: const Duration(milliseconds: 500),
              fadeIn: true,
              slidingBeginOffset: const Offset(0, 0.5),
              child: Text(
                'Schedule Created Successfully',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Button To pop the navigator and go back
            DelayedDisplay(
              delay: const Duration(milliseconds: 1000),
              fadeIn: true,
              slidingBeginOffset: const Offset(0, 0.02),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Return To App'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
