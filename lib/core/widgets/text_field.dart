import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SingleLineTextField extends StatefulWidget {
  const SingleLineTextField({
    super.key,
    required this.name,
    this.initialValue,
    this.hintText,
    this.leadingIcon,
    this.raiseLabel = false,
    this.labelText,
    this.formatters,
    this.validators,
    this.enabled = true,
    this.isItalics = false,
  });

  final bool raiseLabel;
  final String? labelText;
  final String name;
  final String? hintText;
  final IconData? leadingIcon;
  final List<TextInputFormatter>? formatters;
  final List<FormFieldValidator<String>>? validators;
  final bool enabled;
  final bool isItalics;
  final String? initialValue;

  @override
  State<SingleLineTextField> createState() => _SingleLineTextFieldState();
}

class _SingleLineTextFieldState extends State<SingleLineTextField>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxBorderWidth = 3.5;
    const double minBorderWidth = 2.5;
    final double reservedPadding = (maxBorderWidth - minBorderWidth) / 2;

    return FormBuilderField<String>(
      name: widget.name,
      initialValue: widget.initialValue,
      validator:
          widget.validators != null
              ? FormBuilderValidators.compose(widget.validators!)
              : null,
      builder: (field) {
        final hasError = field.errorText != null;

        final isFocused = _focusNode.hasFocus;

        final borderColor =
            hasError
                ? Colors.red
                : Theme.of(context).colorScheme.surfaceContainerHigh;

        final fieldFill1 =
            hasError
                ? Colors.red.withValues(alpha: 0.04)
                : Theme.of(context).colorScheme.surfaceContainerLow;

        final fieldWidget = AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: reservedPadding),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: borderColor,
                          width: minBorderWidth,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            onChanged: field.didChange,
                            enabled: widget.enabled,
                            style:
                                widget.isItalics
                                    ? const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    )
                                    : null,
                            inputFormatters: widget.formatters,
                            decoration: InputDecoration(
                              prefixIcon:
                                  widget.leadingIcon != null
                                      ? Icon(widget.leadingIcon)
                                      : null,
                              hintText: widget.hintText ?? 'Full Name',
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                                wordSpacing: -2,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(9.5),
                                  topRight: Radius.circular(9.5),
                                  bottomLeft: Radius.circular(9.5),
                                  bottomRight: Radius.circular(9.5),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: fieldFill1,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isFocused)
                    Positioned(
                      top: reservedPadding,
                      bottom: reservedPadding,
                      left: reservedPadding,
                      right: reservedPadding,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: borderColor,
                              width: maxBorderWidth,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    hasError
                        ? Padding(
                          key: ValueKey('error_${field.errorText}'),
                          padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                          child: Text(
                            field.errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        );
        if (widget.raiseLabel && widget.labelText != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  widget.labelText!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              fieldWidget,
            ],
          );
        }
        return fieldWidget;
      },
    );
  }
}
