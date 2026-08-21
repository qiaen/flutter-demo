class ReqGetSongs {
  final String msg;
  final String? n; // 可选
  final String token;

  ReqGetSongs({required this.msg, this.n, required this.token});

  Map<String, dynamic> toQuery() {
    final query = <String, dynamic>{'msg': msg, 'token': token};
    if (n != null) query['n'] = n; // 只有非 null 才加入
    return query;
  }
}

class ResSong {
  final int index;
  final String title;
  final String singer;
  final String album;
  final String duration;
  final String songId;
  final String songMid;

  ResSong({
    required this.index,
    required this.title,
    required this.singer,
    required this.album,
    required this.duration,
    required this.songId,
    required this.songMid,
  });

  factory ResSong.fromJson(Map<String, dynamic> json) {
    return ResSong(
      index: json['序号'], // 这里是汉字，因为接口的key就是汉字
      title: json['歌曲名称'],
      singer: json['歌手'],
      album: json['专辑'],
      duration: json['时长'],
      songId: json['歌曲ID'],
      songMid: json['songmid'],
    );
  }
}

class ResSongs {
  final int count;
  final List<ResSong> songs;

  ResSongs({required this.count, required this.songs});

  factory ResSongs.fromJson(Map<String, dynamic> json) {
    final songList = (json['songs'] as List<dynamic>).map((e) {
      return ResSong.fromJson(e as Map<String, dynamic>);
    }).toList();
    return ResSongs(count: json['count'] as int, songs: songList);
  }
}

/// 单曲详情中各音质的播放链接
class ResSongPlayUrl {
  final String masterLossless; // 母带无损
  final String flacLossless; // 无损 FLAC
  final String hiRes; // Hi-Res 无损
  final String atmos; // Atmos 全景声
  final String ogg320; // OGG 320
  final String ogg192; // OGG 192
  final String mp3320; // MP3 320
  final String mp3128; // MP3 128
  final String aac192; // AAC 192
  final String aac96; // AAC 96
  final String aac48; // AAC 48
  final String preview30s; // 30s 试听

  ResSongPlayUrl({
    required this.masterLossless,
    required this.flacLossless,
    required this.hiRes,
    required this.atmos,
    required this.ogg320,
    required this.ogg192,
    required this.mp3320,
    required this.mp3128,
    required this.aac192,
    required this.aac96,
    required this.aac48,
    required this.preview30s,
  });

  factory ResSongPlayUrl.fromJson(Map<String, dynamic> json) {
    return ResSongPlayUrl(
      masterLossless: json['母带无损'] ?? '',
      flacLossless: json['无损FLAC'] ?? '',
      hiRes: json['Hi-Res无损'] ?? '',
      atmos: json['Atmos全景声'] ?? '',
      ogg320: json['OGG 320'] ?? '',
      ogg192: json['OGG 192'] ?? '',
      mp3320: json['MP3 320'] ?? '',
      mp3128: json['MP3 128'] ?? '',
      aac192: json['AAC 192'] ?? '',
      aac96: json['AAC 96'] ?? '',
      aac48: json['AAC 48'] ?? '',
      preview30s: json['30s 18'] ?? '',
    );
  }
}

/// 单曲详情（getSongByN 返回）
class ResSongInfo {
  final String title; // 歌曲名称
  final String singer; // 歌手
  final String album; // 专辑
  final String duration; // 时长
  final String songId; // 歌曲ID
  final String songMid; // songmid
  final String lyricStatus; // 歌词状态
  final String lyric; // 歌词内容
  final ResSongPlayUrl playUrl; // 播放链接

  ResSongInfo({
    required this.title,
    required this.singer,
    required this.album,
    required this.duration,
    required this.songId,
    required this.songMid,
    required this.lyricStatus,
    required this.lyric,
    required this.playUrl,
  });

  factory ResSongInfo.fromJson(Map<String, dynamic> json) {
    return ResSongInfo(
      title: json['歌曲名称'] ?? '',
      singer: json['歌手'] ?? '',
      album: json['专辑'] ?? '',
      duration: json['时长'] ?? '',
      songId: json['歌曲ID'] ?? '',
      songMid: json['songmid'] ?? '',
      lyricStatus: json['歌词状态'] ?? '',
      lyric: json['歌词内容'] ?? '',
      playUrl: ResSongPlayUrl.fromJson(json['播放链接'] as Map<String, dynamic>),
    );
  }
}
