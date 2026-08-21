class Song {
  final int index;
  final String title;
  final String singer;
  final String album;
  final String duration;
  final String songId;
  final String songMid;

  Song({
    required this.index,
    required this.title,
    required this.singer,
    required this.album,
    required this.duration,
    required this.songId,
    required this.songMid,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
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

class SongsResponse {
  final int count;
  final List<Song> songs;

  SongsResponse({required this.count, required this.songs});

  factory SongsResponse.fromJson(Map<String, dynamic> json) {
    return SongsResponse(
      count: json['count'],
      songs: (json['songs'] as List).map((e) => Song.fromJson(e)).toList(),
    );
  }
}
