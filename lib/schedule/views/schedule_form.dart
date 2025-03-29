import 'dart:ui';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorly/schedule/exports.dart';
import 'package:tutorly/shared/exports.dart';

class ScheduleForm extends StatelessWidget {
  const ScheduleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ScheduleCubit(authRepo: context.read<AuthenticationRepository>()),
      child: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                body: Center(
                  child: BlocBuilder<ScheduleCubit, ScheduleState>(
                    builder: (context, state) {
                      return DelayedDisplay(
                        delay: Duration(milliseconds: 100),
                        fadeIn: true,
                        fadingDuration: Duration(milliseconds: 300),
                        slidingBeginOffset: Offset(0, 0.005),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 100),
                          child: QuickScheduleList(),
                        ),
                      );
                    },
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  elevation: 20,
                  child: Builder(
                    builder:
                        (context) => Expanded(
                          child: IconButton(
                            iconSize: 30,
                            icon: Shimmer.fromColors(
                              baseColor: Colors.green,
                              highlightColor: Colors.lightGreen,
                              child: const Icon(Icons.check),
                            ),
                            onPressed: () {
                              final scheduleState =
                                  context.read<ScheduleCubit>().state;
                              if (scheduleState is ScheduleInitial) {
                                context.read<ScheduleCubit>().submitSchedule(
                                  scheduleData: scheduleState.data,
                                );
                              }
                            },
                          ),
                        ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: switch (state) {
                  ScheduleInitial() => Container(
                    key: const ValueKey('no_loading'),
                  ),
                  ScheduleSubmitting() => ScheduleSubmittingScreen(
                    key: const ValueKey('loading'),
                  ),
                  ScheduleSuccess() => ScheduleSuccessScreen(
                    key: const ValueKey('success'),
                  ),
                  ScheduleError() => Container(
                    key: const ValueKey('no_loading'),
                  ),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
