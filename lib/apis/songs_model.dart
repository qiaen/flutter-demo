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
