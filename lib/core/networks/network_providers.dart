import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';

// Provides a configured Dio instance for API communication throughout the app.
final dioProvider = Provider<Dio>((ref) {
  // Creates and returns the configured Dio client.
  return DioClient.create();
});