import 'package:tutorly/app/exports.dart';
import 'package:tutorly/onboarding/logic/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';

class OnboardingStepper extends StatelessWidget {
  final TutorlyRole appType;
  final OnboardingStep step;

  const OnboardingStepper({
    super.key,
    required this.step,
    required this.appType,
  });

  // Map your OnboardingStep enum to a step index.
  int _mapStepToIndex(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.user:
        return 0;
      case OnboardingStep.profile:
        return 1;
      case OnboardingStep.billing:
        return 2;
      case OnboardingStep.terms:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeStep = _mapStepToIndex(step);
    return Container(
      width: 700,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: EasyStepper(
          // loadingAnimation: 'assets/animations/shared/loading_cirle.json',
          showScrollbar: false,
          enableStepTapping:
              false, // or update your cubit if tapping is allowed
          activeStep: activeStep,
          lineStyle: LineStyle(
            activeLineColor: Colors.amber,
            finishedLineColor: Colors.deepOrange,
            unreachedLineColor: Colors.blueGrey.withValues(alpha: 0.6),
            lineLength: 100, // Adjusted to match tutorial
            lineThickness: 6,
            lineSpace: 4,
            lineType: LineType.normal,
          ),
          stepShape: StepShape.circle,
          defaultStepBorderType: BorderType.normal,
          borderThickness: 10, // Match the tutorial's border thickness
          unreachedStepBorderColor: Colors.grey[300],
          internalPadding: 15,
          stepRadius: 30,
          finishedStepTextColor: Colors.white,
          finishedStepBackgroundColor: Colors.amber,
          finishedStepBorderColor: Colors.deepOrangeAccent,
          activeStepBackgroundColor: Colors.white,
          activeStepBorderColor: Colors.amber,
          activeStepIconColor: Colors.white,
          activeStepTextColor: Colors.white,
          stepAnimationDuration: Duration(milliseconds: 300),
          stepAnimationCurve: Easing.emphasizedAccelerate,
          showLoadingAnimation: true, // If you want to show a loading indicator
          onStepReached: (index) {
            // Optionally, update your cubit here if step tapping is enabled.
            // context.read<SignupCubit>().updateStep(_mapIndexToStep(index));
          },
          steps: [
            const EasyStep(
              icon: Icon(Icons.person_add),
              title: 'Account',
              lineText: 'Create User Account',
            ),
            EasyStep(
              icon: Icon(Icons.school),
              title: 'Profile',
              lineText:
                  appType == TutorlyRole.tutor
                      ? 'Provide Tutor Details'
                      : 'Provide Student Details',
            ),
            const EasyStep(
              icon: Icon(Icons.payment),
              title: 'Billing',
              lineText: 'Add Billing\nDetails',
            ),
            const EasyStep(
              icon: Icon(Icons.check_circle_outline),
              title: 'Terms',
              lineText: 'Agree to Terms and Conditions',
            ),
          ],
        ),
      ),
    );
  }
}
