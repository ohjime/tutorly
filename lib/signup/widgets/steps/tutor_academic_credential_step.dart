// tutor_academic_credential_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:tutorly/core/core.dart';
import 'package:tutorly/signup/cubit/signup_cubit.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

const List<String> _initialUniversitySuggestions = [
  'University of Alberta',
  'University of Calgary',
  'MacEwan University',
  'Northern Alberta Institute of Technology',
  'Southern Alberta Institute of Technology',
];

Widget tutorAcademicCredentialStep(
  BuildContext context,
  GlobalKey<FormBuilderState> formKey,
) {
  final signupState = context.read<SignupCubit>().state;
  final initialCreds = List<AcademicCredential>.from(
    signupState.tutor.academicCredentials,
  );

  return SingleChildScrollView(
    child: FormBuilder(
      key: formKey,
      child: _CredentialListField(
        name: 'academicCredentials',
        initialValue: initialCreds,
      ),
    ),
  );
}

class _CredentialListField extends StatefulWidget {
  const _CredentialListField({required this.name, required this.initialValue});

  final String name;
  final List<AcademicCredential> initialValue;

  @override
  _CredentialListFieldState createState() => _CredentialListFieldState();
}

class _CredentialListFieldState extends State<_CredentialListField> {
  late List<AcademicCredential> _creds;

  @override
  void initState() {
    super.initState();
    _creds = widget.initialValue;
  }

