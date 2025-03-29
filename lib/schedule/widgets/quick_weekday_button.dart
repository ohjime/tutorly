import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum QuickTimes { mornings, afternoons, evenings }

const Map<QuickTimes, Map<String, String>> quickTimeIntervals = {
  QuickTimes.mornings: {"start": "08:00", "end": "12:00"},
  QuickTimes.afternoons: {"start": "12:00", "end": "16:00"},
  QuickTimes.evenings: {"start": "16:00", "end": "20:00"},
};

class QuickWeekdayButton extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSelectionChanged;
  final String weekday;
  const QuickWeekdayButton({
    super.key,
    required this.weekday,
    required this.onSelectionChanged,
  });

  @override
  State<QuickWeekdayButton> createState() => _QuickWeekdayButtonState();
}

class _QuickWeekdayButtonState extends State<QuickWeekdayButton> {
  Set<QuickTimes> selection = <QuickTimes>{};

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              selection.isNotEmpty
                  ? Colors.green
                  : Theme.of(context).colorScheme.primaryContainer,
          width: 2,
        ),
      ),
      duration: const Duration(milliseconds: 100),
      padding: const EdgeInsets.all(14),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat(
                    'EEEE MMMM d, y',
                  ).format(DateTime.parse(widget.weekday)),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                ),
                Icon(
                  Icons.check,
                  color:
                      selection.isNotEmpty
                          ? Colors.green
                          : Theme.of(context).colorScheme.primaryContainer,
                ),
              ],
            ),
          ),
          // The main content of the card.
          SegmentedButton<QuickTimes>(
            style: SegmentedButton.styleFrom(
              padding: const EdgeInsets.all(14),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2,
              ),
              backgroundColor: Theme.of(context).colorScheme.surfaceDim,
              foregroundColor:
                  Theme.of(context).colorScheme.onTertiaryContainer,
              selectedForegroundColor: Theme.of(context).colorScheme.primary,
              selectedBackgroundColor: Colors.green.withAlpha(100),
            ),
            segments: const <ButtonSegment<QuickTimes>>[
              ButtonSegment<QuickTimes>(
                value: QuickTimes.mornings,
                label: Text('Mornings'),
              ),
              ButtonSegment<QuickTimes>(
                value: QuickTimes.afternoons,
                label: Text('Afternoons'),
              ),
              ButtonSegment<QuickTimes>(
                value: QuickTimes.evenings,
                label: Text('Evenings'),
              ),
            ],
            selected: selection,
            showSelectedIcon: false,
            emptySelectionAllowed: true,
            onSelectionChanged: (Set<QuickTimes> newSelection) {
              setState(() {
                selection = newSelection;
              });

              final intervals =
                  selection
                      .map(
                        (quickTime) => {
                          "start": quickTimeIntervals[quickTime]!["start"],
                          "end": quickTimeIntervals[quickTime]!["end"],
                        },
                      )
                      .toList();

              widget.onSelectionChanged({widget.weekday: intervals});
            },
            multiSelectionEnabled: true,
          ),
        ],
      ),
    );
  }
}
