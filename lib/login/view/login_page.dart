import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutorly/core/core.dart';
import 'package:tutorly/login/login.dart';

import '../../core/widgets/email_pass_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final formKey = GlobalKey<FormBuilderState>();
  final resetPasswordFormKey = GlobalKey<FormBuilderState>();
  bool obscurePassword = true;
  final borderColor = Colors.grey[700]!;

  void forgotPassword(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Forgot Password',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            // const SizedBox(height: 16),
            FormBuilder(
              key: resetPasswordFormKey,
              child: FormBuilderTextField(
                name: 'reset_email',
                decoration: appInputDecoration(
                  context: context,
                  hintText: 'Email',
                  icon: Icons.email,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            AppButton.black(
              text: 'Send Reset Link',
              onPressed: () async {
                if (resetPasswordFormKey.currentState?.saveAndValidate() ??
                    false) {
                  final email =
                      resetPasswordFormKey.currentState!.value['reset_email']
                          as String;

                  try {
                    await context
                        .read<AuthenticationRepository>()
                        .resetPassword(email: email);
                    Navigator.of(context).pop(); // Close the dialog

                    // Show success message
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.scale,
                      title: 'Reset Link Sent',
                      desc:
                          'Please check your email for password reset instructions.',
                      btnOkOnPress: () {},
                    ).show();
                  } on ResetPasswordFailure catch (e) {
                    // Show error message
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.scale,
                      title: 'Reset Password Error',
                      desc: e.message,
                      btnOkOnPress: () {},
                    ).show();
                  }
                }
              },
            ),
          ],
        ),
      ),
      btnCancel: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('CANCEL'),
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.failure) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.scale,
            title: 'Login Error',
            desc: state.errorMessage,
            btnOkText: "Try Again",
            btnOkOnPress: () => context.read<LoginCubit>().resetError(),
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            'Enter your details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return FormBuilder(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EmailPasswordLoginField(),
                        const SizedBox(height: 16),
                        AppButton.success(
                          text: 'SIGN IN',
                          onPressed: () {
                            if (formKey.currentState?.saveAndValidate() ??
                                false) {
                              final v = formKey.currentState!.value;
                              context.read<LoginCubit>().login(
                                v['email'] as String,
                                v['password'] as String,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 6),
                        TextButton(
                          onPressed: () => forgotPassword(context),
                          child: Text(
                            'FORGOT PASSWORD',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Spacer(),
              // ─── SOCIAL BUTTONS ─────────────────────────────────────
              // Google Sign-In Button
              AppButton.white(
                leadingIcon: FontAwesomeIcons.apple,
                text: 'SIGN IN WITH APPLE',
                onPressed: () {
                  context.read<LoginCubit>().loginWithGoogle();
                },
              ),
              const SizedBox(height: 16),
              // Google Sign-In Button
              AppButton.black(
                leadingIcon: FontAwesomeIcons.google,
                text: 'SIGN IN WITH GOOGLE',
                onPressed: () {
                  context.read<LoginCubit>().loginWithGoogle();
                },
              ),
              const SizedBox(height: 16),
              // ─── TERMS & PRIVACY ────────────────────────────────────
              const Text(
                'By signing in to Tutorly, you agree to our\n'
                'Terms and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}
