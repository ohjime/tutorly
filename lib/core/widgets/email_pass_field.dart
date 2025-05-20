import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class EmailPasswordLoginField extends StatefulWidget {
  // Removed constructor parameters
  const EmailPasswordLoginField({super.key});

  @override
  // Updated state class name
  State<EmailPasswordLoginField> createState() =>
      _EmailPasswordLoginFieldState();
}

// ─────────────────────────────────────────────────────────────────────────────
//  Email‑Password‑Confirm Signup Composite Field
//  Same styling as EmailPasswordLoginField, but with an additional
//  “Confirm Password” field under the password field.
// ─────────────────────────────────────────────────────────────────────────────
class EmailPasswordSignupField extends StatefulWidget {
  const EmailPasswordSignupField({super.key});

  @override
  State<EmailPasswordSignupField> createState() =>
      _EmailPasswordSignupFieldState();
}

class _EmailPasswordSignupFieldState extends State<EmailPasswordSignupField>
    with SingleTickerProviderStateMixin {
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() => setState(() {}));
    _focusNode2.addListener(() => setState(() {}));
    _focusNode3.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxBorderWidth = 3.5;
    const double minBorderWidth = 2.5;
    final double reservedPadding = (maxBorderWidth - minBorderWidth) / 2;

    // Field names
    const String fieldName1 = 'email';
    const String fieldName2 = 'password';
    const String fieldName3 = 'confirmPassword';

    // Hint texts
    const String hintText1 = 'Email Address';
    const String hintText2 = 'Password';
    const String hintText3 = 'Confirm Password';

    // Validators
    final validators1 = [
      FormBuilderValidators.required(errorText: 'Email is required'),
      FormBuilderValidators.email(errorText: 'Enter a valid email address'),
    ];
    final validators2 = [
      FormBuilderValidators.required(errorText: 'Password is required'),
      FormBuilderValidators.minLength(
        6,
        errorText: 'Password must be at least 6 characters',
      ),
    ];
    // Confirm password validator needs to compare with password field
    String? confirmValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Password confirmation is required';
      }
      final passwordValue =
          FormBuilder.of(context)?.fields[fieldName2]?.value as String?;
      if (value != passwordValue) {
        return 'Passwords do not match';
      }
      return null;
    }

    return FormBuilderField(
      name: 'signup', // outer dummy wrapper
      builder: (wrapperField) {
        return FormBuilderField<String>(
          name: fieldName1,
          validator: FormBuilderValidators.compose(validators1),
          builder: (field1) {
            return FormBuilderField<String>(
              name: fieldName2,
              validator: FormBuilderValidators.compose(validators2),
              builder: (field2) {
                return FormBuilderField<String>(
                  name: fieldName3,
                  validator: confirmValidator,
                  builder: (field3) {
                    // Error and focus states
                    final hasError1 = field1.errorText != null;
                    final hasError2 = field2.errorText != null;
                    final hasError3 = field3.errorText != null;
                    final hasAnyError = hasError1 || hasError2 || hasError3;

                    final isFocused =
                        _focusNode1.hasFocus ||
                        _focusNode2.hasFocus ||
                        _focusNode3.hasFocus;

                    final borderColor =
                        hasAnyError
                            ? Colors.red
                            : Theme.of(context).colorScheme.surfaceDim;

                    final fieldFill1 =
                        hasError1
                            ? Colors.red.withOpacity(0.04)
                            : Theme.of(context).colorScheme.surfaceContainerLow;
                    final fieldFill2 =
                        hasError2
                            ? Colors.red.withOpacity(0.04)
                            : Theme.of(context).colorScheme.surfaceContainerLow;
                    final fieldFill3 =
                        hasError3
                            ? Colors.red.withOpacity(0.04)
                            : Theme.of(context).colorScheme.surfaceContainerLow;

                    return AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              // Base container with minimum border
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: reservedPadding,
                                ),
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
                                      // ── Email Field ──
                                      TextField(
                                        focusNode: _focusNode1,
                                        onChanged: field1.didChange,
                                        decoration: InputDecoration(
                                          hintText: hintText1,
                                          hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                            wordSpacing: -2,
                                          ),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(9.5),
                                              topRight: Radius.circular(9.5),
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          fillColor: fieldFill1,
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 18,
                                                vertical: 8,
                                              ),
                                        ),
                                      ),
                                      Divider(
                                        height: 1.5,
                                        thickness: 1.5,
                                        color: borderColor,
                                      ),
                                      // ── Password Field ──
                                      TextField(
                                        focusNode: _focusNode2,
                                        onChanged: field2.didChange,
                                        obscureText: obscureText,
                                        decoration: InputDecoration(
                                          hintText: hintText2,
                                          hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                          ),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide.none,
                                          ),
                                          fillColor: fieldFill2,
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 18,
                                                vertical: 8,
                                              ),
                                        ),
                                      ),
                                      Divider(
                                        height: 1.5,
                                        thickness: 1.5,
                                        color: borderColor,
                                      ),
                                      // ── Confirm Password Field ──
                                      TextField(
                                        focusNode: _focusNode3,
                                        onChanged: field3.didChange,
                                        obscureText: obscureText,
                                        decoration: InputDecoration(
                                          hintText: hintText3,
                                          hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                          ),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(9.5),
                                              bottomRight: Radius.circular(9.5),
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          fillColor: fieldFill3,
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 18,
                                                vertical: 8,
                                              ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              obscureText
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.6),
                                            ),
                                            onPressed:
                                                () => setState(
                                                  () =>
                                                      obscureText =
                                                          !obscureText,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Overlay thicker border when focused
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
                                          strokeAlign:
                                              BorderSide.strokeAlignInside,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          // ── Error Messages ──
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child:
                                hasError1
                                    ? Padding(
                                      key: ValueKey(
                                        'error1_${field1.errorText}',
                                      ),
                                      padding: const EdgeInsets.only(
                                        top: 4.0,
                                        left: 12.0,
                                      ),
                                      child: Text(
                                        field1.errorText!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child:
                                hasError2
                                    ? Padding(
                                      key: ValueKey(
                                        'error2_${field2.errorText}',
                                      ),
                                      padding: const EdgeInsets.only(
                                        top: 2.0,
                                        left: 12.0,
                                      ),
                                      child: Text(
                                        field2.errorText!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child:
                                hasError3
                                    ? Padding(
                                      key: ValueKey(
                                        'error3_${field3.errorText}',
                                      ),
                                      padding: const EdgeInsets.only(
                                        top: 2.0,
                                        left: 12.0,
                                      ),
                                      child: Text(
                                        field3.errorText!,
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
              },
            );
          },
        );
      },
    );
  }
}

