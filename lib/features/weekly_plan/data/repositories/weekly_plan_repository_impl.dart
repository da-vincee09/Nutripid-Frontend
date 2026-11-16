import 'package:meal_recommendation_app/features/weekly_plan/data/datasources/weekly_plan_remote_datasource.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_draft_model.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_request.dart';
import 'package:meal_recommendation_app/features/weekly_plan/domain/repositories/weekly_plan_repository.dart';

class WeeklyPlanRepositoryImpl implements WeeklyPlanRepository {
  final WeeklyPlanRemoteDatasource datasource;

  WeeklyPlanRepositoryImpl({required this.datasource});

  @override
  Future<WeeklyPlanDraftModel> generate(WeeklyPlanGenerateRequest request) {
    return datasource.generate(request);
  }

  @override
  Future<WeeklyPlanAcceptResult> accept(WeeklyPlanAcceptRequest request) {
    return datasource.accept(request);
  }
}