import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:tutorly/core/core.dart';
import 'package:tutorly/signup/cubit/signup_cubit.dart';

Widget userProfileStep(
  BuildContext context,
  GlobalKey<FormBuilderState> formKey,
) {
  return UserProfileStep(formKey: formKey);
}

class UserProfileStep extends StatelessWidget {
  const UserProfileStep({required this.formKey, super.key});

  final GlobalKey<FormBuilderState>? formKey;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: formKey,
        child: Column(
          spacing: 20,
          children: [
            SizedBox(
              height: 200 + (120 / 2) + 16 + 92,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 190,
                    child: DependentRectangleImagePickerField(height: 190),
                  ),
                  Positioned(
                    top: 200 - (120 / 2) + 15,
                    left: 16,
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: DependentImagePickerField(),
                    ),
                  ),
                  Positioned(
                    top: 200 + 12 + 15,
                    left: 16 + 120 + 10 + 8,
                    right: 0,
                    child: NameField(),
                  ),
                  Positioned(
                    top: 200 - (120 / 2) + 146 + 2,
                    left: 16,
                    child: Text('Headline (Optional)'),
                  ),
                  Positioned(
                    top: 200 + 92 + 18 + 2,
                    left: 0,
                    right: 0,
                    child: HeadlineField(),
                  ),
                  Positioned(
                    top: 200 - (120 / 2) + 236 - 5,
                    left: 32,
                    child: Text('Bio (Optional)'),
                  ),
                  Positioned(
                    top: 200 + 92 + 18 + 90 - 5,
                    left: 0,
                    right: 0,
                    child: BioField(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeadlineField extends StatefulWidget {
  const HeadlineField({super.key});

  @override
  State<HeadlineField> createState() => _HeadlineFieldState();
}

class _HeadlineFieldState extends State<HeadlineField>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxBorderWidth = 3.5;
    const double minBorderWidth = 2.5;
    final double reservedPadding = (maxBorderWidth - minBorderWidth) / 2;

    final isFocused = _focusNode.hasFocus;
    final borderColor = Theme.of(context).colorScheme.surfaceContainerHigh;
    final fillColor = Theme.of(context).colorScheme.surfaceContainerLow;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Column(
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
                  child: FormBuilderTextField(
                    name: 'headline',
                    focusNode: _focusNode,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText:
                          context.read<SignupCubit>().state.user.role ==
                                  UserRole.tutor
                              ? 'Follow where reason leads!'
                              : 'Just another student cramming finals...',

                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
                        wordSpacing: 1,
                        fontStyle: FontStyle.italic,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: fillColor,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                    ),
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
        ],
      ),
    );
  }
}

class BioField extends StatefulWidget {
  const BioField({super.key});

  @override
  State<BioField> createState() => _BioFieldState();
}

class _BioFieldState extends State<BioField>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxBorderWidth = 3.5;
    const double minBorderWidth = 2.5;
    final reservedPadding = (maxBorderWidth - minBorderWidth) / 2;
    final isFocused = _focusNode.hasFocus;
    final borderColor = Theme.of(context).colorScheme.surfaceContainerHigh;
    final fillColor = Theme.of(context).colorScheme.surfaceContainerLow;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: reservedPadding),
                child: Container(
                  height: 150, // taller height
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColor,
                      width: minBorderWidth,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FormBuilderTextField(
                    name: 'bio',
                    focusNode: _focusNode,
                    maxLength: 500,
                    minLines: 5,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText:
                          context.read<SignupCubit>().state.user.role ==
                                  UserRole.tutor
                              ? 'I enjoy long walks on the beach and teaching my favorite subject which is..'
                              : 'My mother says I am a genius and I should be a doctor!',

                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
                        wordSpacing: 1,
                        fontStyle: FontStyle.italic,
                      ),
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: fillColor,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
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
        ],
      ),
    );
  }
}

class NameField extends StatefulWidget {
  // Removed constructor parameters
  const NameField({super.key});

  @override
  // Updated state class name
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxBorderWidth = 3.5;
    const double minBorderWidth = 2.5;
    final double reservedPadding = (maxBorderWidth - minBorderWidth) / 2;

    // Hardcoded field names
    const String fieldName = 'name';
    // Hardcoded hint texts
    const String hintText = 'Full Name';
    // Hardcoded validators
    final validators = [
      FormBuilderValidators.required(errorText: 'Name is required'),
    ];

    return FormBuilderField<String>(
      initialValue: context.read<SignupCubit>().state.user.name,
      name: fieldName, // Use hardcoded field name
      validator: FormBuilderValidators.compose(validators),
      builder: (field) {
        // Determine error state
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
                          // ── First Field ──
                          TextFormField(
                            initialValue: field.value,
                            inputFormatters: [capitalizeWords],
                            focusNode: _focusNode,
                            onChanged: field.didChange,
                            decoration: InputDecoration(
                              hintText: hintText, // Use hardcoded hint text
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
      },
    );
  }
}

class DependentImagePickerField extends StatefulWidget {
  const DependentImagePickerField({
    super.key,
    this.dependentFieldName = 'name',
  });

