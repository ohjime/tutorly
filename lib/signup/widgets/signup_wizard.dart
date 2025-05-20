import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'dart:math' as math;
import 'package:speech_balloon/speech_balloon.dart';

// GlobalKey approach to access the state
class SignupWizard extends StatefulWidget {
  final List<String> initialSpeech;
  SignupWizard({Key? key, this.initialSpeech = const ['']})
    : super(key: GlobalKey<_SignupWizardState>());

  void say(List<String> text) {
    // Get the current state using the global key
    final state = (key as GlobalKey<_SignupWizardState>).currentState;
    if (state != null) {
      state._say(text);
    }
  }

  @override
  State<SignupWizard> createState() => _SignupWizardState();
}

class _SignupWizardState extends State<SignupWizard> {
  late final SMITrigger _write;
  late List<String> _speechText;

  @override
  void initState() {
    super.initState();
    _speechText = widget.initialSpeech;
  }

  // Internal method to update text and trigger animation
  void _say(List<String> text) {
    setState(() {
      _speechText = text;
    });

    // Give a small delay before triggering the animation
    Future.delayed(const Duration(milliseconds: 100), () {
      _write.fire();
    });
  }

  void _onRiveInit(Artboard art) {
    final sm = StateMachineController.fromArtboard(art, 'State Machine 1')!;
    art.addController(sm);
    _write = sm.findInput<bool>('write') as SMITrigger;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          SizedBox(
            height: 120,
            width: 90,
            child: OverflowBox(
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              alignment: Alignment.center,
              child: DelayedDisplay(
                delay: const Duration(milliseconds: 500),
                fadeIn: true,
                fadingDuration: const Duration(milliseconds: 100),
                slidingBeginOffset: const Offset(-0.5, -0.7),
                child: Transform.rotate(
                  angle: math.pi / 9, // adjust rotation in radians
                  child: SizedBox(
                    width: 120, // adjust this value for total diameter
                    height: 120, // adjust this to match desired circle size
                    child: RiveAnimation.asset(
                      'assets/animations/onboarding/books.riv',
                      stateMachines: const ['State Machine 1'],
                      onInit: _onRiveInit,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: DelayedDisplay(
              delay: const Duration(milliseconds: 1000),
              fadingDuration: const Duration(milliseconds: 800),
              slidingBeginOffset: const Offset(-0.02, 0),
              fadeIn: true,
              slidingCurve: Curves.easeInOut,
              child: SpeechBalloon(
                borderRadius: 20,
                borderColor: Theme.of(context).colorScheme.secondary,
                borderWidth: 4,
                height: 90,
                offset: const Offset(0, 10),
                nipLocation: NipLocation.left,
                color: Theme.of(context).colorScheme.surfaceBright,
                width: MediaQuery.of(context).size.width - 130,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: AnimatedTextKit(
                      key: UniqueKey(),
                      isRepeatingAnimation: false,
                      animatedTexts: List.generate(
                        _speechText.length,
                        (index) => TypewriterAnimatedText(
                          _speechText[index],
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
