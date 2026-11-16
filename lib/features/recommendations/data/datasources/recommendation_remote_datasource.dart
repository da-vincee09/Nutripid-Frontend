import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/recommendations/data/models/recommendation_model.dart';

// Defines the contract for fetching meal recommendations.
abstract class RecommendationsRemoteDatasource {
  // Retrieves recommendations sorted by the specified field.
  Future<List<RecommendationModel>> getRecommendations({String sortBy = 'score'});
}

// Implements the recommendations remote datasource using Dio.
class RecommendationsRemoteDatasourceImpl implements RecommendationsRemoteDatasource {
  // Dio instance used to make HTTP requests.
  final Dio _dio;

  // Initializes the datasource with the required Dio instance.
  // ignore: prefer_initializing_formals
  RecommendationsRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  // Fetches meal recommendations from the API.
  @override
  Future<List<RecommendationModel>> getRecommendations({String sortBy = 'score'}) async {
    try {
      // Sends a GET request with the sorting parameter.
      final response = await _dio.get(
        ApiConstants.recommendations,
        queryParameters: {'sort_by': sortBy},
      );

      // Extracts the recommendations list from the API response.
      final recsJson = response.data['recommendations'] as List<dynamic>;
      
      // Converts the JSON data into RecommendationModel objects.
      return recsJson
          .map((e) => RecommendationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // Converts Dio errors into custom application exceptions.
      throw _mapDioException(e);
    }
  }

  // Maps Dio exceptions to the corresponding custom API exceptions.
  ApiException _mapDioException(DioException e) {
    // Checks whether the error was caused by a connectivity issue.
    final isConnectivityIssue = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        true,
      _ => false,
    };

    // Returns a network exception for connection-related errors.
    if (isConnectivityIssue || e.response == null) {
      return const NetworkException();
    }

    // Retrieves the HTTP status code from the response.
    final statusCode = e.response?.statusCode;

    // Maps HTTP status codes to their corresponding exceptions.
    switch (statusCode) {
      case 401:
        return const UnauthorizedException();
      case 422:
        // Extracts validation errors from the API response.
        final errors = e.response?.data?['detail'] as List<dynamic>? ?? [];
        return ValidationException(errors);
      default:
        // Returns a server exception for other HTTP errors.
        return const ServerException();
    }
  }
}