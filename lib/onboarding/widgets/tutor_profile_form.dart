import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorly/app/exports.dart';
import 'package:tutorly/shared/exports.dart';
import 'package:tutorly/onboarding/exports.dart';

class TutorProfileForm extends StatefulWidget {
  final String uid;
  const TutorProfileForm({super.key, required this.uid});

  @override
  State<TutorProfileForm> createState() => _TutorProfileFormState();
}

class _TutorProfileFormState extends State<TutorProfileForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {},
      builder: (context, state) {
        return FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container to limit width
                SizedBox(
                  width: min(MediaQuery.of(context).size.height * 0.9, 600),
                  child: Column(
                    children: [
                      // Alma Mater Field
                      FormBuilderTextField(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                        },
                        name: 'almaMater',
                        decoration: onboardingFormStyle(
                          context: context,
                          hintText: 'Alma Mater',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Alma Mater is required',
                          ),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      // Credential Field
                      FormBuilderTextField(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                        },
                        name: 'credential',
                        decoration: onboardingFormStyle(
                          context: context,
                          hintText: 'Credential',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Credential is required',
                          ),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      // Subjects to Teach Field (Multi-Select)
                      FormBuilderFilterChips<Subjects>(
                        spacing: 10,
                        runSpacing: 10,
                        name: 'subjectsToTeach',
                        decoration: onboardingFormStyle(
                          context: context,
                          hintText: 'Select Subjects to Teach',
                        ),
                        options:
                            Subjects.values
                                .map(
                                  (subject) => FormBuilderChipOption(
                                    value: subject,
                                    child: Text(
                                      subject
                                          .toString()
                                          .split('.')
                                          .last
                                          .toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(
                            1,
                            errorText: 'Select at least one subject',
                          ),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      // Grades to Teach Field (Multi-Select)
                      FormBuilderFilterChips<Grade>(
                        spacing: 10,
                        runSpacing: 3,
                        name: 'gradesToTeach',
                        decoration: onboardingFormStyle(
                          context: context,
                          hintText: 'Select Grades to Teach',
                        ),
                        options:
                            Grade.values
                                .map(
                                  (grade) => FormBuilderChipOption(
                                    value: grade,
                                    child: Text(
                                      _mapGradesToInt(grade).toString(),
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(
                            1,
                            errorText: 'Select at least one grade',
                          ),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      // Bio Field (Optional)
                      FormBuilderTextField(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                        },
                        name: 'bio',
                        decoration: onboardingFormStyle(
                          context: context,
                          hintText: 'Short Bio (Optional)',
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Sign Up Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed:
                      state.loading == true
                          ? null
                          : () {
                            // Validate and save the form
                            if (_formKey.currentState!.saveAndValidate()) {
                              final values = Map<String, dynamic>.from(
                                _formKey.currentState!.value,
                              );
                              // Add the uid to the form data.
                              values['uid'] = widget.uid;
                              // Dispatch the completed tutor form to the cubit.
                              context.read<OnboardingCubit>().submitProfileForm(
                                profileData: values,
                                appType: TutorlyRole.tutor,
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
          ),
        );
      },
    );
  }
}

// Map your Grade enum to a step index or value.
int _mapGradesToInt(Grade grade) {
  switch (grade) {
    case Grade.ten:
      return 10;
    case Grade.eleven:
      return 11;
    case Grade.twelve:
      return 12;
  }
}
