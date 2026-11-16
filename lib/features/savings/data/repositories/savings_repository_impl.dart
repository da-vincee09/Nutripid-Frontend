import 'package:meal_recommendation_app/features/savings/data/datasources/savings_remote_datasource.dart';
import 'package:meal_recommendation_app/features/savings/data/models/savings_summary_model.dart';
import 'package:meal_recommendation_app/features/savings/domain/repositories/savings_repository.dart';

class SavingsRepositoryImpl implements SavingsRepository {
  final SavingsRemoteDatasource datasource;

  SavingsRepositoryImpl({required this.datasource});

  @override
  Future<SavingsSummaryModel> getSummary(SavingsPeriod period) {
    return datasource.getSummary(period);
  }
}