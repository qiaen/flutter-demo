import 'dart:developer';
import 'package:dio/dio.dart';

/// 通用返回结构
class ApiResponse<T> {
  final int code;
  final String msg;
  final T? data;
  final bool result;
  final bool netError;

  ApiResponse({
    required this.code,
    required this.msg,
    this.data,
    required this.result,
    this.netError = false,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromData,
  ) {
    final int code = json['code'];
    final bool hasData = json['data'] != null;
    final bool result = code == 200 && hasData;
    return ApiResponse(
      code: code,
      msg: json['msg'] ?? '',
      data: hasData ? fromData(json['data'] as Map<String, dynamic>) : null,
      result: result,
    );
  }

  /// 网络异常时返回
  factory ApiResponse.netError([String msg = "网络异常，请稍后重试"]) {
    return ApiResponse(code: -1, msg: msg, result: false, netError: true);
  }
}

class Http {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "https://apicx.asia/api/joox_music",
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onResponse: (response, handler) {
              final code = response.data['code'];
              if (code == 401) {
                log("401 未授权，需要跳转登录页", name: "http");
              }
              handler.next(response);
            },
            onError: (error, handler) {
              log("网络错误: ${error.message}", name: "http");
              handler.next(error);
            },
          ),
        );

  /// 内部统一请求方法
  static Future<ApiResponse<T>> _request<T>(
    Future<Response> Function() request,
    T Function(Map<String, dynamic>) fromData,
  ) async {
    try {
      final response = await request();
      return ApiResponse.fromJson(response.data, fromData);
    } catch (e) {
      log("请求异常: $e", name: "http");
      return ApiResponse.netError();
    }
  }

  /// GET 请求
  static Future<ApiResponse<T>> get<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(() => dio.get(path, queryParameters: params), fromData);
  }

  /// POST 请求 ⚠️ 目前post的params不会拼接到URL上，只会放到body体内，这是为了写service时候只用一个params会更方便
  /// 如果post请求你的params需要URL内，自己拼装即可，例如 '$path?foo=bar'，以下put，delete同此
  static Future<ApiResponse<T>> post<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(() => dio.post(path, data: params), fromData);
  }

  /// PUT 请求（可选扩展）
  static Future<ApiResponse<T>> put<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(() => dio.put(path, data: params), fromData);
  }

  /// DELETE 请求（可选扩展）
  static Future<ApiResponse<T>> delete<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(() => dio.delete(path, data: params), fromData);
  }
}
