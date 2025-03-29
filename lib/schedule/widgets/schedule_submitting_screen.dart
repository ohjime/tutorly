import 'dart:ui';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ScheduleSubmittingScreen extends StatelessWidget {
  const ScheduleSubmittingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.shade200.withAlpha(100)),
          child: Center(
            child: DelayedDisplay(
              delay: const Duration(milliseconds: 100),
              fadeIn: true,
              child: SizedBox(
                width: 400,
                height: 400,
                child: const RiveAnimation.asset(
                  'assets/animations/shared/google_loading.riv',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
