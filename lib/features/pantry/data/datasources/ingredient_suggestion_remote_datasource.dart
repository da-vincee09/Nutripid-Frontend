import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/ingredient_suggestion_model.dart';

// Defines the contract for searching ingredient suggestions.
abstract class IngredientSuggestionRemoteDatasource {
  Future<List<IngredientSuggestionModel>> search(String query);
}

// Implements the ingredient suggestion datasource using Dio.
class IngredientSuggestionRemoteDatasourceImpl implements IngredientSuggestionRemoteDatasource {
  final Dio _dio;

  // Receives the configured Dio client through dependency injection.
  // ignore: prefer_initializing_formals
  IngredientSuggestionRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<IngredientSuggestionModel>> search(String query) async {
    // Returns an empty list if the search input contains only whitespace.
    if (query.trim().isEmpty) return [];

    try {
      // Sends a GET request to retrieve matching ingredient suggestions.
      final response = await _dio.get(
        '${ApiConstants.meals}/ingredients/suggestions',
        queryParameters: {'search': query.trim()},
      );

      // Converts the JSON response into a list of ingredient suggestion models.
      return (response.data as List<dynamic>)
          .map((e) =>
              IngredientSuggestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // Treats connection errors as non-critical and returns no suggestions.
      if (e.type == DioExceptionType.connectionError) {
        return [];
      }

      // Converts other Dio errors into the application's custom exceptions.
      throw _mapDioException(e);
    }
  }

  // Maps Dio errors into custom API exceptions.
  ApiException _mapDioException(DioException e) {
    final isConnectivityIssue = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        true,
      _ => false,
    };

    // Returns a network exception for connectivity issues or missing responses.
    if (isConnectivityIssue || e.response == null) {
      return const NetworkException();
    }

    // Treats other HTTP response errors as server exceptions.
    return const ServerException();
  }
}