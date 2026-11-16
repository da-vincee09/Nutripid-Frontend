import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/core/networks/auth_interceptor.dart';

// Centralizes HTTP client configuration for backend communication
class DioClient {
  DioClient._();

  static Dio create() {
    // Configures the base URL, timeouts, and default headers.
    final dio = Dio(
      BaseOptions( // Defines the default configuration for the Dio instance.
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Automatically attaches the user's access token to requests.
    dio.interceptors.add(AuthInterceptor());

    // Logs requests and responses during development.
    if (kDebugMode) { // Checks whether the app is running in debug mode.
      dio.interceptors.add(
        LogInterceptor( // Creates Dio's built-in logging interceptor. It helps developers inspect HTTP requests and responses.
          requestBody: true,
          responseBody: true,
        ),
      );
    }

    return dio;
  }
}