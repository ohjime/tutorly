import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tutorly/core/core.dart';
import 'package:animations/animations.dart';
import 'package:tutorly/signup/signup.dart';

class TimeSlotSelector extends StatefulWidget {
  const TimeSlotSelector({
    super.key,
    required this.selectedSlots,
    required this.onChanged,
    required this.month,
  });
  final DateTime month;
  final List<TimeSlot> selectedSlots;
  final ValueChanged<List<TimeSlot>> onChanged;

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  static const _rows = 24; // 24 hourly rows
  static const _hourW = 76.0; // width of hour column
  static const _rowH = 56.0; // row height
  static const _rowVerticalPadding = 6.0; // vertical padding for each row item
  static const _listViewTopPadding = 20.0;

  final _scroll = ScrollController();
  List<TimeSlot> _slots = [];
  DateTime selectedDate = DateTime.now();
  // ignore: unused_field
  late DateTime _previousDate;
  bool _reverse = false;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _slots = List.from(widget.selectedSlots); // keep local state in sync
    _previousDate = selectedDate;
  }

  @override
  void didUpdateWidget(covariant TimeSlotSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.selectedSlots, oldWidget.selectedSlots)) {
      setState(() {
        _slots = List.from(widget.selectedSlots);
      });
    }
  }

  // ───────────────────────────── Format Helpers ─────────────────────────────
  String _h(int h) => (h % 12 == 0 ? 12 : h % 12).toString().padLeft(2, ' ');
  String _ampm(int h) => h < 12 ? 'AM' : 'PM';
  String _label(int h) {
    if (h == 24) h = 0; // For displaying end of 23:00-00:00 slot
    return '${_h(h)}:00 ${_ampm(h)}';
  }

  String _slot(int h) =>
      h == 23 ? '11:00 PM – 11:59 PM' : '${_label(h)} – ${_label(h + 1)}';

  // ───────────────────────── Selection Helpers ──────────────────────────────
  bool _isHourSelected(int hour) {
    final dt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
    );
    final probe = TimeSlot(start: dt, end: dt.add(const Duration(hours: 1)));
    return _slots.any((s) => s.overlaps(probe));
  }

  void _toggleHourSelection(int hour) {
    final start = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
    );
    final slot = TimeSlot(
      start: start,
      end: start.add(const Duration(hours: 1)),
    );

    setState(() {
      final i = _slots.indexWhere((s) => s.overlaps(slot));
      if (i != -1) {
        _slots.removeAt(i); // deselect
      } else {
        _slots.add(slot); // select
        _slots.sort((a, b) => a.start.compareTo(b.start));
      }
    });
    widget.onChanged(List.unmodifiable(_slots));
  }

  void _selectAll() {
    setState(() {
      _slots
        ..clear()
        ..addAll(
          List.generate(
            _rows,
            (h) => TimeSlot(
              start: DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                h,
              ),
              end: DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                h + 1,
              ),
            ),
          ),
        );
    });
    widget.onChanged(List.unmodifiable(_slots));
  }

  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        EasyDateTimeLinePicker(
          headerOptions: HeaderOptions(
            headerBuilder: (context, date, onTap) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  '${DateFormat('EEEE').format(date)}, ${DateFormat('MMMM').format(date)} ${date.day}, ${date.year}',
                  style: TextStyle(fontSize: 18),
                ),
              );
            },
          ),
          focusedDate: selectedDate,
          firstDate: DateTime(2025, 5, 01),
          lastDate: DateTime(2025, 05, 31),
          onDateChange: (date) {
            setState(() {
              _reverse = date.isBefore(selectedDate);
              _previousDate = selectedDate;
              selectedDate = date;
            });
          },
        ),
        const SizedBox(height: 36),
        Flexible(
          fit: FlexFit.tight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Card(
                // card container
                color: cs.primary, // your desired background color
                surfaceTintColor:
                    Colors.transparent, // disable M3 elevation overlay
                elevation: 2,
                shadowColor: Colors.black.withOpacity(
                  0.2,
                ), // optional shadow tweak
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: cs.outlineVariant, width: 1),
                ),
                child: PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 400),
                  reverse: _reverse,
                  transitionBuilder:
                      (child, primaryAnimation, secondaryAnimation) =>
                          SharedAxisTransition(
                            animation: primaryAnimation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.horizontal,
                            child: child,
                          ),
                  child: Stack(
                    key: ValueKey(selectedDate),
                    clipBehavior: Clip.none,
                    children: [
                      // 1️⃣ main scrollable rows
                      ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.only(
                          top: _listViewTopPadding,
                          left: 6,
                          right: 16,
                          bottom: 10,
                        ),
                        itemCount: _rows,
                        itemBuilder: (_, i) {
                          final bool isSelected = _isHourSelected(i);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: _rowVerticalPadding,
                            ),
                            child: Row(
                              children: [
                                // hour column
                                Container(
                                  width: _hourW,
                                  height: _rowH,
                                  alignment: Alignment.topCenter,
                                  child: Transform.translate(
                                    offset: const Offset(0, -4),
                                    child: Text(
                                      _label(i),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(color: cs.onSurface),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // slot column
                                // ── slot column ───────────────────────────────────────────
                                Expanded(
                                  child: Container(
                                    height: _rowH,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? cs
                                                  .tertiary // ← background on selected
                                              : cs.surfaceContainerLow,
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? cs
                                                    .onTertiaryFixedVariant // ← border on selected
                                                : cs.outlineVariant,
                                        width: isSelected ? 3 : 0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _slot(i),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color:
                                            isSelected
                                                ? cs
                                                    .onPrimary // ← text on selected
                                                : cs.onSurface.withOpacity(0.4),
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // 2️⃣ transparent interceptor for the right column
                      Positioned(
                        left: _hourW + 6, // hour width + gap
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: _RightSideShield(
                          controller: _scroll,
                          onSlotTap: _toggleHourSelection,
                          rows: _rows,
                          rowHeight: _rowH,
                          rowVerticalPadding: _rowVerticalPadding,
                          listViewTopPadding: _listViewTopPadding,
                        ),
                      ),
                    ],
                  ),
                ),
              ), // ← end Card
              // ▲ up‑arrow overlay (above the card border)
              Positioned(
                left: _hourW / 4 + 6,
                top: -12,
                child: IgnorePointer(
                  child: Container(
                    width: _hourW / 2,
                    height: 24,
                    decoration: BoxDecoration(
                      color: cs.surfaceDim.withValues(alpha: 0.8),
                      border: Border.all(color: cs.outlineVariant, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        size: 16,
                        color: cs.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
              // ▼ down‑arrow overlay (above the card border)
              Positioned(
                left: _hourW / 4 + 6,
                bottom: -10,
                child: IgnorePointer(
                  child: Container(
                    width: _hourW / 2,
                    height: 24,
                    decoration: BoxDecoration(
                      color: cs.surfaceDim.withValues(alpha: 0.8),
                      border: Border.all(color: cs.outlineVariant, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: cs.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
              ),

              // Select All / Deselect All button
              Positioned(
                right: _hourW * 0.3,
                top: -12,
                child: GestureDetector(
                  onTap: _selectAll,
                  child: Container(
                    width: _hourW * 1.4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      border: Border.all(color: cs.secondary, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 16, color: cs.onPrimary),
                          SizedBox(width: 5),
                          Text(
                            'Select All',
                            style: TextStyle(color: cs.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _RightSideShield extends StatelessWidget {
  final ScrollController controller;
  final ValueSetter<int> onSlotTap;
  final int rows;
  final double rowHeight;
  final double rowVerticalPadding;
  final double listViewTopPadding;

  const _RightSideShield({
    required this.controller,
    required this.onSlotTap,
    required this.rows,
    required this.rowHeight,
    required this.rowVerticalPadding,
    required this.listViewTopPadding,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveItemHeight = rowHeight + (2 * rowVerticalPadding);

    return GestureDetector(
      onTapDown: (details) {
        final localDy = details.localPosition.dy;
        final scrollOffset = controller.hasClients ? controller.offset : 0.0;
        // Y position relative to the start of the scrollable content (ListView's top edge)
        final contentY = localDy + scrollOffset;

        // Y position relative to the start of the first item's padded area.
        // The ListView has its own top padding (_listViewTopPadding).
        double relativeYInList = contentY - listViewTopPadding;

        if (relativeYInList < 0) {
          return;
        } // Tap in top padding of the ListView itself, ignore

        // Determine which item index this tap falls into
        int potentialIndex = (relativeYInList / effectiveItemHeight).floor();

        // Calculate Y position within this specific item's full height (effectiveItemHeight)
        double yInItemEffectiveHeight = relativeYInList % effectiveItemHeight;

        // Check if tap is on the actual slot (height _rowH)
        // not in the item's vertical padding (_rowVerticalPadding)
        if (yInItemEffectiveHeight >= rowVerticalPadding &&
            yInItemEffectiveHeight <= (rowVerticalPadding + rowHeight)) {
          if (potentialIndex >= 0 && potentialIndex < rows) {
            onSlotTap(potentialIndex);
          }
        }
      },
      child: Container(
        color:
            Colors
                .transparent, // Essential for GestureDetector to detect taps on empty space
      ),
    );
  }
}

class FormBuilderScheduleField extends FormBuilderField<Schedule> {
  FormBuilderScheduleField({
    super.key,
    required super.name,
    Schedule? initialValue,
    super.validator,
    InputDecoration decoration = const InputDecoration(
      border: InputBorder.none,
    ),
  }) : super(
         initialValue: initialValue ?? Schedule.empty,
         builder: (FormFieldState<Schedule> field) {
           final Schedule value = field.value!;
           return InputDecorator(
             decoration: decoration.copyWith(errorText: field.errorText),
             child: TimeSlotSelector(
               month: value.month.date(year: value.year),
               selectedSlots: value.slots,
               onChanged: (updated) {
                 field.didChange(value.copyWith(initialSlots: updated));
               },
             ),
           );
         },
       );
}

Widget userScheduleStep(
  BuildContext context,
  GlobalKey<FormBuilderState> formKey,
) {
  final signupState = context.read<SignupCubit>().state;
  final existingSchedule = signupState.user.schedule;

  return FormBuilder(
    key: formKey,
    child: FormBuilderScheduleField(
      name: 'schedule',
      initialValue: existingSchedule,
    ),
  );
}
