import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_draft_model.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_request.dart';

abstract class WeeklyPlanRepository {
  Future<WeeklyPlanDraftModel> generate(WeeklyPlanGenerateRequest request);
  Future<WeeklyPlanAcceptResult> accept(WeeklyPlanAcceptRequest request);
}