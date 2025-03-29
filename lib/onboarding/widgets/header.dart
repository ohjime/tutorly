import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorly/app/exports.dart';

class OnboardingHeader extends StatelessWidget {
  final VoidCallback? buttonPressed;
  final String? buttonText;
  final IconData buttonIcon;
  final TutorlyRole appType;
  const OnboardingHeader({
    super.key,
    required this.appType,
    required this.buttonPressed,
    required this.buttonText,
    required this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Choose background color based on the current theme mode.
    final backgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white;

    return Container(
      width: min((MediaQuery.of(context).size.width), 600),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button with icon and label "Return to Login"
          IconButton(onPressed: buttonPressed, icon: Icon(buttonIcon)),
          // Text widget for Signup Screen on the right.
          SizedBox(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.red,
                  highlightColor: Colors.yellow,
                  child: Text(
                    'TUTORLY'.toUpperCase(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                Text(
                  (appType == TutorlyRole.tutor
                          ? 'Tutor Accounts'
                          : 'Student Accounts')
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12, // Optional customization
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
