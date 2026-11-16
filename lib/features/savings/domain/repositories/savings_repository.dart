import 'package:meal_recommendation_app/features/savings/data/models/savings_summary_model.dart';

// Defines the contract for all Savings data operations.
abstract class SavingsRepository {
  Future<SavingsSummaryModel> getSummary(SavingsPeriod period);
}