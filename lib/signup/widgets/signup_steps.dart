import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:tutorly/core/core.dart';
import 'package:tutorly/signup/signup.dart';
import 'package:tutorly/signup/widgets/steps/intro_step.dart' show introStep;
import 'package:tutorly/signup/widgets/steps/user_auth_step.dart'
    show userAuthStep;
import 'package:tutorly/signup/widgets/steps/user_schedule_step.dart'
    show userScheduleStep;
import 'package:tutorly/signup/widgets/steps/user_profile_step.dart'
    show userProfileStep;
import 'package:tutorly/signup/widgets/steps/user_role_step.dart'
    show userRoleStep;
import 'package:tutorly/signup/widgets/steps/student_education_step.dart'
    show studentEducationDetailStep;
import 'package:tutorly/signup/widgets/steps/student_courses_step.dart'
    show studentCoursesStep;
import 'package:tutorly/signup/widgets/steps/tutor_academic_credential_step.dart'
    show tutorAcademicCredentialStep;
import 'package:tutorly/signup/widgets/steps/tutor_courses_step.dart'
    show tutorCoursesStep;

class SignupStep {
  const SignupStep({
    required this.title,
    required this.dialogue,
    required this.showIf,
    required this.builder,
    required this.callback,
  });

  final String title;
  final List<String> dialogue;
  final StepPredicate showIf;
  final StepFormBuilder builder;
  final StepCallback callback;
}

typedef StepFormBuilder =
    Widget Function(BuildContext context, GlobalKey<FormBuilderState> key);

typedef StepPredicate = bool Function(BuildContext context);

typedef StepCallback =
    void Function(BuildContext context, Map<String, dynamic> data);

List<SignupStep> signupSteps = [
  // Create initial step that plays the cooked rive animation
  SignupStep(
    title: 'Welcome to Tutorly!',
    dialogue: [
      'Welcome to Tutorly, the app that connects students with tutors!',
      'We are excited to have you here!',
      'Let\'s get started with your signup process!',
    ],
    showIf: (context) => true,
    builder: introStep,

    callback: (context, data) {},
  ),

  SignupStep(
    title: 'Select a Role',
    dialogue: [
      'Alright!',
      'Now, I need to know what you plan to use this app for',
      'Do you want to be a tutor or a student?',
      'Are you more like the wise Obi-Wan Kenobi...',
      'Or the eager learner Anakin Skywalker?',
      'Choose wisely...',
    ],
    showIf: (context) => true,
    builder: userRoleStep,
    callback: (context, data) {
      final role = data['role'];
      if (role == 'tutor') {
        context.read<SignupCubit>().selectRole(UserRole.tutor);
      } else {
        context.read<SignupCubit>().selectRole(UserRole.student);
      }
    },
  ),
  SignupStep(
    title: 'Academic Credentials',
    dialogue: [
      'Let\'s highlight your academic background',
      'What degrees or certifications do you have?',
      'This helps establish your credibility with students',
    ],
    showIf:
        (context) =>
            context.read<SignupCubit>().state.user.role == UserRole.tutor,
    builder: tutorAcademicCredentialStep,
    callback: (context, data) {
      context.read<SignupCubit>().updateTutor(data);
    },
  ),
  SignupStep(
    title: 'Current Education Level',
    dialogue: [
      'Let\'s add some details about your education',
      'This helps us find tutors who specialize in your grade level',
      'And connect you with the right academic resources',
    ],
    showIf:
        (context) =>
            context.read<SignupCubit>().state.user.role == UserRole.student,
    builder: studentEducationDetailStep,
    callback: (context, data) {
      context.read<SignupCubit>().updateStudent(data);
    },
  ),
  SignupStep(
    title: 'Subject Expertise',
    dialogue: [
      'Now, I need to know what you are good at!',
      'What subjects do you know?',
      'What grades can you teach?',
      'Show me what you got!',
    ],
    showIf:
        (context) =>
            context.read<SignupCubit>().state.user.role == UserRole.tutor,
    builder: tutorCoursesStep,
    callback: (context, data) {
      context.read<SignupCubit>().updateTutor(data);
    },
  ),
  SignupStep(
    title: 'Subject Focus',
    dialogue: [
      'What subjects are you looking to improve in?',
      'Be specific about topics you\'re struggling with',
      'This helps us match you with the perfect tutor',
    ],
    showIf:
        (context) =>
            context.read<SignupCubit>().state.user.role == UserRole.student,
    builder: studentCoursesStep,
    callback: (context, data) {
      context.read<SignupCubit>().updateStudent(data);
    },
  ),
  SignupStep(
    title: 'Availability Selection',
    dialogue: [
      'What subjects are you looking to improve in?',
      'Be specific about topics you\'re struggling with',
      'This helps us match you with the perfect tutor',
    ],
    showIf: (context) => true,
    builder: userScheduleStep,
    callback: (context, data) {
      print(data['schedule']);
      context.read<SignupCubit>().updateUser(data);
    },
  ),
  SignupStep(
    title: 'Customize Your Profile',
    dialogue: [
      'Let\'s make your profile shine!',
      'What\'s your name?',
      'What do you look like?',
      'Let\'s beautify your profile!',
    ],
    showIf: (context) => true,
    builder: userProfileStep,
    callback: (context, data) {
      context.read<SignupCubit>().updateUser(data);
      if (context.read<SignupCubit>().state.user.role == UserRole.tutor) {
        context.read<SignupCubit>().updateTutor(data);
      } else {
        context.read<SignupCubit>().updateStudent(data);
      }
    },
  ),
  SignupStep(
    title: 'Finalize Your Account',
    dialogue: [
      'You\'re almost there!',
      'Just a few more details and you\'ll be all set',
      'Let\'s finish things up by securing your account!',
    ],
    showIf: (context) => true,
    builder: userAuthStep,
    callback: (context, data) {
      return;
    },
  ),
];
