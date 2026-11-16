import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/core/networks/network_providers.dart';
import 'package:meal_recommendation_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:meal_recommendation_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:meal_recommendation_app/features/profile/domain/repositories/profile_repository.dart';

// Provides the profile remote datasource instance.
final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((ref) {
  // Creates the datasource using the Dio network client.
  return ProfileRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
  );
});

// Provides the profile repository instance.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  // Creates the repository using the remote datasource provider.
  return ProfileRepositoryImpl(
    datasource: ref.watch(profileRemoteDatasourceProvider),
  );
});