  final String dependentFieldName;

  @override
  State<DependentImagePickerField> createState() =>
      _DependentImagePickerFieldState();
}

class _DependentImagePickerFieldState extends State<DependentImagePickerField> {
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      // Replace whatever was there before (maxImages = 1)
      FormBuilder.of(context)!.fields['imageUrl']?.didChange(<XFile>[file]);
    }
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pick(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pick(ImageSource.gallery);
                  },
                ),
                if ((FormBuilder.of(context)!.fields['imageUrl']?.value ?? [])
                    .isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Remove'),
                    onTap: () {
                      FormBuilder.of(
                        context,
                      )!.fields['imageUrl']?.didChange(<dynamic>[]);
                      Navigator.pop(ctx);
                    },
                  ),
              ],
            ),
          ),
    );
  }

  // One helper so the frame is identical in both states
  Widget _frame(Widget child, {required bool hasImage}) => Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      color: hasImage ? null : Theme.of(context).colorScheme.secondaryContainer,
      shape: BoxShape.circle,
      border: Border.all(
        strokeAlign: BorderSide.strokeAlignOutside,
        width: 6,
        color:
            hasImage
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.surfaceContainer,
      ),
    ),
    clipBehavior: hasImage ? Clip.antiAlias : Clip.none,
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return FormBuilderImagePicker(
      name: 'imageUrl',
      maxImages: 1,
      // Persist as a local file path (String) instead of an XFile
      valueTransformer: (value) {
        if (value == null || value.isEmpty) return null;
        final first = value.first;
        return first is XFile ? first.path : null;
      },
      // Re‑hydrate picker preview from the cached path in SignupCubit
      initialValue: () {
        final path = context.read<SignupCubit>().state.user.imageUrl;
        if (path == null || path.isEmpty) {
          return const [];
        }
        return [XFile(path)];
      }(),
      fit: BoxFit.cover,
      showDecoration: false,
      // Placeholder (no picture yet)
      placeholderWidget: Builder(
        builder: (context) {
          final name =
              FormBuilder.of(
                context,
              )!.fields[widget.dependentFieldName]?.value ??
              '';
          return GestureDetector(
            onTap: _showSourceSheet,
            child: _frame(
              Stack(
                alignment: Alignment.center,
                children: [
                  RandomAvatar(
                    name == ''
                        ? (context.read<SignupCubit>().state.user.name == ''
                            ? 'guest'
                            : context.read<SignupCubit>().state.user.name)
                        : name,
                    trBackground: true,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: CircleAvatar(
                      radius: 16,

                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      child: Icon(
                        Icons.photo_camera,
                        size: 20,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              hasImage: false,
            ),
          );
        },
      ),
      // How each picked image is shown
      transformImageWidget:
          (_, image) => GestureDetector(
            onTap: _showSourceSheet,
            child: _frame(image, hasImage: true),
          ),
    );
  }
}

class DependentRectangleImagePickerField extends StatefulWidget {
  const DependentRectangleImagePickerField({super.key, this.height = 150});

  final double height;

  @override
  State<DependentRectangleImagePickerField> createState() =>
      _DependentRectangleImagePickerFieldState();
}

class _DependentRectangleImagePickerFieldState
    extends State<DependentRectangleImagePickerField> {
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      FormBuilder.of(context)!.fields['coverUrl']?.didChange(<XFile>[file]);
    }
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pick(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pick(ImageSource.gallery);
                  },
                ),
                if ((FormBuilder.of(context)!.fields['coverUrl']?.value ?? [])
                    .isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Remove'),
                    onTap: () {
                      FormBuilder.of(
                        context,
                      )!.fields['coverUrl']?.didChange(<dynamic>[]);
                      Navigator.pop(ctx);
                    },
                  ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderImagePicker(
      name: 'coverUrl',
      maxImages: 1,
      valueTransformer: (value) {
        if (value == null || value.isEmpty) return null;
        final first = value.first;
        return first is XFile ? first.path : null;
      },
      initialValue: () {
        final path = context.read<SignupCubit>().state.user.coverUrl;
        if (path == null || path.isEmpty) {
          return const [];
        }
        return [XFile(path)];
      }(),
      showDecoration: false,
      placeholderWidget: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            width: 4,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          Theme.of(context).brightness == Brightness.light
              ? 'assets/images/shared/cover_light.png'
              : 'assets/images/shared/cover_dark.png',
          fit: BoxFit.cover,
        ),
      ),
      transformImageWidget:
          (_, image) => GestureDetector(
            onTap: _showSourceSheet,
            child: Container(
              width: double.infinity,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  width: 4,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: image,
            ),
          ),
    );
  }
}
