part of 'schedule_cubit.dart';

@immutable
sealed class ScheduleState {}

// Here the user will be building their schedule
final class ScheduleInitial extends ScheduleState {
  final Map<String, dynamic> data;
  ScheduleInitial(this.data);
}

// Here we will show an overlapping loading screen as the
// submission takes place
final class ScheduleSubmitting extends ScheduleState {
  final Map<String, dynamic> data;
  ScheduleSubmitting(this.data);
}

// Here we will show a success screen
final class ScheduleSuccess extends ScheduleState {}

// Here we will show an error screen
final class ScheduleError extends ScheduleState {
  final String error;
  ScheduleError(this.error);
}
