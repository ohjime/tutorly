import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class FourthPage extends StatelessWidget {
  const FourthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Rive animation positioned above the text
        Positioned(
          bottom: min((MediaQuery.of(context).size.height * 0.28),
              600), // leave space at the bottom for the text
          child: DelayedDisplay(
            delay: Duration(milliseconds: 300),
            fadeIn: true,
            fadingDuration: Duration(milliseconds: 500),
            slidingBeginOffset: Offset(0, 0.05),
            child: SizedBox(
              height: 500,
              width: min(MediaQuery.of(context).size.width * 0.8, 400),
              child: RiveAnimation.asset(
                  'assets/animations/onboarding/cooked.riv'),
            ),
          ),
        ),
        // Animated text placed at the bottom
        Positioned(
          bottom: min((MediaQuery.of(context).size.height * 0.1), 150),
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
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText('Are you finding yourself lost?',
                        textAlign: TextAlign.center),
                    TypewriterAnimatedText(
                        'Or as Dr. Elsaadany would say . . . . ',
                        textAlign: TextAlign.center),
                    TypewriterAnimatedText('. . . . . ',
                        textAlign: TextAlign.center),
                    TypewriterAnimatedText('Cooked.',
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
