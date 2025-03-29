import 'package:flutter/services.dart';
import 'package:tutorly/portal/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?',
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                overlayColor: WidgetStateProperty.all<Color>(
                  Colors.transparent,
                ), // Removes splash and hover effect
              ),
              onPressed: () {
                HapticFeedback.heavyImpact();
                context.read<PortalCubit>().signupMode();
              },
              child: Text(
                'Create an account',
                style: TextStyle(
                  color: Colors.green[100],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        SignInButton(
          buttonType: ButtonType.google,
          buttonSize: ButtonSize.large, // small(default), medium, large
          onPressed: () async {},
        ),
        SizedBox(height: 20),
        SignInButton(
          buttonType: ButtonType.apple,
          buttonSize: ButtonSize.large, // small(default), medium, large
          onPressed: () async {
            HapticFeedback.heavyImpact();
            context.read<PortalCubit>().signInWithApple();
          },
        ),
      ],
    );
  }
}
