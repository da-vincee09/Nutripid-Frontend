import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_create_request.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_model.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_update_request.dart';

// Defines the operations that the profile datasource must support.
abstract class ProfileRemoteDatasource {
  Future<ProfileModel> createProfile(ProfileCreateRequest request);
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> updateProfile(ProfileUpdateRequest request);
  Future<String> uploadProfileImage(File imageFile);
}

// Defines the operations that the profile datasource must support.
class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio _dio;

  // ignore: prefer_initializing_formals
  ProfileRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  // Sends profile information to the backend and converts the response into a model.
  @override
  Future<ProfileModel> createProfile(ProfileCreateRequest request) async {
    final json = await _request(
      () => _dio.post(ApiConstants.profiles, data: request.toJson()),
    );
    return ProfileModel.fromJson(json);
  }

  // Retrieves the currently authenticated user's profile.
  @override
  Future<ProfileModel> getMyProfile() async {
    final json = await _request(
      () => _dio.get(ApiConstants.profileMe),
    );
    return ProfileModel.fromJson(json);
  }

  // Sends updated profile information to the backend.
  @override
  Future<ProfileModel> updateProfile(ProfileUpdateRequest request) async {
    final json = await _request(
      () => _dio.put(ApiConstants.profileMe, data: request.toJson()),
    );
    return ProfileModel.fromJson(json);
  }

  // Reusable helper for executing API requests and handling Dio errors.
  Future<Map<String, dynamic>> _request(
    Future<Response> Function() call,
  ) async {
    try {
      final response = await call();
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }
  
  // Converts Dio errors into custom API exceptions used by the application.
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

    final response = e.response!;
    final body = response.data;
    final detail = body is Map<String, dynamic> ? body['detail'] : null;

    switch (response.statusCode) {
      case 401:
        return UnauthorizedException(
          detail is String ? detail : const UnauthorizedException().message,
        );
      case 404:
        return ProfileNotFoundException(
          detail is String
              ? detail
              : const ProfileNotFoundException().message,
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

  // Uploads a profile image using multipart/form-data and returns its URL.
  @override
  Future<String> uploadProfileImage(File imageFile) async {
    final fileName = imageFile.path.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    final json = await _request(
      () => _dio.post('${ApiConstants.profileMe}/image', data: formData),
    );

    return json['profile_image_url'] as String;
  }
}