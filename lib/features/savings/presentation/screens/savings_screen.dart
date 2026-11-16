import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/app/colors.dart';
import 'package:meal_recommendation_app/core/utils/currency_utils.dart';
import 'package:meal_recommendation_app/features/savings/data/models/savings_summary_model.dart';
import 'package:meal_recommendation_app/features/savings/presentation/providers/savings_provider.dart';
import 'package:meal_recommendation_app/features/savings/presentation/widgets/savings_daily_list.dart';
import 'package:meal_recommendation_app/features/savings/presentation/widgets/savings_verdict_card.dart';

class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});

  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> {
  SavingsPeriod _period = SavingsPeriod.week;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() {
    return ref.read(savingsControllerProvider.notifier).load(_period);
  }

  void _changePeriod(SavingsPeriod period) {
    if (period == _period) return;
    setState(() => _period = period);
    _load();
  }

  String get _periodLabel => _period == SavingsPeriod.week ? 'week' : 'month';

  String _rangeLabel(DateTime a, DateTime b) =>
      '${_months[a.month - 1]} ${a.day} to ${_months[b.month - 1]} ${b.day}';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(savingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Can I Save?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _PeriodTabs(selected: _period, onChanged: _changePeriod),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.burntOrange),
              ),
              error: (error, _) => _Message(
                icon: Icons.error_outline,
                text: error.toString(),
                onRetry: _load,
              ),
              data: (summary) {
                if (summary == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.burntOrange,
                    ),
                  );
                }
                if (!summary.hasPlannedMeals) {
                  return const _Message(
                    icon: Icons.event_note_outlined,
                    text: 'No planned meals in this period yet.\n'
                        'Add meals to your planner to see how much you can '
                        'save.',
                  );
                }
                return RefreshIndicator(
                  color: AppColors.burntOrange,
                  onRefresh: _load,
                  child: _buildContent(summary),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(SavingsSummaryModel summary) {
    final theme = Theme.of(context);
    // Keeps the last items clear of the phone's navigation bar.
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24 + bottomInset),
      children: [
        Text(
          _rangeLabel(summary.startDate, summary.endDate),
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        SavingsVerdictCard(summary: summary, periodLabel: _periodLabel),
        if (summary.projection != null) ...[
          const SizedBox(height: 12),
          _ProjectionCard(
            projection: summary.projection!,
            periodLabel: _periodLabel,
          ),
        ],
        const SizedBox(height: 28),
        Text('Day by day', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        SavingsDailyList(days: summary.daily),
        const SizedBox(height: 16),
        Text(
          'Based on your planned meals and the estimated cost of each '
          'meal. Actual prices may differ.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

// Two text tabs with an underline indicator.
class _PeriodTabs extends StatelessWidget {
  final SavingsPeriod selected;
  final ValueChanged<SavingsPeriod> onChanged;

  const _PeriodTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Divider(height: 1),
        ),
        Row(
          children: [
            _tab(context, 'This week', SavingsPeriod.week),
            _tab(context, 'This month', SavingsPeriod.month),
          ],
        ),
      ],
    );
  }

  Widget _tab(BuildContext context, String label, SavingsPeriod value) {
    final theme = Theme.of(context);
    final isSelected = selected == value;

    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.burntOrange : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? AppColors.burntOrange
                  : theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectionCard extends StatelessWidget {
  final SavingsProjectionModel projection;
  final String periodLabel;

  const _ProjectionCard({
    required this.projection,
    required this.periodLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final positive = projection.projectedSavings >= 0;
    final accent = positive ? AppColors.green : AppColors.burntOrange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full $periodLabel estimate',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      positive
                          ? '${formatPeso(projection.projectedSavings)} saved'
                          : '${formatPeso(-projection.projectedSavings)} over',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'If you plan all ${projection.meals} meals '
                      '(${projection.days} days) like this',
                      style: theme.textTheme.bodySmall,
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

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  const _Message({required this.icon, required this.text, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: theme.textTheme.bodySmall?.color),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}