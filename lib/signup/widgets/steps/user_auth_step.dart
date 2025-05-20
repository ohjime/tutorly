import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutorly/core/core.dart';
import 'package:tutorly/signup/cubit/signup_cubit.dart';

/// The final authentication step in the signup process
/// This step allows users to either create an account with email/password
/// or sign up with Google
Widget userAuthStep(BuildContext context, GlobalKey<FormBuilderState> formKey) {
  return SingleChildScrollView(
    child: FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailPasswordSignupField(),
          const SizedBox(height: 24),

          // Sign up with email and password
          AppButton.tertiary(
            text: 'SIGN UP WITH EMAIL',
            onPressed: () {
              if (formKey.currentState?.saveAndValidate() ?? false) {
                final authData = formKey.currentState?.value;
                context.read<SignupCubit>().submit(authData!);
              }
            },
          ),
          const SizedBox(height: 24),
          // OR divider
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 24),

          // Google Sign up button
          AppButton.black(
            leadingIcon: FontAwesomeIcons.google,
            text: 'SIGN UP WITH GOOGLE',
            onPressed: () {
              context.read<SignupCubit>().submitWithGoogle();
            },
          ),

          const SizedBox(height: 16),

          // Terms and Privacy
          const Text(
            'By signing up to Tutorly, you agree to our\nTerms and Privacy Policy.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}
