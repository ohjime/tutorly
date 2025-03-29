import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tutorly/schedule/exports.dart';

class QuickScheduleList extends StatefulWidget {
  const QuickScheduleList({super.key});

  @override
  State<QuickScheduleList> createState() => _QuickScheduleListState();
}

class _QuickScheduleListState extends State<QuickScheduleList> {
  late final Map<String, dynamic> scheduleDates;

  @override
  void initState() {
    super.initState();
    DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime endDate = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      0,
    );
    scheduleDates = {};
    for (
      DateTime date = startDate;
      date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
      date = date.add(const Duration(days: 1))
    ) {
      scheduleDates.addAll({DateFormat('yyyy-MM-dd').format(date): []});
    }
  }

  void handleWeekdaySelected(Map<String, dynamic> weekdaySelection) async {
    setState(() {
      scheduleDates.addAll(weekdaySelection);
    });
    context.read<ScheduleCubit>().updateSchedule(scheduleDates);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 60),
        Text(
          'Select Your Availability',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          width: 300,
          child: Text(
            'Your availability needs to be updated.\nPlease select the days and times you are available to tutor.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Column(
                children: [
                  Text(
                    'Mornings',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '8:00 AM\nto\n12:00 PM',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    'Afternoons',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '12:00 PM\nto\n4:00 PM',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    'Evenings',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '4:00 PM\nto\n8:00 PM',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 30,
                children: List.generate(scheduleDates.length, (index) {
                  String date = scheduleDates.keys.elementAt(index);
                  return QuickWeekdayButton(
                    weekday: date,
                    onSelectionChanged: handleWeekdaySelected,
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
