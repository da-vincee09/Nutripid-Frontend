import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_create_request.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_model.dart';
import 'package:meal_recommendation_app/features/pantry/data/models/pantry_item_update_request.dart';

// Defines the required operations for accessing pantry items.
abstract class PantryRemoteDatasource {
  Future<PantryItemModel> createPantryItem(PantryItemCreateRequest request);
  Future<List<PantryItemModel>> getPantryItems();
  Future<PantryItemModel> getPantryItem(String id);
  Future<PantryItemModel> updatePantryItem(
    String id,
    PantryItemUpdateRequest request,
  );
  Future<void> deletePantryItem(String id);
}

// Implements pantry operations by communicating with the backend using Dio.
class PantryRemoteDatasourceImpl implements PantryRemoteDatasource {
  final Dio _dio;

  // Receives the configured Dio client through dependency injection.
  // ignore: prefer_initializing_formals
  PantryRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<PantryItemModel> createPantryItem(
    PantryItemCreateRequest request,
  ) async {
    // Sends a POST request with the new pantry item's data.
    final json = await _request<Map<String, dynamic>>(
      () => _dio.post(ApiConstants.pantry, data: request.toJson()),
    );

    // Converts the backend response into a pantry item model.
    return PantryItemModel.fromJson(json);
  }

  @override
  Future<List<PantryItemModel>> getPantryItems() async {
    // Retrieves all pantry items from the backend.
    final list = await _request<List<dynamic>>(
      () => _dio.get(ApiConstants.pantry),
    );

    // Converts each JSON item into a PantryItemModel.
    return list
        .map((e) => PantryItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PantryItemModel> getPantryItem(String id) async {
    // Retrieves one pantry item using its ID.
    final json = await _request<Map<String, dynamic>>(
      () => _dio.get('${ApiConstants.pantry}/$id'),
    );
    return PantryItemModel.fromJson(json);
  }

  @override
  Future<PantryItemModel> updatePantryItem(
    String id,
    PantryItemUpdateRequest request,
  ) async {
    // Sends a PUT request to update an existing pantry item.
    final json = await _request<Map<String, dynamic>>(
      () => _dio.put('${ApiConstants.pantry}/$id', data: request.toJson()),
    );
    return PantryItemModel.fromJson(json);
  }

  @override
  Future<void> deletePantryItem(String id) async {
    // Sends a DELETE request to remove a pantry item.
    try {
      await _dio.delete('${ApiConstants.pantry}/$id');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Reusable helper for sending requests and handling Dio exceptions.
  Future<T> _request<T>(Future<Response> Function() call) async {
    try {
      final response = await call();
      return response.data as T;
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

    // Handles network problems or requests without an HTTP response.
    if (isConnectivityIssue || e.response == null) {
      return const NetworkException();
    }

    final response = e.response!;
    final body = response.data;
    final detail = body is Map<String, dynamic> ? body['detail'] : null;

    // Maps HTTP status codes to specific application exceptions.
    switch (response.statusCode) {
      case 401:
        return UnauthorizedException(
          detail is String ? detail : const UnauthorizedException().message,
        );
      case 404:
        return PantryItemNotFoundException(
          detail is String
              ? detail
              : const PantryItemNotFoundException().message,
        );
      case 422:
        return ValidationException(detail is List ? detail : const []);
      default:
        final message = body is Map<String, dynamic> ? body['message'] : null;
        return ServerException(
          message is String ? message : const ServerException().message,
        );
    }
  }
}