import 'package:dio/dio.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/core/networks/api_constants.dart';
import 'package:meal_recommendation_app/features/savings/data/models/savings_summary_model.dart';

abstract class SavingsRemoteDatasource {
  Future<SavingsSummaryModel> getSummary(SavingsPeriod period);
}

class SavingsRemoteDatasourceImpl implements SavingsRemoteDatasource {
  final Dio _dio;

  // ignore: prefer_initializing_formals
  SavingsRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<SavingsSummaryModel> getSummary(SavingsPeriod period) async {
    try {
      final response = await _dio.get(
        ApiConstants.savingsSummary,
        queryParameters: {'period': period.apiValue},
      );
      return SavingsSummaryModel.fromJson(
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
      case 422:
        final errors = detail is List<dynamic> ? detail : <dynamic>[];
        return ValidationException(errors);
      default:
        return const ServerException();
    }
  }
}