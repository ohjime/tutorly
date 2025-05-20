import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tutorly/core/core.dart';
import 'package:tutorly/signup/cubit/signup_cubit.dart';

/// account_step.dart  (must be a *top-level* function so the blueprint can stay const)
Widget userRoleStep(BuildContext context, GlobalKey<FormBuilderState> formKey) {
  return FormBuilder(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormBuilderRadioGroup<String>(
          name: 'role',
          initialValue:
              context.read<SignupCubit>().state.user.role == UserRole.unknown
                  ? null
                  : context.read<SignupCubit>().state.user.role.name,
          decoration: const InputDecoration(
            border: InputBorder.none,
            errorStyle: TextStyle(height: 0),
          ),
          orientation: OptionsOrientation.vertical,
          separator: const SizedBox(height: 16),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.containsElement([
              'tutor',
              'student',
            ], errorText: 'Please select your role'),
          ]),
          options: [
            FormBuilderFieldOption<String>(
              value: 'student',
              child: _buildRoleChip(
                context: context,
                title: 'I am a Student',
                icon: Icons.school,
                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
              ),
            ),
            FormBuilderFieldOption<String>(
              value: 'tutor',
              child: _buildRoleChip(
                context: context,
                title: 'I am a Tutor',
                icon: Icons.psychology,
                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildRoleChip({
  required BuildContext context,
  required String title,
  required IconData icon,
  required Color backgroundColor,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    ),
  );
}
