import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorly/app/exports.dart';
import 'package:tutorly/shared/exports.dart';
import 'package:tutorly/portal/exports.dart';

class PortalPage extends StatefulWidget {
  const PortalPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PortalPage());
  }

  @override
  State<PortalPage> createState() => _PortalPageState();
}

class _PortalPageState extends State<PortalPage> {
  @override
  Widget build(BuildContext context) {
    TutorlyRole appType =
        (context.read<AppBloc>().state as AppSelected).appType;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create:
            (context) =>
                PortalCubit(authRepo: context.read<AuthenticationRepository>()),
        child: BlocListener<PortalCubit, PortalState>(
          listener: (context, state) {
            if (state.status == PortalStatus.error) {
              AwesomeDialog(
                keyboardAware: true,
                dismissOnTouchOutside: true,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                dialogBorderRadius: BorderRadius.all(Radius.circular(30)),
                transitionAnimationDuration: Duration(milliseconds: 100),
                width: 400,
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.scale,
                titleTextStyle: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.black),
                descTextStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.black),
                title:
                    context.read<PortalCubit>().state.mode == PortalMode.login
                        ? 'Login Error'
                        : 'Signup Error',
                desc: state.message,
                btnOkText: "Try Again",
                // When OK is pressed, reset the state.
                btnOkOnPress: () {
                  context.read<PortalCubit>().resetError();
                },
              ).show();
            }
          },
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: BlocBuilder<PortalCubit, PortalState>(
                          builder: (context, state) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child:
                                  context.watch<PortalCubit>().state.mode ==
                                          PortalMode.signup
                                      ? SizedBox.shrink()
                                      : SizedBox(
                                        height: 100,
                                        width: min(
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                          400,
                                        ),
                                        child: TutorlyLogo(),
                                      ),
                            );
                          },
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.red,
                        highlightColor: Colors.yellow,
                        child: Text(
                          'TUTORLY'.toUpperCase(),
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Text(
                        (appType == TutorlyRole.tutor
                                ? 'Tutor Portal'
                                : 'Student Portal')
                            .toUpperCase(),
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold, // Optional customization
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: min(MediaQuery.of(context).size.width * 0.9, 500),
                    child: BlocBuilder<PortalCubit, PortalState>(
                      builder: (context, state) {
                        return AnimatedSize(
                          duration: const Duration(milliseconds: 100),
                          reverseDuration: const Duration(milliseconds: 200),
                          child: AnimatedSwitcher(
                            reverseDuration: const Duration(milliseconds: 100),
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, anim) {
                              // Check if this widget is leaving (animation running in reverse)
                              if (anim.status == AnimationStatus.reverse) {
                                // Outgoing animation:
                                // Fade out and scale to 0.9 immediately, and then slide up slightly after a delay.
                                final fadeAnim = Tween<double>(
                                  begin: 1.0,
                                  end: 0.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: anim,
                                    curve: Curves.easeIn,
                                  ),
                                );
                                final scaleAnim = Tween<double>(
                                  begin: 1.0,
                                  end: 0.9,
                                ).animate(
                                  CurvedAnimation(
                                    parent: anim,
                                    curve: Curves.easeIn,
                                  ),
                                );
                                // Delay the slide by using an Interval so the movement happens near the end.
                                final slideAnim = Tween<Offset>(
                                  begin: Offset.zero,
                                  end: const Offset(0, -0.1),
                                ).animate(
                                  CurvedAnimation(
                                    parent: anim,
                                    curve: const Interval(
                                      0.7,
                                      1.0,
                                      curve: Curves.easeIn,
                                    ),
                                  ),
                                );

                                return SlideTransition(
                                  position: slideAnim,
                                  child: FadeTransition(
                                    opacity: fadeAnim,
                                    child: ScaleTransition(
                                      scale: scaleAnim,
                                      child: child,
                                    ),
                                  ),
                                );
                              } else {
                                // Incoming animation:
                                // Determine slide direction based on the child's key.
                                // For the first child, slide from below (i.e. moving upward into place).
                                // For the second child, slide from above (i.e. moving downward into place).
                                Offset beginOffset;
                                if (child.key == const ValueKey('first')) {
                                  beginOffset = const Offset(0, 0.2);
                                } else if (child.key ==
                                    const ValueKey('second')) {
                                  beginOffset = const Offset(0, -0.2);
                                } else {
                                  beginOffset = Offset.zero;
                                }
                                final slideAnim = Tween<Offset>(
                                  begin: beginOffset,
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: anim,
                                    curve: Curves.easeOut,
                                  ),
                                );
                                final fadeAnim = Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: anim,
                                    curve: Curves.easeOut,
                                  ),
                                );
                                final scaleAnim = Tween<double>(
                                  begin: 0.9,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: anim,
                                    curve: Curves.easeOut,
                                  ),
                                );
                                return SlideTransition(
                                  position: slideAnim,
                                  child: FadeTransition(
                                    opacity: fadeAnim,
                                    child: ScaleTransition(
                                      scale: scaleAnim,
                                      child: child,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: getPortalForm(
                              mode: context.watch<PortalCubit>().state.mode,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  PortalDivider(),
                  BlocBuilder<PortalCubit, PortalState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: getPortalOptions(
                          mode: context.watch<PortalCubit>().state.mode,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getPortalForm({required PortalMode mode}) {
    if (mode == PortalMode.login) {
      return LoginForm(key: ValueKey('loginForm'));
    } else if (mode == PortalMode.signup) {
      return SignupForm(key: ValueKey('signupForm'));
    } else {
      return Container();
    }
  }

  getPortalOptions({required PortalMode mode}) {
    if (mode == PortalMode.login) {
      return LoginOptions(key: ValueKey('loginOptions'));
    } else if (mode == PortalMode.signup) {
      return SignupOptions(key: ValueKey('signupOptions'));
    } else {
      return Container();
    }
  }
}
