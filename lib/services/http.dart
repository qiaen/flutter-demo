import 'package:dio/dio.dart';

/// 通用参数返回
class ApiResponse<T> {
  final int code;
  final String msg;
  final T? data;

  ApiResponse({required this.code, required this.msg, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromData,
  ) {
    return ApiResponse(
      code: json['code'],
      msg: json['msg'],
      data: json['data'] != null
          ? fromData(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Http {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "https://apicx.asia/api/joox_music",
            connectTimeout: const Duration(seconds: 60), // 建立连接时间
            receiveTimeout: const Duration(seconds: 60), // 链接后返回时间
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onResponse: (response, handler) {
              final code = response.data['code'];
              if (code == 401) {
                print("401 未授权，需要跳转登录页");
              }
              handler.next(response);
            },
            onError: (error, handler) {
              print("网络错误: ${error.message}");
              handler.next(error);
            },
          ),
        );

  /// GET 请求
  static Future<ApiResponse<T>> get<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    final response = await dio.get(path, queryParameters: params);
    return ApiResponse.fromJson(response.data, fromData);
  }

  /// POST 请求
  static Future<ApiResponse<T>> post<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    final response = await dio.post(path, data: params);
    return ApiResponse.fromJson(response.data, fromData);
  }
}
