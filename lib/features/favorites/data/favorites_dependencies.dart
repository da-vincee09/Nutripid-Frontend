import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/core/networks/network_providers.dart';
import 'package:meal_recommendation_app/features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'package:meal_recommendation_app/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:meal_recommendation_app/features/favorites/domain/repositories/favorites_repository.dart';

// Provides the favorites remote data source and supplies it with the configured Dio client.
final favoritesRemoteDatasourceProvider = Provider<FavoritesRemoteDatasource>((ref) {
  return FavoritesRemoteDatasourceImpl(dio: ref.watch(dioProvider));
});

// Provides the favorites repository and supplies it with the remote data source.
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(
    datasource: ref.watch(favoritesRemoteDatasourceProvider),
  );
});