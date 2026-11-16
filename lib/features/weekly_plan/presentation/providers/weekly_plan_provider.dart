import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_request.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_draft_model.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_request.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/weekly_plan_dependencies.dart';

// autoDispose: leaving the screen discards the unsaved draft.
final weeklyPlanControllerProvider = NotifierProvider.autoDispose<
    WeeklyPlanController, AsyncValue<WeeklyPlanDraftModel?>>(
  WeeklyPlanController.new,
);

class WeeklyPlanController
    extends Notifier<AsyncValue<WeeklyPlanDraftModel?>> {
  @override
  AsyncValue<WeeklyPlanDraftModel?> build() => const AsyncData(null);

  // Asks the backend for a fresh draft (also used for "Regenerate").
  Future<void> generate({
    required DateTime startDate,
    required int days,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(weeklyPlanRepositoryProvider);
      final draft = await repository.generate(
        WeeklyPlanGenerateRequest(startDate: startDate, days: days),
      );
      state = AsyncData(draft);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Replaces one slot's meal with a chosen alternative (local only).
  void swapSlot(int index, AlternativeMealModel alternative) {
    final draft = state.value;
    if (draft == null) return;
    state = AsyncData(draft.withSwap(index, alternative));
  }

  // Saves the draft into the meal planner.
  Future<WeeklyPlanAcceptResult> accept({bool replaceExisting = false}) async {
    final draft = state.value;
    if (draft == null) {
      throw StateError('No draft plan to accept.');
    }

    final repository = ref.read(weeklyPlanRepositoryProvider);
    return repository.accept(
      WeeklyPlanAcceptRequest(
        entries: draft.slots
            .map(
              (slot) => MealPlanEntryCreateRequest(
                mealId: slot.meal.id,
                plannedDate: slot.plannedDate,
                mealSlot: slot.mealSlot,
              ),
            )
            .toList(),
        replaceExisting: replaceExisting,
      ),
    );
  }
}