import 'package:dio/dio.dart';

/// 通用参数返回
class ApiResponse<T> {
  final int code;
  final String msg;
  final T? data;

  /// 请求是否成功：后端约定 code == 200 且 data 不为空时为 true。
  /// 外部只需判断 result 即可，无需再手写 res.code == 200 && res.data != null。
  final bool result;

  ApiResponse({
    required this.code,
    required this.msg,
    this.data,
    required this.result,
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
