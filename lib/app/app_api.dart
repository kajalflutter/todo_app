import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:todo_app/app/api_manager.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  final Dio _dio;
  ApiService._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: APIManager.base,
          connectTimeout: const Duration(seconds: 100),
          receiveTimeout: const Duration(seconds: 100),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    // Add PrettyDioLogger as an interceptor
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true, // Change to false to see more detailed logs
    ));
  }

  Future<Response> request({
    required String path,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = RequestOptions(
        path: APIManager.base + path,
        method: method,
        data: data,
        queryParameters: queryParameters,
        headers: headers ?? {},
      );
      return await _dio.fetch(options);
    } catch (error) {
      // final handler = ErrorHandler.handle(error);
      rethrow; // Re-throw the failure for further handling
    }
  }

  // Convenience methods for GET, POST, etc.
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) {
    return request(path: path, method: 'GET', queryParameters: queryParameters, headers: headers);
  }

  Future<Response> post(String path, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    return request(path: path, method: 'POST', data: data, headers: headers);
  }

  Future<Response> put(String path, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    return request(path: path, method: 'PUT', data: data, headers: headers);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    return request(path: path, method: 'DELETE', data: data, headers: headers);
  }
}
