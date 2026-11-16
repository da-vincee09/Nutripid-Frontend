import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_draft_model.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_request.dart';

abstract class WeeklyPlanRemoteDatasource {
  Future<WeeklyPlanDraftModel> generate(WeeklyPlanGenerateRequest request);
  Future<WeeklyPlanAcceptResult> accept(WeeklyPlanAcceptRequest request);
}

class WeeklyPlanRemoteDatasourceImpl implements WeeklyPlanRemoteDatasource {
  final Dio _dio;

  // ignore: prefer_initializing_formals
  WeeklyPlanRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<WeeklyPlanDraftModel> generate(
    WeeklyPlanGenerateRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.weeklyPlanGenerate,
        data: request.toJson(),
      );
      return WeeklyPlanDraftModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<WeeklyPlanAcceptResult> accept(WeeklyPlanAcceptRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.weeklyPlanAccept,
        data: request.toJson(),
      );
      return WeeklyPlanAcceptResult.fromJson(
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

    final detail = e.response?.data is Map
        ? (e.response?.data as Map)['detail']
        : null;

    switch (e.response?.statusCode) {
      case 400:
        return BadRequestException(
          detail is String ? detail : 'That request could not be completed.',
        );
      case 401:
        return const UnauthorizedException();
      case 404:
        // This feature's 404s carry a useful message, e.g.
        // "No meals match your budget and food restrictions."
        if (detail is String) return BadRequestException(detail);
        return const ServerException();
      case 422:
        final errors = detail is List<dynamic> ? detail : <dynamic>[];
        return ValidationException(errors);
      default:
        return const ServerException();
    }
  }
}