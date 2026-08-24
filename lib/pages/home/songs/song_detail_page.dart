import 'package:flutter/cupertino.dart';
import 'package:myflutter1/apis/songs.dart';
import 'package:myflutter1/apis/songs_model.dart';

/// 歌曲详情页
/// [n] 歌曲在列表中的序号，用于调用 getSongByN 获取详情。
/// [msg] 歌曲名称，作为接口参数传入。
class SongDetailPage extends StatefulWidget {
  final int n;
  final String msg;

  const SongDetailPage({super.key, required this.n, required this.msg});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  bool _loading = true;
  ResSongInfo? _info;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() => _loading = true);
    final res = await ApiSongs.getSongByN(
      ReqGetSongs(
        msg: widget.msg,
        n: widget.n.toString(),
        token: "f84ao9lMF_q7husBWRfgUw",
      ),
    );
    if (res.result) {
      setState(() => _info = res.data);
    } else {
      setState(() => _errorMsg = res.msg.isNotEmpty ? res.msg : "获取详情失败");
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("歌曲详情")),
      child: SafeArea(
        bottom: false,
        child: _loading
            ? const Center(child: CupertinoActivityIndicator(radius: 20))
            : _errorMsg != null
            ? _buildError()
            : _buildContent(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            size: 48,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 12),
          Text(
            _errorMsg!,
            style: const TextStyle(color: CupertinoColors.systemGrey),
          ),
          const SizedBox(height: 16),
          CupertinoButton(onPressed: _loadDetail, child: const Text("重试")),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final info = _info!;
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: _loadDetail),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // 头部信息
              Center(
                child: Column(
                  children: [
                    const Icon(
                      CupertinoIcons.double_music_note,
                      size: 72,
                      color: CupertinoColors.systemGrey3,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      info.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${info.singer} · ${info.album}",
                      style: const TextStyle(color: CupertinoColors.systemGrey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "时长 ${info.duration}　歌词状态：${info.lyricStatus}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 播放链接（各音质）
              const _SectionTitle("播放链接"),
              _buildPlayUrls(info.playUrl),
              const SizedBox(height: 20),

              // 歌词
              const _SectionTitle("歌词"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  info.lyric.isEmpty ? "暂无歌词" : info.lyric,
                  style: const TextStyle(fontSize: 13, height: 1.6),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context)
                    .padding
                    .bottom, // 自动读取距离底部的高度，比设置安全距离好点，安全距离底部会留padding，导致滚动不到
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayUrls(ResSongPlayUrl url) {
    final items = <Map<String, String>>[
      {"母带无损": url.masterLossless},
      {"无损 FLAC": url.flacLossless},
      {"Hi-Res 无损": url.hiRes},
      {"Atmos 全景声": url.atmos},
      {"OGG 320": url.ogg320},
      {"OGG 192": url.ogg192},
      {"MP3 320": url.mp3320},
      {"MP3 128": url.mp3128},
      {"AAC 192": url.aac192},
      {"AAC 96": url.aac96},
      {"AAC 48": url.aac48},
      {"30s 试听": url.preview30s},
    ];

    return Column(
      children: items.map((e) {
        final name = e.keys.first;
        final link = e.values.first;
        return CupertinoListTile(
          title: Text(name),
          subtitle: link.isEmpty
              ? const Text("无")
              : Text(
                  link,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
          trailing: link.isEmpty
              ? null
              : const Icon(
                  CupertinoIcons.link,
                  color: CupertinoColors.systemGrey4,
                  size: 16,
                ),
        );
      }).toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.label,
        ),
      ),
    );
  }
}
