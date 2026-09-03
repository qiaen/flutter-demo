class ReqGetSongs {
  final String msg;
  final String? n; // 可选
  final String page;

  ReqGetSongs({required this.msg, this.n, required this.page});

  Map<String, dynamic> toQuery() {
    final query = <String, dynamic>{'msg': msg, 'page': page};
    if (n != null) query['n'] = n; // 只有非 null 才加入
    return query;
  }
}

class ResSong {
  final String picture;
  final String song;
  final String singer;
  final String album;
  final String time;
  final String rid;

  ResSong({
    required this.picture,
    required this.song,
    required this.singer,
    required this.album,
    required this.time,
    required this.rid,
  });

  factory ResSong.fromJson(Map<String, dynamic> json) {
    return ResSong(
      picture: json['picture'],
      song: json['song'],
      singer: json['singer'],
      album: json['album'],
      time: json['time'],
      rid: json['rid'],
    );
  }
}

/// 音质等级（由 bitrate + format + level 推导出的展示文案）
enum ResSongQuality {
  masterLossless,
  hiRes,
  lossless,
  high,
  standard,
  unknown,
}

/// 单曲详情（getSongByN 返回）
///
/// 接口返回示例：
/// {
///   "code": 1,
///   "message": "...",
///   "data": {
///     "album": "凡人修仙传 韩立结婴纪念专辑",
///     "bitrate": "2000",
///     "format": "flac",
///     "id": 493285941,
///     "level": "ff",
///     "picture": "https://.../xxx.jpg",
///     "rid": "MUSIC_493285941",
///     "singer": "王铮亮",
///     "size": "51.83Mb",
///     "song": "不凡2024-《凡人修仙传》动画结婴曲",
///     "time": "252",
///     "url": "http://.../xxx.flac?..."
///   }
/// }
class ResSongInfo {
  final String song; // 歌名
  final String singer; // 歌手
  final String album; // 专辑
  final String picture; // 封面图
  final String time; // 时长（秒）
  final String url; // 播放链接
  final String bitrate; // 码率（kbps）
  final String format; // 音频格式（flac / mp3 ...）
  final String size; // 文件大小
  final String level; // 音质等级码
  final String rid; // 资源 id
  final int id; // 数字 id

  ResSongInfo({
    required this.song,
    required this.singer,
    required this.album,
    required this.picture,
    required this.time,
    required this.url,
    required this.bitrate,
    required this.format,
    required this.size,
    required this.level,
    required this.rid,
    required this.id,
  });

  factory ResSongInfo.fromJson(Map<String, dynamic> json) {
    return ResSongInfo(
      song: json['song'] ?? '',
      singer: json['singer'] ?? '',
      album: json['album'] ?? '',
      picture: json['picture'] ?? '',
      time: json['time'] ?? '',
      url: json['url'] ?? '',
      bitrate: json['bitrate'] ?? '',
      format: json['format'] ?? '',
      size: json['size'] ?? '',
      level: json['level'] ?? '',
      rid: json['rid'] ?? '',
      id: json['id'] is int ? json['id'] as int : 0,
    );
  }

  /// 有无可播放链接
  bool get hasUrl => url.isNotEmpty;

  /// 音质等级：优先按码率判断，其次按 level / format 兜底
  ResSongQuality get quality {
    final rate = int.tryParse(bitrate) ?? 0;
    if (rate >= 2000) return ResSongQuality.masterLossless;
    if (rate >= 900) return ResSongQuality.hiRes;
    if (rate >= 320) return ResSongQuality.lossless;
    if (rate >= 192) return ResSongQuality.high;
    if (rate > 0) return ResSongQuality.standard;
    final lv = level.toLowerCase();
    if (lv.contains('ff')) return ResSongQuality.masterLossless;
    if (format.toLowerCase() == 'flac') return ResSongQuality.lossless;
    return ResSongQuality.unknown;
  }
}


