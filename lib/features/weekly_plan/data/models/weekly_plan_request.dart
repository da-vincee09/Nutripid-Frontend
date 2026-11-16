import 'package:meal_recommendation_app/core/utils/date_utils.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_request.dart';

// Asks the backend to generate a draft plan.
class WeeklyPlanGenerateRequest {
  final DateTime startDate;
  final int days;
  final int? seed;

  const WeeklyPlanGenerateRequest({
    required this.startDate,
    required this.days,
    this.seed,
  });

  Map<String, dynamic> toJson() {
    return {
      'start_date': formatDate(startDate),
      'days': days,
      if (seed != null) 'seed': seed,
    };
  }
}

// Saves the accepted draft into the meal planner.
class WeeklyPlanAcceptRequest {
  final List<MealPlanEntryCreateRequest> entries;
  final bool replaceExisting;

  const WeeklyPlanAcceptRequest({
    required this.entries,
    this.replaceExisting = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'entries': entries.map((e) => e.toJson()).toList(),
      'replace_existing': replaceExisting,
    };
  }
}

class WeeklyPlanAcceptResult {
  final int savedCount;
  final int skippedCount;

  const WeeklyPlanAcceptResult({
    required this.savedCount,
    required this.skippedCount,
  });

  factory WeeklyPlanAcceptResult.fromJson(Map<String, dynamic> json) {
    return WeeklyPlanAcceptResult(
      savedCount: json['saved_count'] as int,
      skippedCount: json['skipped_count'] as int,
    );
  }
}