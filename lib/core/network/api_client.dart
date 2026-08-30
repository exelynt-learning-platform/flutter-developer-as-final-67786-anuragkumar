import 'package:dio/dio.dart';
import '../error/app_exception.dart';

abstract final class ApiConstants {
  static const String baseUrl = 'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1';

  static const String countries = '/country';
  static const String employees = '/employee';

  static String employeeById(String id) => '$employees/$id';
}

class ApiClient {
  static final defaultDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  ApiClient({ Dio? dio }) : _dio = dio ?? defaultDio;

  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
  }) async {
    try {
      return await _dio.post<dynamic>(
        path,
        data: data,
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
  }) async {
    try {
      return await _dio.put<dynamic>(
        path,
        data: data,
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<Response<dynamic>> delete(String path) async {
    try {
      return await _dio.delete<dynamic>(path);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  AppException _mapDioException(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => const NetworkException('Unable to connect to the server.'),
      _ when error.response?.statusCode == 404 => const NotFoundException('The requested resource was not found.'),
      _ when error.response != null => ServerException('Server returned status ${error.response?.statusCode}.'),
      _ => const UnknownException('An unexpected error occurred.'),
    };
  }
}
