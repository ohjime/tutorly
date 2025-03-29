import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorly/shared/exports.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final AuthenticationRepository authRepo;
  ScheduleCubit({required this.authRepo}) : super(ScheduleInitial({}));

  void updateSchedule(Map<String, dynamic> scheduleData) {
    emit(ScheduleInitial(scheduleData));
  }

  void submitSchedule({required Map<String, dynamic> scheduleData}) async {
    emit(ScheduleSubmitting(scheduleData));
    User? user = await authRepo.user.first;
    // check if schedule data is empty list for eachd ate
    bool scheduleIsEmpty = true;
    for (var date in scheduleData.keys) {
      if (scheduleData[date].isEmpty) {
        scheduleIsEmpty = false;
        break;
      }
    }
    if (scheduleIsEmpty) {
      emit(ScheduleError('Please select at least one date'));
      return;
    } else {
      try {
        await Future.wait<void>([
          Future.delayed(const Duration(seconds: 2)),
          FirebaseFirestore.instance.collection('schedules').doc(user!.uid).set(
            {'schedule': scheduleData},
          ),
        ]);
        emit(ScheduleSuccess());
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    }
  }
}
