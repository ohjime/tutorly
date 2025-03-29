import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback buttonPress;
  final String buttonText;
  const SubmitButton({
    super.key,
    required this.buttonPress,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonPress,
      child: Shimmer.fromColors(
        baseColor: Colors.red[100]!,
        highlightColor: Colors.white,
        child: Text(buttonText.toUpperCase()),
      ),
    );
  }
}
