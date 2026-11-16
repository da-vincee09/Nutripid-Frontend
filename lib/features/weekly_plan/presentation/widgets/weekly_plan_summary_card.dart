import 'package:flutter/material.dart';
import 'package:meal_recommendation_app/app/colors.dart';
import 'package:meal_recommendation_app/core/utils/currency_utils.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_draft_model.dart';

// Shows the plan's estimated cost against the user's budget.
class WeeklyPlanSummaryCard extends StatelessWidget {
  final WeeklyPlanDraftModel draft;

  const WeeklyPlanSummaryCard({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final savings = draft.estimatedSavings;
    final isUnder = savings >= 0;
    final accent = isUnder ? AppColors.olive : theme.colorScheme.error;

    final budget = draft.budgetTotal;
    final progress =
        budget <= 0 ? 0.0 : (draft.estimatedCostTotal / budget).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Figure(
                      icon: Icons.payments_outlined,
                      label: 'Estimated cost',
                      value: formatPeso(draft.estimatedCostTotal),
                      valueColor: AppColors.burntOrange,
                    ),
                  ),
                  Expanded(
                    child: _Figure(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Your budget',
                      value: formatPeso(draft.budgetTotal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: accent.withValues(alpha: 0.12),
                  color: accent,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isUnder
                          ? Icons.savings_outlined
                          : Icons.warning_amber_rounded,
                      size: 18,
                      color: accent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isUnder
                            ? 'About ${formatPeso(savings)} under your budget'
                            : 'About ${formatPeso(-savings)} over your budget',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _Figure({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.lightSecondaryText),
            const SizedBox(width: 5),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.lightSecondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}