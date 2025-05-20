import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tutorly/core/core.dart';

/// ---------------------------------------------------------------------------
/// Generic dropdown‑with‑suggestions field
/// Re‑uses styling/behaviour from InstituteField, but works for any value type.
/// ---------------------------------------------------------------------------
///
/// Example usage (dynamic suggestions):
/// ```dart
/// DropDownField<String>(
///   name: 'institution',
///   initialValue: widget.credential.institution,
///   suggestionsCallback: (q) => _searchInstitutions(q),
///   isRequired: true,
///   mustBeSuggestion: true,
/// )
/// ```
///
/// Example usage (select-only mode with fixed options):
/// ```dart
/// DropDownField<String>.select(
///   name: 'country',
///   initialValue: 'Canada',
///   options: ['Canada', 'USA', 'Mexico'],
///   labelText: 'Country',
///   isRequired: true,
/// )
/// ```
class DropDownField<T> extends StatefulWidget {
  /// Main constructor for dynamic suggestions.
  const DropDownField({
    super.key,
    required this.name,
    required this.suggestionsCallback,
    this.initialValue,
    this.raiseLabel = false,
    this.labelText,
    this.hintText,
    this.isRequired = false,
    this.mustBeSuggestion = false,
    this.displayStringForOption,
    this.requiredErrorText,
    this.suggestionErrorText,
    this.showSuggestionsWhenEmpty = false,
  }) : _isSelectMode = false,
       _fixedSuggestions = null;

  /// Internal constructor for setup.
  const DropDownField._internal({
    super.key,
    required this.name,
    required this.suggestionsCallback,
    this.initialValue,
    this.raiseLabel = false,
    this.labelText,
    this.hintText,
    this.isRequired = false,
    this.mustBeSuggestion = false,
    this.displayStringForOption,
    this.requiredErrorText,
    this.suggestionErrorText,
    this.showSuggestionsWhenEmpty = false,
    required bool isSelectMode,
    List<T>? fixedSuggestions,
  }) : _isSelectMode = isSelectMode,
       _fixedSuggestions = fixedSuggestions;

  /// Factory constructor for a select-only dropdown with a fixed list of options.
  /// In this mode, the user can only pick from the provided [options].
  /// The field is read-only, and all options are shown when focused.
  factory DropDownField.select({
    Key? key,
    required String name,
    required List<T> options,
    T? initialValue,
    bool raiseLabel = false,
    String? labelText,
    String? hintText,
    bool isRequired = false,
    String Function(T)? displayStringForOption,
    String? requiredErrorText,
  }) {
    return DropDownField._internal(
      key: key,
      name: name,
      // This callback is required by _internal but won't be used in select mode
      // as _suggestions are populated directly from _fixedSuggestions.
      suggestionsCallback: (_) async => [],
      initialValue: initialValue,
      raiseLabel: raiseLabel,
      labelText: labelText,
      hintText: hintText,
      isRequired: isRequired,
      mustBeSuggestion:
          true, // In select mode, value must come from suggestions.
      displayStringForOption: displayStringForOption,
      requiredErrorText: requiredErrorText,
      suggestionErrorText:
          null, // Not applicable as user cannot type invalid input.
      showSuggestionsWhenEmpty: true, // Ensures suggestions appear if focused.
      isSelectMode: true,
      fixedSuggestions: options,
    );
  }

  /// Form field name inside [FormBuilder].
  final String name;

  /// Initial value for the field.
  final T? initialValue;

  /// Called every time the user types. Must return matching suggestions.
  /// Not used if constructed with `DropDownField.select`.
  final Future<List<T>> Function(String) suggestionsCallback;

  /// Hint text shown when no value is present.
  final String? hintText;

  /// Marks the field as required.
  final bool isRequired;

  /// Forces the final value to be one of the suggestions.
  /// Implicitly true for `DropDownField.select`.
  final bool mustBeSuggestion;

  /// Maps a value of type [T] to a user‑visible string. Defaults to `toString`.
  final String Function(T)? displayStringForOption;

  /// If true, show [labelText] above the field; otherwise use it as hint text.
  final bool raiseLabel;

  /// Text label for the field.
  final String? labelText;

  /// Override default "Required" text when [isRequired] fails.
  final String? requiredErrorText;

  /// Override default "Please choose a valid option" text when [mustBeSuggestion] fails.
  /// Not typically shown in `DropDownField.select` mode.
  final String? suggestionErrorText;

