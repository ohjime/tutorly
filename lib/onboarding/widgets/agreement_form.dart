import 'dart:math';

import 'package:tutorly/app/exports.dart';
import 'package:tutorly/onboarding/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgreementForm extends StatefulWidget {
  final String uid;
  final TutorlyRole appType;

  const AgreementForm({super.key, required this.uid, required this.appType});

  @override
  State<AgreementForm> createState() => _AgreementFormState();
}

class _AgreementFormState extends State<AgreementForm> {
  bool isChecked = false; // Local state to track checkbox status

  @override
  Widget build(BuildContext context) {
    String terms = OnboardingStrings.generalTerms;
    if (widget.appType == TutorlyRole.tutor) {
      terms += OnboardingStrings.tutorTerms;
    } else if (widget.appType == TutorlyRole.student) {
      terms += OnboardingStrings.tutorTerms;
    } else {}
    return SizedBox(
      height: min(MediaQuery.of(context).size.height * 0.8, 700),
      width: min(MediaQuery.of(context).size.height * 0.9, 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: min(MediaQuery.of(context).size.height * 0.6, 550),
            child: Expanded(
              child: SingleChildScrollView(
                child: Text(
                  terms, // Terms and Conditions
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
            ),
          ),
          SubmitButton(
            buttonText: 'Agree',
            onPressed: () {
              context.read<AppBloc>().add(Authorize());
            },
          ),
        ],
      ),
    );
  }
}
