import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleError(DioException e) {
    String message = 'Something went wrong';
    if (e.response != null) {
      final data = e.response?.data;
      if (data != null && data is Map && data.containsKey('detail')) {
        message = data['detail'];
      } else if (data != null && data is Map && data.containsKey('message')) {
        message = data['message'];
      } else {
        message = 'Server Error: ${e.response?.statusCode}';
      }
    } else {
      if (e.type == DioExceptionType.connectionTimeout)
        message = 'Connection Timeout';
      else if (e.type == DioExceptionType.receiveTimeout)
        message = 'Receive Timeout';
      else if (e.type == DioExceptionType.connectionError)
        message = 'No Internet Connection';
      else
        message = e.message ?? 'Unknown Network Error';
    }
    return Exception(message);
  }
}
