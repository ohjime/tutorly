import 'package:flutter/services.dart';
import 'package:tutorly/portal/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class SignupOptions extends StatelessWidget {
  const SignupOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already Have an Account?',
                style: TextStyle(color: Colors.white)),
            TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                overlayColor: WidgetStateProperty.all<Color>(
                    Colors.transparent), // Removes splash and hover effect
              ),
              onPressed: () {
                HapticFeedback.heavyImpact();
                context.read<PortalCubit>().loginMode();
              },
              child: Text('Click here to Login',
                  style: TextStyle(
                      color: Colors.green[100],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        SignInButton(
          buttonType: ButtonType.google,
          buttonSize: ButtonSize.large, // small(default), medium, large
          onPressed: () async {
            context.read<PortalCubit>().signUpWithGoogle();
          },
        ),
        SizedBox(
          height: 20,
        ),
        SignInButton(
          buttonType: ButtonType.apple,
          buttonSize: ButtonSize.large, // small(default), medium, large
          onPressed: () async {
            context.read<PortalCubit>().signUpWithApple();
          },
        ),
      ],
    );
  }
}
