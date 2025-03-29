import 'package:flutter/services.dart';
import 'package:tutorly/portal/widgets/_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../logic/portal_cubit.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  // Local state for toggling password visibility.
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PortalCubit, PortalState>(
      listener: (context, state) {},
      builder: (context, state) {
        return FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FormBuilderTextField(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                  },
                  cursorWidth: 3,
                  cursorErrorColor: Colors.red,
                  enabled: state.status != PortalStatus.requesting,
                  name: 'email',
                  decoration: portalFormStyle(
                    context: context,
                    hintText: 'Email',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                FormBuilderTextField(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                  },
                  cursorWidth: 3,
                  cursorErrorColor: Colors.red,
                  enabled:
                      state.status == PortalStatus.requesting ? false : true,
                  name: 'password',
                  obscureText: _obscurePassword,
                  decoration: portalFormStyle(
                    context: context,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.password(),
                  ]),
                ),
                FormBuilderTextField(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                  },
                  cursorWidth: 3,
                  cursorErrorColor: Colors.red,
                  enabled:
                      state.status == PortalStatus.requesting ? false : true,
                  name: 'confirmPassword',
                  obscureText: _obscurePassword,
                  decoration: portalFormStyle(
                    context: context,
                    hintText: 'Confirm Password',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: "Please Confirm your Password",
                    ),
                    (val) {
                      if (val !=
                          _formKey.currentState?.getRawValue("password")) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ]),
                ),
                AnimatedSwitcher(
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  duration: const Duration(milliseconds: 200),
                  child:
                      state.status == PortalStatus.requesting ||
                              state.status == PortalStatus.success
                          ? const CircularProgressIndicator()
                          : SubmitButton(
                            buttonText: 'Sign Up',
                            buttonPress: () {
                              // Validate and save form.
                              if (_formKey.currentState!.saveAndValidate()) {
                                final values = _formKey.currentState!.value;
                                // Pass the credentials to the cubit.
                                context.read<PortalCubit>().submitSignUpForm(
                                  email: values['email'],
                                  password: values['password'],
                                );
                              }
                            },
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
