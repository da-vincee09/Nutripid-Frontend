import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/core/networks/network_providers.dart';
import 'package:meal_recommendation_app/features/recommendations/data/datasources/recommendation_remote_datasource.dart';
import 'package:meal_recommendation_app/features/recommendations/data/repositories/recommendation_repository_impl.dart';
import 'package:meal_recommendation_app/features/recommendations/domain/repositories/recommendation_repository.dart';

// Provides the recommendations remote datasource instance.
final recommendationsRemoteDatasourceProvider =
    Provider<RecommendationsRemoteDatasource>((ref) {
  // Creates the datasource using the Dio network client.
  return RecommendationsRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
  );
});

// Provides the recommendation repository instance.
final recommendationRepositoryProvider = Provider<RecommendationRepository>((ref) {
  // Creates the repository using the remote datasource provider.
  return RecommendationRepositoryImpl(
    datasource: ref.watch(recommendationsRemoteDatasourceProvider),
  );
});