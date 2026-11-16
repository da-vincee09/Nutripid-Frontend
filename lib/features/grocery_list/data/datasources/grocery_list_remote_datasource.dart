import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/grocery_list/data/models/grocery_list_model.dart';

// Defines the contract for retrieving the grocery list from the remote API.
abstract class GroceryListRemoteDatasource {
  Future<GroceryListResponseModel> getGroceryList({
    DateTime? startDate,
    DateTime? endDate,
  });
}

// Handles grocery list API requests using Dio.
class GroceryListRemoteDatasourceImpl implements GroceryListRemoteDatasource {
  final Dio _dio;

  // Receives the configured Dio client through dependency injection.
  // ignore: prefer_initializing_formals
  GroceryListRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  // Fetches the grocery list, optionally filtered by a date range.
  @override
  Future<GroceryListResponseModel> getGroceryList({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.groceryList,
        queryParameters: {
          if (startDate != null) 'start_date': _formatDate(startDate),
          if (endDate != null) 'end_date': _formatDate(endDate),
        },
      );
      return GroceryListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
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
      case 401:
        return const UnauthorizedException();
      case 404:
        // The shared 404 response is currently handled as a server exception.
        return const ServerException();
      case 400:
        // Invalid date ranges currently fall back to a server exception.
        return const ServerException();
      case 422:
        final errors = e.response?.data?['detail'] as List<dynamic>? ?? [];
        return ValidationException(errors);
      default:
        return const ServerException();
    }
  }
}

// Converts a DateTime into the YYYY-MM-DD format expected by the API.
String _formatDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}