import 'package:equatable/equatable.dart';
import 'timeslot.dart';

enum Month {
  january(1),
  february(2),
  march(3),
  april(4),
  may(5),
  june(6),
  july(7),
  august(8),
  september(9),
  october(10),
  november(11),
  december(12);

  final int monthNumber;
  const Month(this.monthNumber);

  /// Returns the nth day (default 1) of this month in the given [year].
  DateTime date({required int year}) {
    return DateTime(year, monthNumber, 1);
  }
}

enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class Schedule extends Equatable {
  /// The year of this schedule.
  final int year;

  /// The month of the year this schedule pertains to.
  final Month month;

  /// A list of schedule slots for this schedule. The list is private and should not be modified directly.
  final List<TimeSlot> _slots;

  /// Public getter for an unmodifiable view of the time slots.
  List<TimeSlot> get slots => List.unmodifiable(_slots);

  Schedule({required DateTime monthInput, List<TimeSlot>? initialSlots})
    : year = monthInput.year,
      month = Month.values.firstWhere((m) => m.monthNumber == monthInput.month),
      _slots = List.of(initialSlots ?? const []) {
    final DateTime startDate = month.date(year: year);
    // Calculate the start of the next month for an exclusive end
    final DateTime endDate =
        (month == Month.december)
            ? Month.january.date(year: year + 1) // Next year, January, 1st day
            : Month.values[month.index + 1].date(
              year: year,
            ); // Next month, 1st day

    for (final TimeSlot slot in _slots) {
      final bool slotIsValid =
          !slot.start.isBefore(startDate) && !slot.end.isAfter(endDate);
      assert(slotIsValid, '''
            TimeSlot must fall within the schedule's month ($year-${month.name}).
            \tProblematic slot: ${slot.toString()}
            \tslot start: ${slot.start}, slot end (exclusive): ${slot.end}
            \tSchedule period: [$startDate, $endDate)
      ''');
    }
  }

  /// Adds a TimeSlot to the schedule.
  ///
  /// Throws an [ArgumentError] if the [TimeSlot] does not fall within the schedule's month.
  void addSlot(TimeSlot slot) {
    final DateTime startDate = month.date(year: year);
    final DateTime endDate =
        (month == Month.december)
            ? Month.january.date(year: year + 1)
            : Month.values[month.index + 1].date(year: year);
    final bool slotIsValid =
        !slot.start.isBefore(startDate) && !slot.end.isAfter(endDate);
    if (!slotIsValid) {
      throw ArgumentError('''
          TimeSlot must fall within the schedule's month ($year-${month.name}).
          \tProblematic slot: ${slot.toString()}
          \tslot start: ${slot.start}, slot end (exclusive): ${slot.end}
          \tSchedule period: [$startDate, $endDate)
          ''');
    } else {
      // Check for overlapping time slots
      for (final TimeSlot existingSlot in _slots) {
        if (slot.overlaps(existingSlot)) {
          throw ArgumentError('''
              TimeSlot overlaps with an existing TimeSlot.
              \tNew slot: ${slot.toString()}
              \tExisting slot: ${existingSlot.toString()}
              ''');
        }
      }
    }
    _slots.add(slot);
  }

  /// Returns a new Schedule with updated monthInput and slots.
  Schedule copyWith({DateTime? monthInput, List<TimeSlot>? initialSlots}) {
    return Schedule(
      monthInput: monthInput ?? DateTime(year, month.monthNumber),
      initialSlots: initialSlots ?? _slots,
    );
  }

  /// Converts Schedule to a JSON-friendly map.
  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month.monthNumber,
    'slots': _slots.map((e) => e.toJson()).toList(),
  };

  /// Creates a Schedule from a JSON map.
  factory Schedule.fromJson(Map<String, dynamic> json) {
    final int yr = json['year'] as int;
    final int monthNum = json['month'] as int;
    final DateTime monthInput = DateTime(yr, monthNum);
    final slotsJson = json['slots'] as List<dynamic>;
    final slots =
        slotsJson
            .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
            .toList();
    return Schedule(monthInput: monthInput, initialSlots: slots);
  }

  static Schedule get empty {
    // Returns a schedule for the current month and year, with no slots.
    // You might want to adjust what "empty" means for your application,
    // e.g., a specific default date or an empty list of slots for a default/current month.
    final now = DateTime.now();
    return Schedule(
      monthInput: DateTime(now.year, now.month),
      initialSlots: const [],
    );
  }

  @override
  List<Object?> get props => [year, month, _slots];

  @override
  bool get stringify => true;
}
