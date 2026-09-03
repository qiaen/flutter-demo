import 'dart:developer';
import 'package:dio/dio.dart';

/// 通用返回结构
class ApiResponse<T> {
  final int code;
  final String msg;
  final T? data;
  final bool result;

  /// true：网络层失败（DioException，如超时 / 断网 / 证书 / 状态码非 2xx）
  final bool netError;

  /// true：接口已通（HTTP 200），但响应结构与 model 不匹配，解析失败
  final bool parseError;

  ApiResponse({
    required this.code,
    required this.msg,
    this.data,
    required this.result,
    this.netError = false,
    this.parseError = false,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromData,
  ) {
    final int code = json['code'] is int ? json['code'] as int : -1;
    final dynamic rawData = json['data'];
    // data 支持两种形态，具体由调用方传入的 fromData 决定如何解析：
    //   - Map ：对象型响应（如详情接口）
    //   - List：数组型响应（如列表接口，空数组也算成功，只是没有数据）
    // 其余类型（null / String / bool 等）视为无数据，
    // 避免强转时抛异常被误报成「网络错误」。
    final bool hasData =
        rawData is Map<String, dynamic> || rawData is List<dynamic>;
    return ApiResponse(
      code: code,
      msg: (json['message'] ?? json['msg'] ?? '').toString(),
      data: hasData ? fromData(rawData) : null,
      result: code == 1 && hasData,
    );
  }

  /// 网络异常时返回（DioException：超时 / 断网 / 证书 / 状态码异常等）
  factory ApiResponse.netError([String msg = "网络异常，请稍后重试"]) {
    return ApiResponse(code: -1, msg: msg, result: false, netError: true);
  }

  /// 响应解析失败时返回（接口已通，但结构与 model 不匹配）
  factory ApiResponse.parseError([String msg = "数据解析失败"]) {
    return ApiResponse(code: -2, msg: msg, result: false, parseError: true);
  }
}

class Http {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "https://oiapi.net/api/Kuwo",
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onResponse: (response, handler) {
              // response.data 可能不是 Map（如后端返回纯文本 / 数组），
              // 直接取 ['code'] 会抛异常并被误报成网络错误，故先做类型判断
              if (response.data is Map) {
                final code = (response.data as Map)['code'];
                if (code == 401) {
                  log("401 未授权，需要跳转登录页", name: "http");
                }
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
  /// [fromData] 入参为 dynamic：data 可能是 Map 也可能是 List，
  /// 由调用方（get / getList 等）决定如何转换，这里不做任何类型假设。
  static Future<ApiResponse<T>> _request<T>(
    Future<Response> Function() request,
    T Function(dynamic) fromData,
  ) async {
    try {
      final response = await request();
      return ApiResponse.fromJson(response.data, fromData);
    } on DioException catch (e) {
      // 真正的网络层错误：超时 / 断网 / 证书 / 状态码非 2xx 等
      log("网络错误: ${e.type} ${e.message}", name: "http");
      return ApiResponse.netError();
    } catch (e, s) {
      // 接口已通（HTTP 200），但响应结构与 model 不匹配导致解析失败。
      // 这里不能再归为网络错误，否则会掩盖后端改字段 / 改类型的问题。
      log("数据解析失败: $e\n$s", name: "http");
      return ApiResponse.parseError("数据解析失败：$e");
    }
  }

  // ============================================================
  // data 为「对象」时使用：fromData 可直接传 model 的 fromJson
  // ============================================================

  /// GET 请求
  static Future<ApiResponse<T>> get<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(
      () => dio.get(path, queryParameters: params),
      (dynamic data) => fromData(data as Map<String, dynamic>),
    );
  }

  /// POST 请求 ⚠️ 目前post的params不会拼接到URL上，只会放到body体内，这是为了写service时候只用一个params会更方便
  /// 如果post请求你的params需要URL内，自己拼装即可，例如 '$path?foo=bar'，以下put，delete同此
  static Future<ApiResponse<T>> post<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(
      () => dio.post(path, data: params),
      (dynamic data) => fromData(data as Map<String, dynamic>),
    );
  }

  /// PUT 请求（可选扩展）
  static Future<ApiResponse<T>> put<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(
      () => dio.put(path, data: params),
      (dynamic data) => fromData(data as Map<String, dynamic>),
    );
  }

  /// DELETE 请求（可选扩展）
  static Future<ApiResponse<T>> delete<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(
      () => dio.delete(path, data: params),
      (dynamic data) => fromData(data as Map<String, dynamic>),
    );
  }

  // ============================================================
  // data 为「数组」时使用：fromData 解析单个元素，返回 List<T>
  // ============================================================

  /// GET 请求（data 为数组）
  static Future<ApiResponse<List<T>>> getList<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(
      () => dio.get(path, queryParameters: params),
      (dynamic data) => _toList(data, fromData),
    );
  }

  /// POST 请求（data 为数组）
  static Future<ApiResponse<List<T>>> postList<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(
      () => dio.post(path, data: params),
      (dynamic data) => _toList(data, fromData),
    );
  }

  /// PUT 请求（data 为数组，可选扩展）
  static Future<ApiResponse<List<T>>> putList<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(
      () => dio.put(path, data: params),
      (dynamic data) => _toList(data, fromData),
    );
  }

  /// DELETE 请求（data 为数组，可选扩展）
  static Future<ApiResponse<List<T>>> deleteList<T>(
    String path,
    T Function(Map<String, dynamic>) fromData, {
    Map<String, dynamic>? params,
  }) async {
    return _request(
      () => dio.delete(path, data: params),
      (dynamic data) => _toList(data, fromData),
    );
  }

  /// 数组转换：逐个元素交给 fromData 解析
  static List<T> _toList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromData,
  ) {
    return (data as List<dynamic>)
        .map((e) => fromData(e as Map<String, dynamic>))
        .toList();
  }
}
