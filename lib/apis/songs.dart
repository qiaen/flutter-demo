import './songs_model.dart';
import '../services/http.dart';

/// 这里放公用的，私有的放到每个page文件夹下即可
class ApiSongs {
  /// 获取歌曲列表（GET 示例）
  /// [params] 由外部传入，例如：
  ///   {'msg': 'xxx', 'n': '1', 'token': 'xxx'}
  /// 其中 n 为可选，不传或传 null 时不会加入请求参数。
  static Future<ApiResponse<ResSongs>> getSongs(ReqGetSongs params) async {
    final res = await Http.get<ResSongs>(
      '', // "/songs"
      ResSongs.fromJson,
      params: params.toQuery(),
    );
    return res;
  }
}
