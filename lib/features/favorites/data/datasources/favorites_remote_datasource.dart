import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/favorites/data/models/favorite_model.dart';

// Defines the contract for favorite-related operations.
abstract class FavoritesRemoteDatasource {
  Future<FavoriteModel> addFavorite(String mealId);
  Future<List<FavoriteModel>> getFavorites();
  Future<void> removeFavorite(String mealId);
}

// Implements favorite operations by communicating with the backend API using Dio.
class FavoritesRemoteDatasourceImpl implements FavoritesRemoteDatasource {
  // Holds the Dio client used to send HTTP requests.
  final Dio _dio;

  // Receives the Dio client through dependency injection.
  // ignore: prefer_initializing_formals
  FavoritesRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  // Sends a request to add a meal to the user's favorites.
  @override
  Future<FavoriteModel> addFavorite(String mealId) async {
    try {
      final response = await _dio.post(
        ApiConstants.favorites,
        data: {'meal_id': mealId},
      );
      return FavoriteModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Retrieves the user's favorite meals from the backend.
  @override
  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final response = await _dio.get(ApiConstants.favorites);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => FavoriteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Sends a request to remove a meal from the user's favorites.
  @override
  Future<void> removeFavorite(String mealId) async {
    try {
      await _dio.delete(ApiConstants.favoriteDetail(mealId));
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Converts Dio errors into application-specific API exceptions.
  ApiException _mapDioException(DioException e) {
    final isConnectivityIssue = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        true,
      _ => false,
    };

    // Treats connection problems or missing responses as network errors.
    if (isConnectivityIssue || e.response == null) {
      return const NetworkException();
    }

    // Maps HTTP status codes to the appropriate application exception.
    switch (e.response?.statusCode) {
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