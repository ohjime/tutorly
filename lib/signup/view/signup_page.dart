import 'dart:ui';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:toastification/toastification.dart';

import 'package:tutorly/app/app.dart';
import 'package:tutorly/core/core.dart';
import 'package:tutorly/signup/signup.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  late final SignupWizard wizard;
  final steps = signupSteps;
  late final List<GlobalKey<FormBuilderState>> formKeys;

  // Animation controller for bottom navigation bar
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    wizard = SignupWizard(initialSpeech: steps[currentStep].dialogue);
    formKeys = steps.map((e) => GlobalKey<FormBuilderState>()).toList();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Update animation state based on current step
  void _updateNavigationBarVisibility() {
    // If last step, hide the navigation bar
    if (currentStep == steps.length - 1) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure animation state matches current step
    _updateNavigationBarVisibility();

    return BlocProvider(
      create: (context) => SignupCubit(),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.failure) {
            String errorMessage = 'An unknown error occurred.';
            if (state.error != null) {
              errorMessage = state.error.toString();
            }
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flat,
              title: const Text('Error'),
              description: Text(errorMessage),
              alignment: Alignment.topRight,
              autoCloseDuration: const Duration(seconds: 4),
              animationBuilder: (context, animation, alignment, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(225),
            child: AppBar(
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Theme.of(
                context,
              ).scaffoldBackgroundColor.withValues(alpha: 0.5),
              elevation: 0,
              title: SignupProgressBar(
                currentStep: currentStep,
                totalSteps: steps.length,
                context: context,
              ),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      // If not in the first step, we want this button to simply go back
                      // to the previous step.
                      if (currentStep > 0) {
                        setState(() {
                          currentStep--;
                          // Skip steps that shouldn't be shown in reverse
                          while (currentStep > 0 &&
                              steps[currentStep].showIf(context) != true) {
                            currentStep--;
                          }
                          // First step is always shown, but check just to be safe
                          if (currentStep >= 0 && currentStep < steps.length) {
                            wizard.say(steps[currentStep].dialogue);
                          }
                        });
                      } else {
                        // When at the first step, we want to go back to the welcome page
                        // Sometimes you will be in this page because you were logged
                        // in but not authroized, so there will be no navigation stack,
                        // so in order to go back we would have to log out to be routed
                        // back to the wlecomepage.
                        Navigator.pop(context);
                        if (context.read<AppBloc>().state is Authenticated) {
                          context.read<AppBloc>().add(LogoutPressed());
                        }
                      }
                    },
                    icon: Icon(Icons.arrow_back),
                  );
                },
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(170),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    wizard,
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      switchOutCurve: Curves.easeIn,
                      switchInCurve: Curves.easeIn,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        key: ValueKey<int>(currentStep),
                        child: DelayedDisplay(
                          delay: const Duration(milliseconds: 300),
                          fadingDuration: const Duration(milliseconds: 300),
                          fadeIn: true,
                          slidingBeginOffset: const Offset(0, 0.02),
                          child: Text(
                            steps[currentStep].title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          body: SignupSwitcher(
            currentStep: currentStep,
            steps: steps,
            formKeys: formKeys,
          ),
          bottomNavigationBar: SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: _animationController.drive(
              Tween<double>(
                begin: 1.0,
                end: 0.0,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: SlideTransition(
              position: _animationController.drive(
                Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0, 1),
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SafeArea(
                  child: Builder(
                    builder: (context) {
                      return AnimatedPadding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        duration: const Duration(microseconds: 300),
                        curve: Curves.easeInQuad,
                        child: Material(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: Curves.easeInQuad,
                              switchOutCurve: Curves.easeInQuad,
                              transitionBuilder: (child, animation) {
                                // if the incoming child is our NEXT button, slide UP from below (Offset(0,1)→Offset.zero)
                                // if it’s the “empty” placeholder, slide DOWN out of view (Offset.zero→Offset(0,1))
                                final isNextButton =
                                    child.key == const ValueKey('next');
                                final tween =
                                    isNextButton
                                        ? Tween<Offset>(
                                          begin: const Offset(0, 1),
                                          end: Offset.zero,
                                        )
                                        : Tween<Offset>(
                                          begin: Offset.zero,
                                          end: const Offset(0, 1),
                                        );
                                return SlideTransition(
                                  position: animation
                                      .drive(
                                        CurveTween(curve: Curves.easeInOut),
                                      )
                                      .drive(tween),
                                  child: child,
                                );
                              },
                              child:
                                  currentStep < steps.length - 1
                                      // ── CASE A: non‑last step → show “NEXT”
                                      ? AppButton.primary(
                                        key: const ValueKey('next'),
                                        text: 'NEXT',
                                        onPressed: () {
                                          final formKey = formKeys[currentStep];
                                          if (!formKey.currentState!
                                              .saveAndValidate())
                                            return;
                                          steps[currentStep].callback(
                                            context,
                                            formKey.currentState!.value,
                                          );
                                          setState(() {
                                            // advance to the next visible step
                                            currentStep++;
                                            while (currentStep < steps.length &&
                                                steps[currentStep].showIf(
                                                      context,
                                                    ) !=
                                                    true) {
                                              currentStep++;
                                            }
                                            if (currentStep < steps.length) {
                                              wizard.say(
                                                steps[currentStep].dialogue,
                                              );
                                            }
                                          });
                                        },
                                      )
                                      // ── CASE B: last step → replace with an invisible placeholder
                                      : SizedBox(
                                        key: const ValueKey('empty'),
                                        height:
                                            48, // match your button’s height so things don’t jump
                                      ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
