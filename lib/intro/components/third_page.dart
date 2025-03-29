import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

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
            delay: Duration(milliseconds: 500),
            fadeIn: true,
            fadingDuration: Duration(milliseconds: 500),
            slidingBeginOffset: Offset(0, 0.1),
            child: SizedBox(
              height: 500,
              width: min(MediaQuery.of(context).size.width * 0.8, 400),
              child:
                  RiveAnimation.asset('assets/animations/onboarding/books.riv'),
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
                    TypewriterAnimatedText('With the power of AI',
                        textAlign: TextAlign.center),
                    TypewriterAnimatedText('Tutorly can record your sessions',
                        textAlign: TextAlign.center),
                    TypewriterAnimatedText('And save them for review!',
                        textAlign: TextAlign.center),
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
