import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

/// ---------------------------------------------------------------------------
/// Single‑line Date/Time picker styled like SingleLineTextField
/// ---------------------------------------------------------------------------
class SingleLineDateTimeField extends StatefulWidget {
  const SingleLineDateTimeField({
    super.key,
    required this.name,
    this.initialValue,
    this.format,
    this.inputType = InputType.date,
    this.hintText,
    this.leadingIcon,
    this.enabled = true,
    this.validator,
  });

  /// form field name
  final String name;

  /// initial date value
  final DateTime? initialValue;

  /// how the picked date is displayed
  final DateFormat? format;

  /// date versus date&time
  final InputType inputType;

  /// placeholder when empty
  final String? hintText;

  /// optional icon at start of field
  final IconData? leadingIcon;

  /// enable/disable interaction
  final bool enabled;

  /// custom validation
  final String? Function(DateTime?)? validator;

  @override
  State<SingleLineDateTimeField> createState() =>
      _SingleLineDateTimeFieldState();
}

class _SingleLineDateTimeFieldState extends State<SingleLineDateTimeField>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  static const _maxBorder = 3.5;
  static const _minBorder = 2.5;

  @override
  void initState() {
    super.initState();
    // seed controller text from initialValue
    _controller = TextEditingController(
      text:
          widget.initialValue != null && widget.format != null
              ? widget.format!.format(widget.initialValue!)
              : '',
    );
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reservedPadding = (_maxBorder - _minBorder) / 2;
    return FormBuilderField<DateTime>(
      name: widget.name,
      initialValue: widget.initialValue,
      validator: widget.validator,
      builder: (field) {
        final hasError = field.errorText != null;
        final isFocused = _focusNode.hasFocus;
        final borderColor =
            hasError
                ? Colors.red
                : Theme.of(context).colorScheme.surfaceContainerHigh;
        final fillColor =
            hasError
                ? Colors.red.withOpacity(0.04)
                : Theme.of(context).colorScheme.surfaceContainerLow;

        return AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Main Field Container ──
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: reservedPadding),
                    child: GestureDetector(
                      onTap:
                          widget.enabled
                              ? () async {
                                // Show the date picker dialog
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: field.value ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  // Update the form field and controller text
                                  field.didChange(picked);
                                  _controller.text =
                                      widget.format?.format(picked) ??
                                      picked.toIso8601String();
                                }
                              }
                              : null,
                      child: AbsorbPointer(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: borderColor,
                              width: _minBorder,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            readOnly: true,
                            enabled: widget.enabled,
                            decoration: InputDecoration(
                              prefixIcon:
                                  widget.leadingIcon != null
                                      ? Icon(widget.leadingIcon)
                                      : null,
                              hintText: widget.hintText ?? '',
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.5),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: fillColor,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              errorText: field.errorText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ── Focus Highlight ──
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
                              width: _maxBorder,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // ── Error Message ──
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    hasError
                        ? Padding(
                          key: ValueKey(field.errorText),
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
      },
    );
  }
}
