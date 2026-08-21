import './songs_model.dart';
import '../services/http.dart';

/// 这里放公用的，私有的放到每个page文件夹下即可
class ApiSongs {
  /// 获取歌曲列表（GET 示例）
  static Future<ApiResponse<ResSongs>> getSongs(
    String msg,
    String n,
    String token,
  ) async {
    final res = await Http.get<ResSongs>(
      '/songs',
      ResSongs.fromJson,
      params: {'msg': msg, 'n': n, 'token': token},
    );
    return res;
  }
}
