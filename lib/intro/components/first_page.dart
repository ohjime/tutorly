import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:tutorly/shared/exports.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Rive animation positioned above the text
        Positioned(
          bottom: min(
            (MediaQuery.of(context).size.height * 0.20),
            200,
          ), // leave space at the bottom for the text
          child: DelayedDisplay(
            delay: Duration(milliseconds: 500),
            fadeIn: true,
            fadingDuration: Duration(milliseconds: 500),
            slidingBeginOffset: Offset(0, 0.1),
            child: SizedBox(
              height: 400,
              width: min(MediaQuery.of(context).size.width * 0.8, 400),
              child: TutorlyLogo(),
            ),
          ),
        ),
        // Animated text placed at the bottom
        Positioned(
          bottom: min((MediaQuery.of(context).size.height * 0.15), 100),
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
                      'Hey There!',
                      textAlign: TextAlign.center,
                    ),
                    TypewriterAnimatedText(
                      'Welcome to Tutorly',
                      textAlign: TextAlign.center,
                    ),
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
