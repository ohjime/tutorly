import 'dart:math';
import 'package:flutter/services.dart';
import 'package:tutorly/app/logic/app_bloc.dart';
import 'package:tutorly/onboarding/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileForm extends StatefulWidget {
  final String uid;
  const UserProfileForm({super.key, required this.uid});

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {},
      builder: (context, state) {
        return FormBuilder(
          key: _formKey,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PotraitCoverPicker(),
              SizedBox(
                width: min((MediaQuery.of(context).size.height * 0.9), 600),
                child: Column(
                  children: [
                    Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FormBuilderTextField(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                            },
                            cursorWidth: 3,
                            cursorErrorColor: Colors.red,
                            enabled: state.loading != true,
                            name: 'firstName',
                            decoration: onboardingFormStyle(
                              context: context,
                              hintText: 'First Name',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                        Expanded(
                          child: FormBuilderTextField(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                            },
                            cursorWidth: 3,
                            cursorErrorColor: Colors.red,
                            enabled: state.loading != true,
                            name: 'lastName',
                            decoration: onboardingFormStyle(
                              context: context,
                              hintText: 'Last Name',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    FormBuilderTextField(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                      },
                      initialValue:
                          (context.read<AppBloc>().state as AppAuthenticated)
                              .fbuser
                              .email,
                      cursorWidth: 3,
                      cursorErrorColor: Colors.red,
                      enabled: state.loading != true,
                      name: 'email',
                      decoration: onboardingFormStyle(
                        context: context,
                        hintText: 'Email',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 15,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  // Validate and save form.
                  if (_formKey.currentState!.saveAndValidate()) {
                    final values = Map<String, dynamic>.from(
                      _formKey.currentState!.value,
                    );
                    // Add the uid to the form data.
                    values['uid'] = widget.uid;
                    // Pass the credentials to the cubit.
                    context.read<OnboardingCubit>().submitUserForm(
                      userData: values,
                    );
                  }
                },
                child: Shimmer.fromColors(
                  baseColor: Colors.blue,
                  highlightColor: Colors.blueGrey,
                  child: Text('Next'.toUpperCase()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
