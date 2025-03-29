import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorly/app/exports.dart';
import 'package:tutorly/shared/exports.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final UserRepository userRepo;
  final TutorRepository tutorRepo;
  final StudentRepository studentRepo;

  OnboardingCubit({
    required this.userRepo,
    required this.tutorRepo,
    required this.studentRepo,
  }) : super(OnboardingState.initial());

  Future<void> seekStartStep({required String uid}) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final exists = await userRepo.checkUserExists(uid: uid);
      if (!exists) {
        // Direct user to the create user step
        emit(
          state.copyWith(
            loading: false,
            step: OnboardingStep.user,
            processing: false,
          ),
        );
      } else {
        // Direct user to the profile creation step
        emit(
          state.copyWith(
            loading: false,
            step: OnboardingStep.profile,
            processing: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(loading: true, processing: false, error: e.toString()),
      );
    }
  }

  Future<void> submitUserForm({required Map<String, dynamic> userData}) async {
    emit(state.copyWith(processing: true));
    try {
      await userRepo.createUser(TutorlyUser.fromJson(userData));
      emit(state.copyWith(step: OnboardingStep.profile, processing: false));
    } on Exception catch (e) {
      emit(
        state.copyWith(processing: false, error: 'Failed to Create User\n$e'),
      );
    }
  }

  Future<void> submitProfileForm({
    required Map<String, dynamic> profileData,
    required TutorlyRole appType,
  }) async {
    emit(state.copyWith(processing: true));
    try {
      if (appType == TutorlyRole.tutor) {
        await tutorRepo.createTutor(TutorlyTutor.fromJson(profileData));
      } else if (appType == TutorlyRole.student) {
        await studentRepo.createStudent(TutorlyStudent.fromJson(profileData));
      }
      emit(state.copyWith(step: OnboardingStep.billing, processing: false));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          processing: false,
          error: 'Failed to Create Profile\n$e',
        ),
      );
    }
  }

  Future<void> submitBillingForm(Map<String, dynamic> billingData) async {
    emit(state.copyWith(processing: true));
    try {
      // await billingRepo.createBilling(Billing.fromJson(billingData));
      emit(state.copyWith(step: OnboardingStep.terms, processing: false));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          processing: false,
          error: 'Failed to Add Billing Information\n$e',
        ),
      );
    }
  }

  Future<void> skipBillingForm() async {
    emit(state.copyWith(step: OnboardingStep.terms, processing: false));
  }

  Future<void> submitTermsConfirmation({
    required bool agree,
    required TutorlyRole appType,
    required String uid,
  }) async {
    emit(state.copyWith(processing: true));
    try {
      // Figure out how to keep track of whether users are confirmed or not.
      emit(state.copyWith(completed: true, processing: false));
    } on Exception catch (e) {
      emit(state.copyWith(processing: false, error: 'Failed to Confirm\n$e'));
    }
  }
}
