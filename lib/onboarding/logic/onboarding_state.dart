part of 'onboarding_cubit.dart';

enum OnboardingStep {
  user, // Create Tutorly User
  profile, // Mandatory Step to Create Tutor or Student Profile
  billing, // Optional Step to add Payment Information
  terms, // Confirm and Accept Terms and conditions
}

class OnboardingState extends Equatable {
  final bool loading;
  final OnboardingStep? step;
  final bool processing;
  final String? error;
  final bool completed;
  final Map<String, dynamic> data;

  const OnboardingState({
    required this.loading,
    required this.data,
    required this.step,
    required this.processing,
    required this.error,
    required this.completed,
  });

  factory OnboardingState.initial() {
    return OnboardingState(
      data: {},
      loading: true,
      step: null,
      processing: false,
      error: null,
      completed: false,
    );
  }

  OnboardingState copyWith({
    bool? loading,
    OnboardingStep? step,
    bool? processing,
    String? error,
    bool? completed,
    Map<String, dynamic>? data,
  }) {
    return OnboardingState(
      loading: loading ?? this.loading,
      step: step ?? this.step,
      processing: processing ?? this.processing,
      error: error ?? this.error,
      completed: completed ?? this.completed,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [data, step, processing, error, completed];
}
