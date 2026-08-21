import '../services/http.dart';

/// 这里放公用的，私有的放到每个page文件夹下即可
class ApiBase {
  ///  登录接口（POST）
  static Future<ApiResponse<Map<String, dynamic>>> login(
    String username,
    String password,
  ) async {
    final res = await Http.post<Map<String, dynamic>>(
      '/login',
      (json) => json,
      params: {'username': username, 'password': password},
    );
    return res;
  }
}
