import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/app/colors.dart';
import 'package:meal_recommendation_app/core/extensions/context_extension.dart';
import 'package:meal_recommendation_app/core/widgets/confirm_dialog.dart';
import 'package:meal_recommendation_app/features/meal_planner/presentation/widgets/day_stab_strip.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_draft_model.dart';
import 'package:meal_recommendation_app/features/weekly_plan/presentation/providers/weekly_plan_provider.dart';
import 'package:meal_recommendation_app/features/weekly_plan/presentation/widgets/swap_meal_sheet.dart';
import 'package:meal_recommendation_app/features/weekly_plan/presentation/widgets/weekly_plan_loading_state.dart';
import 'package:meal_recommendation_app/features/weekly_plan/presentation/widgets/weekly_plan_slot_card.dart';
import 'package:meal_recommendation_app/features/weekly_plan/presentation/widgets/weekly_plan_summary_card.dart';

class WeeklyPlanDraftScreen extends ConsumerStatefulWidget {
  // Monday of the week shown in the meal planner.
  final DateTime weekStart;

  const WeeklyPlanDraftScreen({super.key, required this.weekStart});

  @override
  ConsumerState<WeeklyPlanDraftScreen> createState() =>
      _WeeklyPlanDraftScreenState();
}

class _WeeklyPlanDraftScreenState extends ConsumerState<WeeklyPlanDraftScreen> {
  static const _slotOrder = ['breakfast', 'lunch', 'dinner'];
  static const _slotLabels = {
    'breakfast': 'Breakfast',
    'lunch': 'Lunch',
    'dinner': 'Dinner',
  };
  static const _slotIcons = {
    'breakfast': Icons.free_breakfast_outlined,
    'lunch': Icons.lunch_dining_outlined,
    'dinner': Icons.dinner_dining_outlined,
  };

  late DateTime _firstDay;
  late int _days;
  late DateTime _selectedDay;
  bool _isAccepting = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = DateTime(
      widget.weekStart.year,
      widget.weekStart.month,
      widget.weekStart.day,
    );
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Plan from today onward within the viewed week (past slots are
    // skipped by the backend anyway).
    _firstDay = weekStart.isBefore(today) ? today : weekStart;
    _days = weekEnd.difference(_firstDay).inDays + 1;
    _selectedDay = _firstDay;

    if (_days >= 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _generate());
    }
  }

  void _generate() {
    ref.read(weeklyPlanControllerProvider.notifier).generate(
          startDate: _firstDay,
          days: _days,
        );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _swap(WeeklyPlanDraftModel draft, PlannedSlotModel slot) async {
    final chosen = await showSwapMealSheet(
      context,
      alternatives: draft.alternatives,
      currentMealId: slot.meal.id,
    );
    if (chosen == null) return;

    final index = draft.slots.indexOf(slot);
    if (index < 0) return;

    ref.read(weeklyPlanControllerProvider.notifier).swapSlot(index, chosen);
  }

  Future<void> _accept() async {
    setState(() => _isAccepting = true);
    final controller = ref.read(weeklyPlanControllerProvider.notifier);

    try {
      var result = await controller.accept();
      var anySaved = result.savedCount > 0;

      // Some slots already had the user's own meals: ask before replacing.
      if (result.skippedCount > 0 && mounted) {
        final replace = await showConfirmDialog(
          context,
          title: 'Replace existing meals?',
          message:
              '${result.skippedCount} slot(s) already have a meal in your '
              'planner. Replace them with the suggested ones?',
        );

        if (replace == true) {
          result = await controller.accept(replaceExisting: true);
          anySaved = anySaved || result.savedCount > 0;
        }
      }

      if (!mounted) return;

      if (anySaved) {
        Navigator.of(context).pop(true);
      } else {
        context.showSuccessSnackBar('Kept your existing meals');
        Navigator.of(context).pop(false);
      }
    } catch (e) {
      if (mounted) context.showErrorSnackBar('$e');
    } finally {
      if (mounted) setState(() => _isAccepting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weeklyPlanControllerProvider);
    final draft = state.value;
    final isBusy = state.isLoading || _isAccepting;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suggested Week Plan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: _days < 1
          ? const _Message(
              icon: Icons.event_busy_outlined,
              text: 'This week has already passed. Pick the current or a '
                  'future week to get a suggested plan.',
            )
          : state.when(
              loading: () => const WeeklyPlanLoadingState(),
              error: (error, _) => _Message(
                icon: Icons.error_outline,
                text: error.toString(),
                onRetry: _generate,
              ),
              data: (draft) {
                if (draft == null) return const WeeklyPlanLoadingState();
                return _buildDraft(draft);
              },
            ),
      bottomNavigationBar:
          _days < 1 ? null : _buildBottomBar(isBusy: isBusy, hasDraft: draft != null),
    );
  }

  Widget _buildBottomBar({required bool isBusy, required bool hasDraft}) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isBusy ? null : _generate,
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                ),
                icon: const Icon(Icons.shuffle, size: 18),
                label: const Text(
                  'Shuffle',
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: (isBusy || !hasDraft) ? null : _accept,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isAccepting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Accept Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraft(WeeklyPlanDraftModel draft) {
    final days = List.generate(
      _days,
      (i) => _firstDay.add(Duration(days: i)),
    );

    return Column(
      children: [
        WeeklyPlanSummaryCard(draft: draft),
        DayTabStrip(
          days: days,
          selectedDay: _selectedDay,
          daysWithEntries: draft.slotsByDay.keys.toSet(),
          onDaySelected: (day) => setState(() => _selectedDay = day),
        ),
        const SizedBox(height: 4),
        Expanded(child: _buildSlotsList(draft)),
      ],
    );
  }

  Widget _buildSlotsList(WeeklyPlanDraftModel draft) {
    final slotsForDay = draft.slots
        .where((s) => _isSameDay(s.plannedDate, _selectedDay))
        .toList()
      ..sort(
        (a, b) => _slotOrder
            .indexOf(a.mealSlot)
            .compareTo(_slotOrder.indexOf(b.mealSlot)),
      );

    if (slotsForDay.isEmpty) {
      return const _Message(
        icon: Icons.event_note_outlined,
        text: 'No meals suggested for this day.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        for (final slot in slotsForDay) ...[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 10),
            child: Row(
              children: [
                Icon(
                  _slotIcons[slot.mealSlot] ?? Icons.restaurant_outlined,
                  size: 18,
                  color: AppColors.burntOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  _slotLabels[slot.mealSlot] ?? slot.mealSlot,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          WeeklyPlanSlotCard(
            slot: slot,
            onSwap: () => _swap(draft, slot),
          ),
        ],
      ],
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
            Icon(icon, size: 48, color: theme.colorScheme.secondary),
            const SizedBox(height: 16),
            Text(text, textAlign: TextAlign.center),
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