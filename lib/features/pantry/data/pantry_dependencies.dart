import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/core/networks/network_providers.dart';
import 'package:meal_recommendation_app/features/pantry/data/datasources/pantry_remote_datasource.dart';
import 'package:meal_recommendation_app/features/pantry/data/repositories/pantry_repository_impl.dart';
import 'package:meal_recommendation_app/features/pantry/domain/repositories/pantry_repository.dart';
import 'package:meal_recommendation_app/features/pantry/data/datasources/ingredient_suggestion_remote_datasource.dart';

// Provides the pantry remote datasource and injects the configured Dio client.
final pantryRemoteDatasourceProvider = Provider<PantryRemoteDatasource>((ref) {
  return PantryRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
  );
});

// Provides the pantry repository and injects the pantry remote datasource.
final pantryRepositoryProvider = Provider<PantryRepository>((ref) {
  return PantryRepositoryImpl(
    datasource: ref.watch(pantryRemoteDatasourceProvider),
  );
});

// Provides the ingredient suggestion datasource with the configured Dio client.
final ingredientSuggestionDatasourceProvider =
    Provider<IngredientSuggestionRemoteDatasource>((ref) {
  return IngredientSuggestionRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
  );
});

// Retrieves available measurement units from the backend.
final allUnitsProvider = FutureProvider<List<String>>((ref) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get(ApiConstants.mealUnits);

    // Converts the backend response into a list of strings.
    return (response.data as List<dynamic>).cast<String>();
  } catch (_) {
    // Uses default units if the non-critical lookup fails.
    return const ['g', 'kg', 'ml', 'l', 'pcs', 'cup', 'tbsp', 'tsp'];
  }
});