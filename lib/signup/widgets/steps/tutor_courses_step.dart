import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tutorly/core/core.dart';
import 'package:tutorly/signup/signup.dart'; // appInputDecoration, etc.

/// ------------------------------------------------------------------
///  SIGNUP BLUEPRINT STEP  (top‑level function)
/// ------------------------------------------------------------------
Widget tutorCoursesStep(
  BuildContext context,
  GlobalKey<FormBuilderState> formKey,
) {
  final signupState = context.read<SignupCubit>().state;
  final existingCourses = signupState.tutor.courses;

  // convert existing List<Course> → Map<Grade, List<Subject>>
  final Map<Grade, List<Subject>> initialGradeSubjects = {};
  for (final c in existingCourses) {
    final list = initialGradeSubjects[c.generalLevel] ?? <Subject>[];
    if (!list.contains(c.subjectType)) {
      list.add(c.subjectType);
    }
    initialGradeSubjects[c.generalLevel] = list;
  }
  // Grades you want to show – extend or reorder as needed
  const gradeOrder = [
    Grade.ten,
    Grade.eleven,
    Grade.twelve,
    Grade.undergraduate,
    Grade.graduate,
  ];

  // All subjects = every enum value; feel free to filter
  final subjectList = Subject.values;

  return SingleChildScrollView(
    child: FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Which grades & subjects do you need help with?',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          FormBuilderField<Map<Grade, List<Subject>>>(
            name: 'tmp_gradeSubjects', // raw map ➜ transformed below
            initialValue: initialGradeSubjects,
            validator: (map) {
              if (map == null || map.isEmpty) {
                return 'Please pick at least one subject';
              }
              return null;
            },
            valueTransformer: (raw) => raw,
            builder: (field) {
              final data = field.value ?? {};

              void toggleSubject(Grade g, Subject s, bool selected) {
                final next = Map<Grade, List<Subject>>.from(data);
                final list = List<Subject>.from(next[g] ?? []);
                selected ? list.add(s) : list.remove(s);
                if (list.isEmpty) {
                  next.remove(g);
                } else {
                  next[g] = list;
                }
                field.didChange(next);
              }

              return Column(
                children: [
                  ...gradeOrder.map((g) {
                    final selectedSubjects = data[g] ?? [];
                    final borderColor =
                        selectedSubjects.isNotEmpty
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: borderColor, width: 1),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          initiallyExpanded: selectedSubjects.isNotEmpty,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            _gradeLabel(g),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 16,
                          ),
                          children: [
                            const Divider(),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  subjectList.map((s) {
                                    final isSelected = selectedSubjects
                                        .contains(s);
                                    return FilterChip(
                                      label: Text(_subjectLabel(s)),
                                      selected: isSelected,
                                      onSelected: (v) => toggleSubject(g, s, v),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        field.errorText ?? '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          // Hidden field that turns the grade/subject map into a List<Course>
          FormBuilderField<List<Course>>(
            name: 'courses',
            valueTransformer: (_) {
              final raw =
                  formKey.currentState?.fields['tmp_gradeSubjects']?.value
                      as Map<Grade, List<Subject>>?;
              if (raw == null) return [];
              final out = <Course>[];
              raw.forEach((g, subjects) {
                for (final s in subjects) {
                  out.add(Course(subjectType: s, generalLevel: g));
                }
              });
              return out;
            },
            builder: (field) => const SizedBox.shrink(),
          ),
        ],
      ),
    ),
  );
}

/// Human‑readable labels ------------------------------------------------
String _gradeLabel(Grade g) {
  switch (g) {
    case Grade.ten:
      return 'Grade 10';
    case Grade.eleven:
      return 'Grade 11';
    case Grade.twelve:
      return 'Grade 12';
    case Grade.undergraduate:
      return 'Undergraduate';
    case Grade.graduate:
      return 'Graduate';
    default:
      return g.toString().split('.').last.capitalize();
  }
}

String _subjectLabel(Subject s) =>
    s
        .toString()
        .split('.')
        .last
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(0)}')
        .capitalize();

extension _Cap on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
