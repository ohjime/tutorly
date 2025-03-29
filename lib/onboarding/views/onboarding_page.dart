import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/foundation.dart';
import 'package:tutorly/app/exports.dart';
import 'package:tutorly/onboarding/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorly/shared/exports.dart';
import 'package:tutorly/onboarding/exports.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const OnboardingPage());
  }

  // Helper Method to return the appropriate widget for each signup step.
  Widget _buildStepContent({
    required OnboardingStep step,
    required TutorlyRole appType,
    required BuildContext context,
    required String uid,
    required bool loading,
  }) {
    switch (step) {
      case OnboardingStep.user:
        return UserProfileForm(uid: uid, key: ValueKey('user'));
      case OnboardingStep.profile:
        if (appType == TutorlyRole.tutor) {
          return TutorProfileForm(uid: uid, key: ValueKey('profile_tutor'));
        } else if (appType == TutorlyRole.student) {
          return StudentProfileForm(uid: uid, key: ValueKey('profile_student'));
        }
      case OnboardingStep.billing:
        // if tutor return billing form else return banking form
        if (appType == TutorlyRole.tutor) {
          return BankingForm(uid: uid, key: ValueKey('billing'));
        } else if (appType == TutorlyRole.student) {
          return BillingForm(uid: uid, key: ValueKey('banking'));
        }
      case OnboardingStep.terms:
        return AgreementForm(
          appType: appType,
          uid: uid,
          key: ValueKey('confirm'),
        );
    }
    // Return an empty container if the step is not recognized.
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => OnboardingCubit(
            userRepo: context.read<UserRepository>(),
            tutorRepo: context.read<TutorRepository>(),
            studentRepo: context.read<StudentRepository>(),
          ),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final coreSnapShot =
              context.read<AppBloc>().state as AppAuthenticated;
          final uid = coreSnapShot.fbuser.uid;
          final appType = coreSnapShot.appType;
          return Scaffold(
            body:
                state.loading
                    ? DelayedDisplay(
                      delay: Duration(milliseconds: 500),
                      fadeIn: true,
                      fadingDuration: Duration(milliseconds: 500),
                      slidingBeginOffset: Offset(0, 0.1),
                      child: SeekingIndicator(),
                    )
                    : Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        constraints: BoxConstraints(
                          maxHeight: double.infinity,
                          minHeight:
                              kIsWeb ? 0 : MediaQuery.of(context).size.height,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 60),
                            OnboardingHeader(
                              appType: appType,
                              buttonPressed: () {
                                context.read<AppBloc>().add(Logout());
                              },
                              buttonText: '',
                              buttonIcon: Icons.cancel_sharp,
                            ),
                            OnboardingStepper(
                              step: state.step!,
                              appType: appType,
                            ),
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                width: 600,
                                child: SingleChildScrollView(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: _buildStepContent(
                                      uid: uid,
                                      appType: appType,
                                      step: state.step!,
                                      loading: state.loading,
                                      context: context,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          );
        },
      ), // Now Onboarding is a descendant.
    );
  }
}
