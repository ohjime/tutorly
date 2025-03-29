import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Rive animation positioned above the text
        Positioned(
          bottom: min((MediaQuery.of(context).size.height * 0.3),
              600), // leave space at the bottom for the text
          child: DelayedDisplay(
            delay: Duration(milliseconds: 300),
            fadeIn: true,
            fadingDuration: Duration(milliseconds: 500),
            slidingBeginOffset: Offset(0, 0.1),
            child: SizedBox(
              height: 500,
              width: min(MediaQuery.of(context).size.width * 0.8, 400),
              child: RiveAnimation.asset(
                  'assets/animations/onboarding/teacher.riv'),
            ),
          ),
        ),
        // Animated text placed at the bottom
        Positioned(
          bottom: min((MediaQuery.of(context).size.height * 0.15), 150),
          child: DelayedDisplay(
            delay: Duration(milliseconds: 100),
            fadeIn: true,
            fadingDuration: Duration(milliseconds: 500),
            slidingBeginOffset: Offset(-0.01, 0),
            child: SizedBox(
              width: min(MediaQuery.of(context).size.width * 0.8, 400),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.displayMedium ?? TextStyle(),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                        'Let Tutorly help you find the right tutor',
                        textAlign: TextAlign.center),
                    TypewriterAnimatedText('We match Aspiring Students',
                        textAlign: TextAlign.center),
                    TypewriterAnimatedText('To Qualified Local Tutors',
                        textAlign: TextAlign.center),
                    TypewriterAnimatedText(
                        'Using our Automatic Matching System',
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
