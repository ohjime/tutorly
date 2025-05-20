import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tutorly/signup/widgets/signup_steps.dart';

class SignupSwitcher extends StatelessWidget {
  const SignupSwitcher({
    super.key,
    required this.currentStep,
    required this.steps,
    required this.formKeys,
  });

  final int currentStep;
  final List<SignupStep> steps;
  final List<GlobalKey<FormBuilderState>> formKeys;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchOutCurve: Curves.easeIn,
      switchInCurve: Curves.easeIn,
      layoutBuilder:
          (currentChild, previousChildren) => Stack(
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          ),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: const Offset(0, 0),
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        key: ValueKey<int>(currentStep),
        child: DelayedDisplay(
          delay: const Duration(milliseconds: 400),
          fadingDuration: const Duration(milliseconds: 400),
          fadeIn: true,
          slidingBeginOffset: const Offset(0, 0.03),
          child: Builder(
            builder: (context) {
              return steps[currentStep].builder(context, formKeys[currentStep]);
            },
          ),
        ),
      ),
    );
  }
}