  /// If `true`, show full suggestions list even when the text box is empty (for dynamic suggestions).
  /// Implicitly true for `DropDownField.select` when focused.
  final bool showSuggestionsWhenEmpty;

  // Internal properties to manage different modes
  final bool _isSelectMode;
  final List<T>? _fixedSuggestions;

  @override
  State<DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<DropDownField<T>>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  late final TextEditingController _controller;

  // Most recent suggestion set.
  List<T> _suggestions = const [];

  String _display(T v) =>
      widget.displayStringForOption?.call(v) ?? v.toString();

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text:
          widget.initialValue == null ? '' : _display(widget.initialValue as T),
    );

    _focusNode.addListener(() => setState(() {}));

    if (widget._isSelectMode) {
      // For select mode, suggestions are fixed and loaded immediately.
      _suggestions = widget._fixedSuggestions ?? const [];
      // No listener needed to fetch suggestions dynamically.
    } else {
      // Original behavior for dynamic suggestions
      _controller.addListener(() async {
        // Do not run if select mode (though already guarded by if/else)
        if (widget._isSelectMode) return;
        final results = await widget.suggestionsCallback(
          _controller.text.trim(),
        );
        if (mounted) setState(() => _suggestions = results);
      });

      // Prime initial suggestion list for dynamic mode.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (widget._isSelectMode) return; // Should not run in select mode

        if (_controller.text.trim().isNotEmpty ||
            widget.showSuggestionsWhenEmpty) {
          final query =
              widget.showSuggestionsWhenEmpty && _controller.text.trim().isEmpty
                  ? ''
                  : _controller.text.trim();
          final results = await widget.suggestionsCallback(query);
          if (mounted) setState(() => _suggestions = results);
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSuggestionsListContent(
    ThemeData theme,
    FormFieldState<T> field,
  ) {
    if (widget._isSelectMode) {
      // For select mode, always show all fixed suggestions or "no options".
      if (_suggestions.isEmpty) {
        // _suggestions are from widget._fixedSuggestions
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text(
            'No options available',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          for (final option
              in _suggestions) // _suggestions are the fixed options
            ListTile(
              title: Text(_display(option)),
              onTap: () {
                _controller.text = _display(option);
                field.didChange(option);
                _focusNode.unfocus();
              },
            ),
        ],
      );
    } else {
      // Original logic for dynamic suggestions
      if (_controller.text.isEmpty && !widget.showSuggestionsWhenEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text(
            'Type to search',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      }
      if (_suggestions.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text(
            'No results found',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:
            MainAxisSize.min, // Important for scrollability if list is long
        children: [
          for (final option in _suggestions)
            ListTile(
              title: Text(_display(option)),
              onTap: () {
                _controller.text = _display(option);
                field.didChange(option);
                _focusNode.unfocus();
              },
            ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double maxBorderWidth = 3.5;
    const double minBorderWidth = 2.5;
    final reservedPadding = (maxBorderWidth - minBorderWidth) / 2;

    return FormBuilderField<T>(
      name: widget.name,
      initialValue: widget.initialValue,
      validator: (val) {
        final text = _controller.text.trim();

        // 1️⃣ Show the “required” error only when the input is empty.
        if (widget.isRequired && text.isEmpty) {
          return widget.requiredErrorText ?? 'Required';
        }

        // 2️⃣ If the user typed something but didn’t pick a suggestion,
        //    show the “must be suggestion” error.
        if (widget.mustBeSuggestion && val == null && text.isNotEmpty) {
          return widget.suggestionErrorText ?? 'Please choose a valid option';
        }

        return null;
      },
      builder: (field) {
        final hasError = field.errorText != null;
        final isFocused = _focusNode.hasFocus;

        final bool showRaisedLabel =
            widget.raiseLabel && (widget.labelText?.isNotEmpty ?? false);

        final String effectiveHintText =
            showRaisedLabel
                ? (widget.hintText ?? 'Select')
                : (widget.labelText ?? widget.hintText ?? 'Select');

        final bool hasValue = () {
          final v = field.value;
          if (v == null) return false;
          if (v is String) return v.trim().isNotEmpty; // treat '' as empty
          return true; // any other non‑null type counts
        }();

        final borderColor =
            hasError ? Colors.red : theme.colorScheme.surfaceContainerHigh;
        final fillColor =
            hasError
                ? Colors.red.withOpacity(0.04)
                : theme.colorScheme.surfaceContainerLow;

        final Widget fieldWidget = AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Column(
            // Removed non-standard 'spacing' property. Manage spacing with Padding/SizedBox if needed.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Field Container ──
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
                      child: TextField(
                        inputFormatters: [capitalizeWords],
                        controller: _controller,
                        focusNode: _focusNode,
                        autocorrect: false,
                        enableSuggestions: false,
                        readOnly:
                            widget
                                ._isSelectMode, // Make TextField read-only in select mode
                        decoration: InputDecoration(
                          hintText: effectiveHintText,
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
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
                          suffixIcon:
                              hasValue
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    tooltip: 'Clear',
                                    onPressed: () {
                                      final wasFocused = _focusNode.hasFocus;
                                      // setState is called by field.didChange
                                      _controller.clear();
                                      field.didChange(null);
                                      if (wasFocused) {
                                        _focusNode.requestFocus();
                                      }
                                      // For select mode, ensure suggestions list remains populated
                                      if (widget._isSelectMode && mounted) {
                                        setState(() {
                                          _suggestions =
                                              widget._fixedSuggestions ??
                                              const [];
                                        });
                                      }
                                    },
                                  )
                                  : null,
                        ),
                        onChanged:
                            widget._isSelectMode
                                ? null // In readOnly mode, onChanged from user typing won't fire.
                                : (_) {
                                  // Reset value until user selects from list for non-select mode.
                                  field.didChange(null);
                                  // Suggestions are updated by the _controller listener for non-select mode.
                                },
                        onTap: () {
                          // Ensure focus to show suggestions, especially for readOnly field
                          if (!_focusNode.hasFocus) {
                            _focusNode.requestFocus();
                          }
                          // For select mode, if suggestions are somehow cleared (e.g. dev error), re-populate
                          if (widget._isSelectMode &&
                              _suggestions.isEmpty &&
                              (widget._fixedSuggestions?.isNotEmpty ?? false)) {
                            if (mounted) {
                              setState(() {
                                _suggestions = widget._fixedSuggestions!;
                              });
                            }
                          }
                        },
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
                              color:
                                  borderColor, // Uses error color if hasError
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

              // ── Error Message ──
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child:
                    hasError
                        ? Padding(
                          padding: const EdgeInsets.only(
                            top: 4,
                            left: 12,
                            bottom: 4,
                          ),
                          child: Text(
                            field.errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                        : const SizedBox(height: 8),
              ),

              // ── Suggestions List ──
              AnimatedSize(
                duration: const Duration(milliseconds: 600),
                curve: Curves.linearToEaseOut,
                alignment: Alignment.topCenter,
                child:
                    isFocused // Show suggestions container only when focused
                        ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.surfaceContainerLow,
                              width: minBorderWidth,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: theme.colorScheme.surfaceContainerLowest
                                .withOpacity(0.5),
                          ),
                          child: _buildSuggestionsListContent(theme, field),
                        )
                        : const SizedBox(height: 0, width: double.infinity),
              ),
            ],
          ),
        );

        if (showRaisedLabel) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  widget.labelText!,
                  style: theme.textTheme.bodySmall,
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

// Helper Column extension if you were using `spacing` (example, not used in above code directly)
// extension ColumnSpacing on Column {
//   ColumnCopyWith get copyWith => ColumnCopyWith(this);
// }

// class ColumnCopyWith {
//   final Column _original;
//   const ColumnCopyWith(this._original);

//   Column call({List<Widget>? children, double? spacing}) {
//     List<Widget> newChildren = children ?? _original.children;
//     if (spacing != null && newChildren.length > 1) {
//       final spacedChildren = <Widget>[];
//       for (int i = 0; i < newChildren.length; i++) {
//         spacedChildren.add(newChildren[i]);
//         if (i < newChildren.length - 1) {
//           spacedChildren.add(SizedBox(height: spacing, width: spacing)); // Assuming vertical for now
//         }
//       }
//       newChildren = spacedChildren;
//     }
//     return Column(
//       key: _original.key,
//       mainAxisAlignment: _original.mainAxisAlignment,
//       mainAxisSize: _original.mainAxisSize,
//       crossAxisAlignment: _original.crossAxisAlignment,
//       textDirection: _original.textDirection,
//       verticalDirection: _original.verticalDirection,
//       textBaseline: _original.textBaseline,
//       children: newChildren,
//     );
//   }
// }
