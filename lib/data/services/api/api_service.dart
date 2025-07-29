import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ps_app_clone_mvvm/core/environment.dart';

class ApiClient {
  final Dio dio;
  ApiClient({required this.dio}) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = SSO_TOKEN;
          options.headers['Accept-Language'] = Platform.localeName.replaceAll('_', '-');
          return handler.next(options);
        }
      )
    );
  }
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}