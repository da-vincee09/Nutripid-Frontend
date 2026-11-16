import 'package:flutter/material.dart';

// Displays a horizontally scrollable strip of days for the meal planner.
class DayTabStrip extends StatelessWidget {
  // The list of dates displayed in the tab strip.
  final List<DateTime> days;

  // The currently selected date.
  final DateTime selectedDay;

  // The dates that have at least one scheduled meal.
  final Set<DateTime> daysWithEntries;

  // Callback that notifies the parent when a day is selected.
  final ValueChanged<DateTime> onDaySelected;

  
  const DayTabStrip({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.daysWithEntries,
    required this.onDaySelected,
  });

  // Weekday labels arranged from Monday to Sunday.
  static const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Checks whether two DateTime values represent the same calendar day.
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    // Gets the application's current theme for consistent styling.
    final theme = Theme.of(context);

    return SizedBox(
      height: 72,
      child: ListView.separated(
        // Arranges the day tabs horizontally.
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,

        // Adds spacing between each day tab.
        // ignore: unnecessary_underscores
        separatorBuilder: (_, __) => const SizedBox(width: 8),

        // Builds an individual tab for each date.
        itemBuilder: (context, index) {
          final day = days[index];

          // Determines whether this date is currently selected.
          final isSelected = _isSameDay(day, selectedDay);

          // Checks whether this date has at least one scheduled meal.
          final hasEntries = daysWithEntries.any((d) => _isSameDay(d, day));

          return GestureDetector(
            // Notifies the parent when the user taps a day.
            onTap: () => onDaySelected(day),
            child: Container(
              width: 52,
              decoration: BoxDecoration(
                // Uses the primary color for the selected day.
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Displays the abbreviated weekday name.
                  Text(
                    _weekdayLabels[day.weekday - 1],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Displays the numerical day of the month.
                  Text(
                    day.day.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Displays a small indicator when the date has scheduled meals.
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasEntries
                          ? (isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.primary)
                          : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}