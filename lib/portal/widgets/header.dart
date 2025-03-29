import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorly/app/exports.dart';
import 'package:tutorly/shared/exports.dart';

class PortalHeader extends StatelessWidget {
  final TutorlyRole appType;
  const PortalHeader({super.key, required this.appType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: min(MediaQuery.of(context).size.width * 0.8, 400),
          child: TutorlyLogo(),
        ),
        Shimmer.fromColors(
          baseColor: Colors.red,
          highlightColor: Colors.yellow,
          child: Text('TUTORLY'.toUpperCase(), style: TextStyle(fontSize: 24)),
        ),
        Text(
          (appType == TutorlyRole.tutor ? 'Tutor Portal' : 'Student Portal')
              .toUpperCase(),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold, // Optional customization
          ),
        ),
      ],
    );
  }
}
