import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/meals/data/models/meal_model.dart';
import 'package:meal_recommendation_app/features/nutrition/data/models/nutrition_adequacy_model.dart';

// Defines the operations for retrieving meal and nutrition data from the API.
abstract class MealsRemoteDatasource {
  Future<List<MealModel>> getMeals();
  Future<MealModel> getMeal(String id);
  Future<NutritionAdequacyModel> getNutritionAdequacy(String mealId);
}

// Implements the datasource contract using Dio for HTTP requests.
class MealsRemoteDatasourceImpl implements MealsRemoteDatasource {
  final Dio _dio;

  // Receives the configured Dio client through dependency injection.
  // ignore: prefer_initializing_formals
  MealsRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  // Retrieves all meals and converts the API response into MealModel objects.
  @override
  Future<List<MealModel>> getMeals() async {
    try {
      final response = await _dio.get(ApiConstants.meals);
      final mealsJson = response.data['meals'] as List<dynamic>;
      return mealsJson
          .map((e) => MealModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Retrieves one meal using its ID and converts the response into a MealModel.
  @override
  Future<MealModel> getMeal(String id) async {
    try {
      final response = await _dio.get(ApiConstants.mealDetail(id));
      return MealModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // Handles a missing meal separately from other API errors.
      if (e.response?.statusCode == 404) {
        throw MealNotFoundException();
      }
      throw _mapDioException(e);
    }
  }

  // Retrieves the nutrition adequacy information for a specific meal.
  @override
  Future<NutritionAdequacyModel> getNutritionAdequacy(String mealId) async {
    try {
      final response =
          await _dio.get(ApiConstants.mealNutritionAdequacy(mealId));
      return NutritionAdequacyModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      // Handles a missing meal separately from other API errors.
      if (e.response?.statusCode == 404) {
        throw MealNotFoundException();
      }
      throw _mapDioException(e);
    }
  }

  // Converts Dio errors into the app's custom API exception types.
  ApiException _mapDioException(DioException e) {
    final isConnectivityIssue = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        true,
      _ => false,
    };

    // Treats connection problems and missing responses as network errors.
    if (isConnectivityIssue || e.response == null) {
      return const NetworkException();
    }

    final statusCode = e.response?.statusCode;

    // Converts HTTP status codes into appropriate custom exceptions.
    switch (statusCode) {
      case 401:
        return const UnauthorizedException();
      case 422:
        final errors = e.response?.data?['detail'] as List<dynamic>? ?? [];
        return ValidationException(errors);
      default:
        return const ServerException();
    }
  }
}