import 'package:dio/dio.dart';

class ApiResponse<T> {
  final int code;
  final String msg;
  final T? data;

  ApiResponse({required this.code, required this.msg, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromData,
  ) {
    return ApiResponse(
      code: json['code'],
      message: json['msg'],
      data: json['data'] != null ? fromData(json['data']) : null,
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

  // static Future<A>
}
