import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/core/networks/network_providers.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/datasources/weekly_plan_remote_datasource.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/repositories/weekly_plan_repository_impl.dart';
import 'package:meal_recommendation_app/features/weekly_plan/domain/repositories/weekly_plan_repository.dart';

final weeklyPlanRemoteDatasourceProvider =
    Provider<WeeklyPlanRemoteDatasource>((ref) {
  return WeeklyPlanRemoteDatasourceImpl(dio: ref.watch(dioProvider));
});

final weeklyPlanRepositoryProvider = Provider<WeeklyPlanRepository>((ref) {
  return WeeklyPlanRepositoryImpl(
    datasource: ref.watch(weeklyPlanRemoteDatasourceProvider),
  );
});