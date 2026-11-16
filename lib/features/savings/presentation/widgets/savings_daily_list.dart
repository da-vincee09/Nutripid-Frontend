import 'package:flutter/material.dart';
import 'package:meal_recommendation_app/app/colors.dart';
import 'package:meal_recommendation_app/core/utils/currency_utils.dart';
import 'package:meal_recommendation_app/features/savings/data/models/savings_summary_model.dart';

// One row per day showing meals planned and the amount saved or overspent.
class SavingsDailyList extends StatelessWidget {
  final List<DailySavingsModel> days;

  const SavingsDailyList({super.key, required this.days});

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            for (var i = 0; i < days.length; i++) ...[
              _DayRow(day: days[i]),
              if (i != days.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  final DailySavingsModel day;

  const _DayRow({required this.day});

  bool get _isToday {
    final now = DateTime.now();
    return day.date.year == now.year &&
        day.date.month == now.month &&
        day.date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMeals = day.plannedMeals > 0;
    final highlight = _isToday ? AppColors.burntOrange : null;

    final amountColor =
        day.savings >= 0 ? AppColors.green : AppColors.burntOrange;
    final amountText = day.savings >= 0
        ? '+${formatPeso(day.savings)}'
        : '-${formatPeso(-day.savings)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Status bar: green if saved, orange if over, hidden on empty days.
          Container(
            width: 3,
            height: 36,
            decoration: BoxDecoration(
              color: hasMeals ? amountColor : Colors.transparent,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SavingsDailyList._weekdays[day.date.weekday - 1],
                  style: theme.textTheme.bodySmall?.copyWith(color: highlight),
                ),
                Text(
                  '${day.date.day}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: highlight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: hasMeals
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${day.plannedMeals} '
                        '${day.plannedMeals == 1 ? 'meal' : 'meals'} planned',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Cost ${formatPeso(day.estimatedCost)} '
                        'of ${formatPeso(day.budget)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  )
                : Text('No meals planned', style: theme.textTheme.bodySmall),
          ),
          if (hasMeals)
            Text(
              amountText,
              style: theme.textTheme.titleSmall?.copyWith(color: amountColor),
            ),
        ],
      ),
    );
  }
}