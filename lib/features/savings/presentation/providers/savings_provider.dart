import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/features/savings/data/models/savings_summary_model.dart';
import 'package:meal_recommendation_app/features/savings/data/savings_dependencies.dart';

// autoDispose: leaving the screen discards the loaded summary.
final savingsControllerProvider = NotifierProvider.autoDispose<
    SavingsController, AsyncValue<SavingsSummaryModel?>>(
  SavingsController.new,
);

class SavingsController extends Notifier<AsyncValue<SavingsSummaryModel?>> {
  @override
  AsyncValue<SavingsSummaryModel?> build() => const AsyncData(null);

  // Loads the summary for the chosen period.
  Future<void> load(SavingsPeriod period) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(savingsRepositoryProvider);
      final summary = await repository.getSummary(period);
      state = AsyncData(summary);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}