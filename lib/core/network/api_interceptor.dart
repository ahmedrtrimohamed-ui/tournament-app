import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage storage;

  ApiInterceptor(this.dio, this.storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.read(key: ApiConstants.tokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.read(key: ApiConstants.refreshKey);

      if (refreshToken != null) {
        try {
          // Attempting to refresh token
          final response = await dio.post(
            ApiConstants.refresh,
            data: {'refresh': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['access'];
            await storage.write(
              key: ApiConstants.tokenKey,
              value: newAccessToken,
            );

            // Retry the original request with new token
            err.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            final secondResponse = await dio.fetch(err.requestOptions);
            return handler.resolve(secondResponse);
          }
        } catch (e) {
          // Refresh failed, logout
          await storage.deleteAll();
          // In a real app, trigger a logout event for the UI to handle
        }
      }
    }
    return handler.next(err);
  }
}