class _EmailPasswordLoginFieldState extends State<EmailPasswordLoginField>
    with SingleTickerProviderStateMixin {
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  bool obscureText = false; // Keep state for toggling visibility

  @override
  void initState() {
    super.initState();
    // Hardcoded obscureText initial state
    _focusNode1.addListener(() {
      setState(() {});
    });
    _focusNode2.addListener(() {
      setState(() {});
    });
    obscureText = true;
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxBorderWidth = 3.5;
    const double minBorderWidth = 2.5;
    final double reservedPadding = (maxBorderWidth - minBorderWidth) / 2;

    // Hardcoded field names
    const String fieldName1 = 'email';
    const String fieldName2 = 'password';
    // Hardcoded hint texts
    const String hintText1 = 'Email Address';
    const String hintText2 = 'Password';
    // Hardcoded validators
    final validators1 = [
      FormBuilderValidators.required(errorText: 'Email is required'),
      FormBuilderValidators.email(errorText: 'Enter a valid email address'),
    ];
    final validators2 = [
      FormBuilderValidators.required(errorText: 'Password is required'),
      FormBuilderValidators.minLength(
        6,
        errorText: 'Password must be at least 6 characters',
      ),
    ];

    return FormBuilderField(
      name: 'login', // dummy name using hardcoded values
      builder: (wrapperField) {
        return FormBuilderField<String>(
          name: fieldName1, // Use hardcoded field name
          validator: FormBuilderValidators.compose(validators1),
          builder: (field1) {
            return FormBuilderField<String>(
              name: fieldName2, // Use hardcoded field name
              validator: FormBuilderValidators.compose(validators2),
              builder: (field2) {
                // Determine error state
                final hasError1 = field1.errorText != null;
                final hasError2 = field2.errorText != null;
                final hasAnyError = hasError1 || hasError2;

                final isFocused = _focusNode1.hasFocus || _focusNode2.hasFocus;

                final borderColor =
                    hasAnyError
                        ? Colors.red
                        : Theme.of(context).colorScheme.surfaceDim;

                final fieldFill1 =
                    hasError1
                        ? Colors.red.withValues(alpha: 0.04)
                        : Theme.of(context).colorScheme.surfaceContainerLow;

                final fieldFill2 =
                    hasError2
                        ? Colors.red.withValues(alpha: 0.04)
                        : Theme.of(context).colorScheme.surfaceContainerLow;

                return AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          // Base container with minimum border
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: reservedPadding,
                            ),
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
                                  // ── First Field ──
                                  TextField(
                                    focusNode: _focusNode1,
                                    onChanged: field1.didChange,
                                    decoration: InputDecoration(
                                      hintText:
                                          hintText1, // Use hardcoded hint text
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.5),
                                        wordSpacing: -2,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(9.5),
                                          topRight: Radius.circular(9.5),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      fillColor: fieldFill1,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.5,
                                    thickness: 1.5,
                                    color: borderColor,
                                  ),
                                  // ── Second Field ──
                                  TextField(
                                    focusNode: _focusNode2,
                                    onChanged: field2.didChange,
                                    obscureText:
                                        obscureText, // Use state variable
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.5),
                                      ),
                                      hintText:
                                          hintText2, // Use hardcoded hint text
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(9.5),
                                          bottomRight: Radius.circular(9.5),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      fillColor: fieldFill2,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 8,
                                          ),
                                      suffixIcon: IconButton(
                                        // Directly use IconButton since obscureSecond is always true
                                        icon: Icon(
                                          obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.6),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            obscureText = !obscureText;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Overlay thicker border when focused
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
                      // ── Error Messages ──
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child:
                            hasError1
                                ? Padding(
                                  key: ValueKey('error1_${field1.errorText}'),
                                  padding: const EdgeInsets.only(
                                    top: 4.0,
                                    left: 12.0,
                                  ),
                                  child: Text(
                                    field1.errorText!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink(),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child:
                            hasError2
                                ? Padding(
                                  key: ValueKey('error2_${field2.errorText}'),
                                  padding: const EdgeInsets.only(
                                    top: 2.0,
                                    left: 12.0,
                                  ),
                                  child: Text(
                                    field2.errorText!,
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
          },
        );
      },
    );
  }
}
