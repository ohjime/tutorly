import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chiclet/chiclet.dart';
import 'package:loading_indicator/loading_indicator.dart';

enum AppButtonVariant {
  primary,
  secondary,
  tertiary,
  black,
  white,
  danger,
  success,
  warning,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.height,
    this.borderRadius,
    this.borderWidth,
    this.buttonHeight,
    this.isIconButton = false,
    this.isDisabled = false,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    required this.text,
    required this.onPressed,
    required this.variant,
  });

  final double? height;
  final double? borderRadius;
  final double? borderWidth;
  final double? buttonHeight;
  final bool isIconButton;
  final bool isDisabled;
  final bool isLoading;
  final IconData? leadingIcon;
  final String text;
  final IconData? trailingIcon;
  final VoidCallback onPressed;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    late final Color foregroundColor;
    late final Color backgroundColor;
    late final Color borderColor;
    late final Color buttonColor;
    switch (variant) {
      case AppButtonVariant.primary:
        foregroundColor = colorScheme.onPrimary;
        backgroundColor = colorScheme.primary;
        borderColor = colorScheme.onPrimaryFixedVariant;
        buttonColor = colorScheme.onPrimaryFixedVariant;
        break;
      case AppButtonVariant.secondary:
        foregroundColor = colorScheme.onSecondary;
        backgroundColor = colorScheme.secondary;
        borderColor = colorScheme.onSecondaryFixedVariant;
        buttonColor = colorScheme.onSecondaryFixedVariant;
        break;
      case AppButtonVariant.tertiary:
        foregroundColor = colorScheme.onTertiary;
        backgroundColor = colorScheme.tertiary;
        borderColor = colorScheme.onTertiaryFixedVariant;
        buttonColor = colorScheme.onTertiaryFixedVariant;
        break;
      case AppButtonVariant.black:
        foregroundColor = Colors.white;
        backgroundColor = Colors.black;
        borderColor = colorScheme.onSurface;
        buttonColor = colorScheme.onSurface;
        break;
      case AppButtonVariant.white:
        foregroundColor = colorScheme.surface;
        backgroundColor = colorScheme.onSurface;
        borderColor = colorScheme.surfaceContainerLow;
        buttonColor = colorScheme.surfaceContainerLow;
        break;
      case AppButtonVariant.success:
        foregroundColor = Colors.white;
        backgroundColor = Colors.green;
        borderColor = const Color.fromARGB(255, 22, 126, 76);
        buttonColor = const Color.fromARGB(255, 22, 126, 76);
        break;
      case AppButtonVariant.warning:
        foregroundColor = colorScheme.onSurface;
        backgroundColor = colorScheme.surface;
        borderColor = colorScheme.onSurface;
        buttonColor = colorScheme.onSurface;
        break;
      case AppButtonVariant.danger:
        foregroundColor = colorScheme.onSurface;
        backgroundColor = colorScheme.surface;
        borderColor = colorScheme.onSurface;
        buttonColor = colorScheme.onSurface;
        break;
    }
    return ChicletOutlinedAnimatedButton(
      width: double.infinity,
      height: height ?? 54,
      borderRadius: borderRadius ?? 14,
      borderWidth: borderWidth ?? 2.5,
      buttonHeight: buttonHeight ?? 4,
      buttonType:
          isIconButton
              ? ChicletButtonTypes.circle
              : ChicletButtonTypes.roundedRectangle,
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      disabledForegroundColor:
          Theme.of(context).colorScheme.surfaceContainerHighest,
      disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      disabledBorderColor:
          Theme.of(context).colorScheme.surfaceContainerHighest,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      buttonColor: buttonColor,
      onPressed:
          isDisabled
              ? null
              : isLoading
              ? null
              : () async {
                HapticFeedback.heavyImpact();
                await Future.delayed(const Duration(milliseconds: 240));
                onPressed();
              },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 60),
        switchOutCurve: Curves.easeInOut,
        transitionBuilder:
            (child, animation) =>
                FadeTransition(opacity: animation, child: child),
        child:
            isLoading
                ? isIconButton
                    ? LoadingIndicator(
                      indicatorType: Indicator.ballSpinFadeLoader,
                      colors: [
                        Theme.of(context).colorScheme.onPrimaryContainer,
                        Theme.of(context).colorScheme.onSecondaryContainer,
                        Theme.of(context).colorScheme.onTertiaryContainer,
                      ],
                    )
                    : LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: [
                        Theme.of(context).colorScheme.onPrimaryContainer,
                        Theme.of(context).colorScheme.onSecondaryContainer,
                        Theme.of(context).colorScheme.onTertiaryContainer,
                      ],
                    )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    if (leadingIcon != null) Icon(leadingIcon),
                    if (!isIconButton)
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    if (trailingIcon != null && !isIconButton)
                      Icon(trailingIcon),
                  ],
                ),
      ),
    );
  }

  factory AppButton.primary({
    Key? key,
    double? height,
    double? borderRadius,
    double? borderWidth,
    double? buttonHeight,
    bool isIconButton = false,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      key: key,
      height: height,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      buttonHeight: buttonHeight,
      isIconButton: isIconButton,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
    );
  }

  factory AppButton.secondary({
    Key? key,
    double? height,
    double? borderRadius,
    double? borderWidth,
    double? buttonHeight,
    bool isIconButton = false,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      key: key,
      height: height,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      buttonHeight: buttonHeight,
      isIconButton: isIconButton,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
    );
  }

  factory AppButton.tertiary({
    Key? key,
    double? height,
    double? borderRadius,
    double? borderWidth,
    double? buttonHeight,
    bool isIconButton = false,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      key: key,
      height: height,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      buttonHeight: buttonHeight,
      isIconButton: isIconButton,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.tertiary,
    );
  }

  factory AppButton.black({
    Key? key,
    double? height,
    double? borderRadius,
    double? borderWidth,
    double? buttonHeight,
    bool isIconButton = false,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      key: key,
      height: height,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      buttonHeight: buttonHeight,
      isIconButton: isIconButton,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.black,
    );
  }

  factory AppButton.white({
    Key? key,
    double? height,
    double? borderRadius,
    double? borderWidth,
    double? buttonHeight,
    bool isIconButton = false,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      key: key,
      height: height,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      buttonHeight: buttonHeight,
      isIconButton: isIconButton,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.white,
    );
  }

  factory AppButton.success({
    Key? key,
    double? height,
    double? borderRadius,
    double? borderWidth,
    double? buttonHeight,
    bool isIconButton = false,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      key: key,
      height: height,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      buttonHeight: buttonHeight,
      isIconButton: isIconButton,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.success,
    );
  }

  factory AppButton.warning({
    Key? key,
    double? height,
    double? borderRadius,
    double? borderWidth,
    double? buttonHeight,
    bool isIconButton = false,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      key: key,
      height: height,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      buttonHeight: buttonHeight,
      isIconButton: isIconButton,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.warning,
    );
  }

  factory AppButton.danger({
    Key? key,
    double? height,
    double? borderRadius,
    double? borderWidth,
    double? buttonHeight,
    bool isIconButton = false,
    bool isDisabled = false,
    bool isLoading = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      key: key,
      height: height,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      buttonHeight: buttonHeight,
      isIconButton: isIconButton,
      isDisabled: isDisabled,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.danger,
    );
  }
}
