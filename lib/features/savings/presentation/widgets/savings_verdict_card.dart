import 'package:flutter/material.dart';
import 'package:meal_recommendation_app/app/colors.dart';
import 'package:meal_recommendation_app/core/utils/currency_utils.dart';
import 'package:meal_recommendation_app/features/savings/data/models/savings_summary_model.dart';

// Hero card: the verdict, the amount saved, and cost vs budget.
class SavingsVerdictCard extends StatelessWidget {
  final SavingsSummaryModel summary;
  final String periodLabel;

  const SavingsVerdictCard({
    super.key,
    required this.summary,
    required this.periodLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color accent;
    final String title;
    final String caption;

    switch (summary.verdict) {
      case SavingsVerdict.saving:
        accent = AppColors.green;
        title = 'Yes, you can save!';
        caption = 'saved this $periodLabel';
      case SavingsVerdict.onBudget:
        accent = AppColors.burntOrange;
        title = 'Right on budget';
        caption = 'difference from your budget';
      case SavingsVerdict.overBudget:
        accent = AppColors.burntOrange;
        title = 'Over budget';
        caption = 'over your budget this $periodLabel';
    }

    final spent = summary.budgetTotal <= 0
        ? 0.0
        : summary.estimatedCostTotal / summary.budgetTotal;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(color: accent),
            ),
            const SizedBox(height: 12),
            Text(
              formatPeso(summary.totalSavings.abs()),
              style: theme.textTheme.displaySmall?.copyWith(color: accent),
            ),
            const SizedBox(height: 4),
            Text(caption, style: theme.textTheme.bodySmall),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: spent.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: theme.dividerColor,
                color: accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Spent ${(spent * 100).toStringAsFixed(0)}% of your budget',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                _Stat(
                  label: 'Estimated cost',
                  value: formatPeso(summary.estimatedCostTotal),
                ),
                _Stat(
                  label: 'Your budget',
                  value: formatPeso(summary.budgetTotal),
                ),
                _Stat(label: 'Meals', value: '${summary.plannedMeals}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}