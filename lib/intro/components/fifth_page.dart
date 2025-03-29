import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tutorly/app/exports.dart';

class FifthPage extends StatelessWidget {
  const FifthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Rive animation positioned above the text
        Positioned(
          bottom: min(
            (MediaQuery.of(context).size.height * 0.25),
            200,
          ), // leave space at the bottom for the text
          child: DelayedDisplay(
            delay: Duration(milliseconds: 500),
            fadeIn: true,
            fadingDuration: Duration(milliseconds: 500),
            slidingBeginOffset: Offset(0, 0.05),
            child: SizedBox(
              height: 500,
              width: min(MediaQuery.of(context).size.width * 0.8, 400),
              child: RiveAnimation.asset(
                'assets/animations/onboarding/pencil.riv',
              ),
            ),
          ),
        ),
        // Animated text placed at the bottom
        Positioned(
          bottom: min((MediaQuery.of(context).size.height * 0.25), 180),
          child: DelayedDisplay(
            delay: Duration(milliseconds: 100),
            fadeIn: true,
            fadingDuration: Duration(milliseconds: 500),
            slidingBeginOffset: Offset(-0.01, 0),
            child: SizedBox(
              width: min(MediaQuery.of(context).size.width * 0.8, 480),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.displayMedium ?? TextStyle(),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Sharpen Your Pencils!',
                      textAlign: TextAlign.center,
                    ),
                    TypewriterAnimatedText(
                      'Join Tutorly Today!',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: min((MediaQuery.of(context).size.height * 0.15), 80),
          child: DelayedDisplay(
            delay: Duration(milliseconds: 100),
            fadeIn: true,
            fadingDuration: Duration(milliseconds: 500),
            slidingBeginOffset: Offset(-0.01, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10,
                ),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                context.read<AppBloc>().add(SelectApp());
              },
              child: Shimmer.fromColors(
                baseColor: Colors.blue,
                highlightColor: Colors.blueGrey,
                child: Text('Click to Start'.toUpperCase()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
