import './songs_model.dart';
import '../services/http.dart';

/// 这里放公用的，私有的放到每个page文件夹下即可
class ApiSongs {
  /// 获取歌曲列表（GET 示例）
  /// [params] 由外部传入，例如：
  ///   {'msg': 'xxx', 'n': '1', 'token': 'xxx'}
  /// 其中 n 为可选，不传或传 null 时不会加入请求参数。
  ///
  ///
  static Future<ApiResponse<List<ResSong>>> getSongs(ReqGetSongs params) async {
    // data 是数组：用 getList，fromData 直接传单个元素的解析方法
    final res = await Http.getList<ResSong>(
      '',
      ResSong.fromJson,
      params: params.toQuery(),
    );
    return res;
  }

  /// 获取详情，俩接口一样，只是多个个n参数
  static Future<ApiResponse<ResSongInfo>> getSongByN(ReqGetSongs params) async {
    final res = await Http.get<ResSongInfo>(
      '', // "/songs"
      ResSongInfo.fromJson,
      params: params.toQuery(),
    );
    return res;
  }
}
