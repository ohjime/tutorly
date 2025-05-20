part of 'signup_cubit.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final SignupStatus status;
  final core.User user;
  final core.Tutor tutor;
  final core.Student student;
  final String? error;

  const SignupState({
    required this.status,
    required this.user,
    required this.tutor,
    required this.student,
    this.error,
  });

  SignupState copyWith({
    SignupStatus? status,
    core.User? user,
    core.Tutor? tutor,
    core.Student? student,
    String? error,
  }) {
    return SignupState(
      status: status ?? this.status,
      user: user ?? this.user,
      tutor: tutor ?? this.tutor,
      student: student ?? this.student,
      error: error ?? this.error,
    );
  }

  const SignupState.initial()
    : status = SignupStatus.initial,
      user = core.User.empty,
      tutor = core.Tutor.empty,
      student = core.Student.empty,
      error = null;

  @override
  List<Object?> get props => [status, user, tutor, student, error];
}
