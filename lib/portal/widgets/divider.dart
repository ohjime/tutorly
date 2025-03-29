import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wave_divider/wave_divider.dart';

class PortalDivider extends StatelessWidget {
  const PortalDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.red,
          highlightColor: Colors.yellow,
          child: WaveDivider(
            thickness: 9,
            color: Colors.amber,
            waveHeight: 20,
            waveWidth: min(MediaQuery.of(context).size.width * 0.9, 500),
            isVertical: false,
          ),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
