import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_model.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_request.dart';

// Defines the required operations for communicating with the meal planner API.
abstract class MealPlannerRemoteDatasource {
  Future<MealPlanEntryModel> createMealPlanEntry(MealPlanEntryCreateRequest request);
  Future<WeeklyPlanModel> getMealPlan({required DateTime startDate, required DateTime endDate});
  Future<MealPlanEntryModel> getMealPlanEntry(String id);
  Future<MealPlanEntryModel> updateMealPlanEntry(String id, MealPlanEntryUpdateRequest request);
  Future<void> deleteMealPlanEntry(String id);
}

// Implements meal planner API operations using Dio.
class MealPlannerRemoteDatasourceImpl implements MealPlannerRemoteDatasource {
  final Dio _dio;

  // Receives the configured Dio client through dependency injection.
  // ignore: prefer_initializing_formals
  MealPlannerRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  // Creates a meal plan entry by sending its request data to the backend.
  @override
  Future<MealPlanEntryModel> createMealPlanEntry(
    MealPlanEntryCreateRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.mealPlanner,
        data: request.toJson(),
      );
      return MealPlanEntryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Retrieves a weekly meal plan within the specified date range.
  @override
  Future<WeeklyPlanModel> getMealPlan({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.mealPlanner,
        queryParameters: {
          'start_date': _formatDate(startDate),
          'end_date': _formatDate(endDate),
        },
      );
      return WeeklyPlanModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Retrieves one meal plan entry using its ID.
  @override
  Future<MealPlanEntryModel> getMealPlanEntry(String id) async {
    try {
      final response = await _dio.get(ApiConstants.mealPlanEntryDetail(id));
      return MealPlanEntryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Updates an existing meal plan entry using its ID and new request data.
  @override
  Future<MealPlanEntryModel> updateMealPlanEntry(
    String id,
    MealPlanEntryUpdateRequest request,
  ) async {
    try {
      final response = await _dio.put(
        ApiConstants.mealPlanEntryDetail(id),
        data: request.toJson(),
      );
      return MealPlanEntryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Deletes a meal plan entry using its ID.
  @override
  Future<void> deleteMealPlanEntry(String id) async {
    try {
      await _dio.delete(ApiConstants.mealPlanEntryDetail(id));
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Converts Dio errors into the application's custom API exceptions.
  ApiException _mapDioException(DioException e) {
    final isConnectivityIssue = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        true,
      _ => false,
    };

    if (isConnectivityIssue || e.response == null) {
      return const NetworkException();
    }

    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case 400:
        final detail = e.response?.data?['detail'];
        return BadRequestException(
          detail is String ? detail: 'That request could not be completed.',
        );
      case 401:
        return const UnauthorizedException();
      case 404:
        // The backend uses 404 for both missing profiles and missing entries.
        // These are currently handled as a general server exception.
        return const ServerException();
      case 422:
        final errors = e.response?.data?['detail'] as List<dynamic>? ?? [];
        return ValidationException(errors);
      default:
        return const ServerException();
    }
  }
}

// Converts a DateTime into the YYYY-MM-DD format expected by the backend.
String _formatDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}