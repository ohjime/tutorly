import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tutorly/core/core.dart';
import 'package:tutorly/signup/cubit/signup_cubit.dart';

const List<String> _highSchoolSuggestions = [
  'Jasper Place High School',
  'Ross Sheppard School',
  'Lillian Osborne School',
  'Harry Ainlay High School',
  'Queen Elizabeth High School',
  'W. P. Wagner School',
];

/// ------------------------------------------------------------------------
///  top‑level function so the SignupStep blueprint can stay const
/// ------------------------------------------------------------------------
Widget studentEducationDetailStep(
  BuildContext context,
  GlobalKey<FormBuilderState> formKey,
) {
  // Pull any previously saved education details
  final signupState = context.read<SignupCubit>().state;
  final institute = signupState.student.educationInstitute;
  final gradeLevel = signupState.student.gradeLevel;

  return SingleChildScrollView(
    child: FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormBuilderTypeAhead<String>(
            name: 'educationInstitute',
            initialValue: institute,
            decoration: InputDecoration(
              errorStyle: TextStyle(height: 2.5),
              hintText: 'Your School (start typing)',
              prefixIcon: Icon(Icons.school),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 2.5,
                ),
              ),
            ),
            animationDuration: Duration.zero,
            offset: Offset(0, 8),
            suggestionsCallback: (String query) {
              return _highSchoolSuggestions
                  .where(
                    (school) =>
                        school.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
            },
            itemBuilder: (context, String suggestion) {
              return ListTile(title: Text(suggestion));
            },
            onSelected: (String suggestion) {
              formKey.currentState!.fields['educationInstitute']!.didChange(
                suggestion,
              );
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(100),
            ]),
          ),
          Transform.translate(
            offset: const Offset(0, -2),
            child: FormBuilderDropdown<Grade>(
              name: 'gradeLevel',
              initialValue: gradeLevel == Grade.unknown ? null : gradeLevel,
              decoration: InputDecoration(
                errorStyle: TextStyle(),
                hintText: 'Current Grade',
                prefixIcon: Icon(null),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 2.5,
                  ),
                ),
              ),
              items: [
                for (final g in Grade.values)
                  if (g.index >= Grade.ten.index &&
                      g.index <= Grade.twelve.index)
                    DropdownMenuItem(value: g, child: Text(_gradeLabel(g))),
              ],
              validator: (value) {
                if (value == null) {
                  return 'Please select your current grade';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    ),
  );
}

/// Pretty labels for the Grade enum
String _gradeLabel(Grade g) {
  switch (g) {
    case Grade.ten:
      return 'Grade 10';
    case Grade.eleven:
      return 'Grade 11';
    case Grade.twelve:
      return 'Grade 12';
    default:
      return g.toString().split('.').last.capitalize();
  }
}

/// Simple string extension for capitalization
extension _Cap on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
