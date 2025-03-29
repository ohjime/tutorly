import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SubmitButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback? onPressed;

  const SubmitButton({
    super.key,
    required this.onPressed,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    if (buttonText != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        label: Shimmer.fromColors(
          baseColor: Colors.blue,
          highlightColor: Colors.blueGrey,
          child: Text(
            buttonText!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        icon: Shimmer.fromColors(
          baseColor: Colors.blue,
          highlightColor: Colors.blueGrey,
          child: const Icon(Icons.arrow_forward),
        ),
      );
    } else {
      return FloatingActionButton(
        onPressed: onPressed,
        child: Shimmer.fromColors(
          baseColor: Colors.blue,
          highlightColor: Colors.blueGrey,
          child: const Icon(Icons.arrow_forward),
        ),
      );
    }
  }
}
