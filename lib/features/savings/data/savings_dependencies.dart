import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/core/networks/network_providers.dart';
import 'package:meal_recommendation_app/features/savings/data/datasources/savings_remote_datasource.dart';
import 'package:meal_recommendation_app/features/savings/data/repositories/savings_repository_impl.dart';
import 'package:meal_recommendation_app/features/savings/domain/repositories/savings_repository.dart';

final savingsRemoteDatasourceProvider =
    Provider<SavingsRemoteDatasource>((ref) {
  return SavingsRemoteDatasourceImpl(dio: ref.watch(dioProvider));
});

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return SavingsRepositoryImpl(
    datasource: ref.watch(savingsRemoteDatasourceProvider),
  );
});