  Future<AcademicCredential?> _openCredentialModal({
    AcademicCredential? initial,
    required int? index,
  }) async {
    return showModalBottomSheet<AcademicCredential>(
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        // Add padding so the sheet isn’t hidden by the keyboard
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(
            bottom: bottomInset,
            top: 24,
            left: 16,
            right: 16,
          ),
          child: SafeArea(
            child: _InlineCredentialForm(
              credential: initial ?? AcademicCredential.empty(),
              onSave: (cred) => Navigator.of(ctx).pop(cred),
              onCancel: () => Navigator.of(ctx).pop(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<AcademicCredential>>(
      name: widget.name,
      initialValue: _creds,
      validator: (List<AcademicCredential>? creds) {
        final nonEmpty = creds?.where((c) => !c.isEmpty).toList() ?? [];
        return nonEmpty.isNotEmpty
            ? null
            : 'Please add at least one academic credential';
      },
      valueTransformer:
          (List<AcademicCredential>? raw) =>
              raw?.where((c) => !c.isEmpty).toList(),
      builder: (field) {
        final creds = field.value!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            ...List.generate(creds.length, (i) {
              final cred = creds[i];
              return _CondensedCard(
                credential: cred,
                onTap: () async {
                  final updated = await _openCredentialModal(
                    initial: cred,
                    index: i,
                  );
                  if (updated != null) {
                    setState(() => _creds[i] = updated);
                    field.didChange(_creds);
                  }
                },
                onDelete: () {
                  setState(() => _creds.removeAt(i));
                  field.didChange(_creds);
                },
              );
            }),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Academic Credential'),
              style:
                  field.errorText != null
                      ? OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        foregroundColor: Theme.of(context).colorScheme.error,
                      )
                      : null,
              onPressed: () async {
                final newCred = await _openCredentialModal(
                  initial: null,
                  index: null,
                );
                if (newCred != null) {
                  setState(() => _creds.add(newCred));
                  field.didChange(_creds);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _CondensedCard extends StatelessWidget {
  const _CondensedCard({
    required this.credential,
    required this.onTap, // onTap now specifically used for editing
    required this.onDelete,
  });

  final AcademicCredential credential;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        // Remove onTap to prevent tapping on the tile
        // from doing anything.
        title: Text(
          '${credential.institution} – '
          '${credential.level.toString().split('.').last.capitalize()}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${credential.fieldOfStudy} (${credential.focus})\n'
          '${DateFormat('MMM yyyy').format(credential.dateIssued)}',
        ),
        isThreeLine: true,
        // Add separate icons:
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onTap, // triggers editing
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete, // deletes credential
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineCredentialForm extends StatefulWidget {
  const _InlineCredentialForm({
    required this.credential,
    required this.onSave,
    required this.onCancel,
  });

  final AcademicCredential credential;
  final ValueChanged<AcademicCredential> onSave;
  final VoidCallback onCancel;

  @override
  State<_InlineCredentialForm> createState() => _InlineCredentialFormState();
}

class _InlineCredentialFormState extends State<_InlineCredentialForm> {
  final _fbKey = GlobalKey<FormBuilderState>();

  late final Future<List<String>> _allUniversitiesFuture;

  @override
  void initState() {
    super.initState();
    _allUniversitiesFuture = rootBundle
        .loadString('assets/data/shared/universities.json')
        .then((raw) {
          final data = jsonDecode(raw);
          if (data is List) {
            // support either simple array of strings or array of objects with 'name'
            return data
                .map<String>((e) => e is String ? e : (e['name'] as String))
                .toList();
          }
          return <String>[];
        });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _fbKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'New Academic Credential',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 20),
              DropDownField(
                labelText: 'Institution *',
                raiseLabel: true,
                hintText: 'e.g. University of Alberta',
                name: 'institution',
                initialValue: widget.credential.institution,
                suggestionsCallback: (query) async {
                  if (query.trim().isEmpty) {
                    return _initialUniversitySuggestions;
                  }
                  final all = await _allUniversitiesFuture;
                  return all
                      .where(
                        (u) => u.toLowerCase().contains(query.toLowerCase()),
                      )
                      .take(5)
                      .toList();
                },
                isRequired: true,
                requiredErrorText:
                    'The Institution of this credential is required',
                mustBeSuggestion: true,
                suggestionErrorText: 'Pick a listed institution',
              ),
              const SizedBox(height: 12),
              DropDownField.select(
                requiredErrorText: 'The level of this credential is required',
                name: 'level',
                initialValue: widget.credential.level,
                labelText: 'Credential Level *',
                raiseLabel: true,
                isRequired: true,
                options: [...AcademicCredentialLevel.values],
                displayStringForOption:
                    (l) => l.toString().split('.').last.capitalize(),
              ),
              const SizedBox(height: 12),
              SingleLineTextField(
                labelText: 'Field of Study *',
                raiseLabel: true,
                name: 'fieldOfStudy',
                formatters: [capitalizeWords],
                initialValue: widget.credential.fieldOfStudy,
                hintText: 'e.g. Physics, Computer Science',
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Field of Study is required',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleLineTextField(
                labelText: 'Focus / Specialization (optional)',
                raiseLabel: true,
                name: 'focus',
                formatters: [capitalizeWords],
                initialValue: widget.credential.focus,
                hintText: 'e.g. General Stream',
              ),
              const SizedBox(height: 12),
              SingleLineDateTimeField(
                name: 'dateIssued',
                initialValue: widget.credential.dateIssued,
                format: DateFormat('MMM yyyy'),
                inputType: InputType.date,
                hintText: 'e.g. Jan 2020',
                leadingIcon: Icons.calendar_today,
                enabled: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Date Issued is required',
                ),
              ),
              // Row containing the date picker and scan image upload.
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      if (_fbKey.currentState?.saveAndValidate() ?? false) {
                        final d = _fbKey.currentState!.value;
                        widget.onSave(
                          widget.credential.copyWith(
                            institution: d['institution'] as String,
                            level: d['level'] as AcademicCredentialLevel,
                            fieldOfStudy: d['fieldOfStudy'] as String,
                            focus:
                                (d['focus'] as String?)?.trim().isEmpty ?? true
                                    ? 'General'
                                    : d['focus'] as String,
                            imageUrl: d['imageUrl'] as String? ?? '',
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _Cap on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
