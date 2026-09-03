import 'package:flutter/cupertino.dart';
import 'package:myflutter1/apis/songs.dart';
import 'package:myflutter1/apis/songs_model.dart';
import 'package:myflutter1/pages/home/songs/song_detail_page.dart';
import 'package:myflutter1/services/storage.dart';
import 'package:myflutter1/widgets/network_image_widget.dart';

/// 搜索历史本地存储的 key
const String _kSearchHistoryKey = 'search_history';

/// 歌曲封面尺寸（pt）。改这一个值即可，下列值会自动跟随：
/// - 分隔线左侧缩进 = 左内边距 16 + 封面 + 间隙 12
/// - cacheWidth = 封面 × 3（按 DPR 控制解码内存，见项目约定）
const double _kCoverSize = 46;
const double _kRowPaddingStart = 16;
const double _kCoverGap = 12;

/// 页面颜色 token
///
/// 注意：CupertinoColors.label / systemGrey 等是 CupertinoDynamicColor，
/// 直接作为 TextStyle.color 会回退到亮色基础色（黑色），在暗黑模式下看不见，
/// 因此统一在此按当前 context 解析成真实主题色。
class _SearchStyle {
  final Color label;
  final Color secondary;
  final Color tertiary;
  final Color separator;
  final Color fill;

  _SearchStyle(BuildContext context)
    : label = CupertinoDynamicColor.resolve(CupertinoColors.label, context),
      secondary = CupertinoDynamicColor.resolve(
        CupertinoColors.secondaryLabel,
        context,
      ),
      tertiary = CupertinoDynamicColor.resolve(
        CupertinoColors.systemGrey,
        context,
      ),
      separator = CupertinoDynamicColor.resolve(
        CupertinoColors.systemGrey5,
        context,
      ),
      fill = CupertinoDynamicColor.resolve(
        CupertinoColors.systemGrey6,
        context,
      );
}

/// 秒数字符串（如 "269"）格式化为 m:ss
String _formatDuration(String raw) {
  final seconds = int.tryParse(raw.trim());
  if (seconds == null || seconds <= 0) return '';
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

class SearchSongs extends StatefulWidget {
  const SearchSongs({super.key});

  @override
  State<SearchSongs> createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> {
  final TextEditingController _songKeyword = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  /// 搜索中标记，控制 loading 显示
  bool _loading = false;

  /// 是否已执行过搜索（用于区分「未搜索」与「搜索无结果」）
  bool _searched = false;

  /// 最近一次搜索关键词
  String _keyword = '';

  /// 搜索失败信息（网络错误 / 解析失败）
  String? _errorMsg;

  /// 搜索历史（最新的在最前面）
  List<String> _history = [];

  /// 搜索结果
  final List<ResSong> searchResults = [];

  @override
  void initState() {
    super.initState();
    _initialize();
    _loadHistory();
  }

  /// 进入页面时，自动聚焦
  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  /// 从本地存储读取搜索历史
  Future<void> _loadHistory() async {
    final list = await LocalStorage.get<List<String>>(
      _kSearchHistoryKey,
      fromJson: (e) => List<String>.from(e as List),
    );
    if (list != null) {
      setState(() => _history = list);
    }
  }

  /// 将搜索词存入历史：去重后插入到最前面
  Future<void> _saveHistory(String value) async {
    final keyword = value.trim();
    if (keyword.isEmpty) return;
    final newList = [keyword, ..._history.where((e) => e != keyword)];
    await LocalStorage.set(_kSearchHistoryKey, newList);
    setState(() => _history = newList);
  }

  /// 点击历史记录：填充输入框并触发搜索
  Future<void> _onHistoryTap(String value) async {
    _songKeyword.text = value;
    _focusNode.unfocus();
    await _onSearch(value);
  }

  /// 搜索完成，即用户点击键盘搜索按钮 void表示这个函数没有返回，如果是 Int _onSearch表示返回数字
  Future<void> _onSearch(String value) async {
    debugPrint(value);
    final keyword = value.trim();
    if (keyword.isEmpty) return;
    // 收起键盘，让结果完整可见
    _focusNode.unfocus();

    setState(() {
      _loading = true;
      _searched = true;
      _keyword = keyword;
      _errorMsg = null;
    });

    final res = await ApiSongs.getSongs(ReqGetSongs(msg: keyword, page: "1"));

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (res.result) {
        searchResults
          ..clear()
          ..addAll(res.data ?? <ResSong>[]);
      } else {
        searchResults.clear();
        _errorMsg = res.msg.isNotEmpty ? res.msg : '搜索失败，请稍后重试';
        debugPrint("搜索失败：code=${res.code}, msg=${res.msg}");
      }
    });

    if (res.result) await _saveHistory(keyword);
  }

  /// 删除单条历史记录
  Future<void> _removeHistory(String value) async {
    final newList = _history.where((e) => e != value).toList();
    await LocalStorage.set(_kSearchHistoryKey, newList);
    setState(() => _history = newList);
  }

  /// 清空全部历史
  Future<void> _clearHistory() async {
    await LocalStorage.set(_kSearchHistoryKey, <String>[]);
    setState(() => _history = []);
  }

  @override
  Widget build(BuildContext context) {
    final style = _SearchStyle(context);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("搜索")),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: CupertinoSearchTextField(
                controller: _songKeyword,
                focusNode: _focusNode,
                placeholder: "搜索歌曲或歌手",
                onSubmitted: _onSearch,
                prefixInsets: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                suffixInsets: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
              ),
            ),
            Expanded(child: _buildContent(style)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(_SearchStyle style) {
    if (_loading) {
      return const Center(child: CupertinoActivityIndicator(radius: 16));
    }
    if (searchResults.isNotEmpty) {
      return _buildResultList(style);
    }
    if (_errorMsg != null) {
      return _buildError(style, _errorMsg ?? '搜索失败');
    }
    // 搜索过但无结果
    if (_searched) {
      return _buildPlaceholder(
        style,
        icon: CupertinoIcons.search,
        title: '未找到与「$_keyword」相关的歌曲',
        subtitle: '换个关键词试试',
      );
    }
    // 未搜索：优先展示历史
    if (_history.isNotEmpty) {
      return _SearchHistory(
        style: style,
        history: _history,
        onTap: _onHistoryTap,
        onDelete: _removeHistory,
        onClearAll: _clearHistory,
      );
    }
    return _buildPlaceholder(
      style,
      icon: CupertinoIcons.music_note,
      title: '搜索你想听的歌曲',
      subtitle: '支持歌曲名、歌手名',
    );
  }

  Widget _buildResultList(_SearchStyle style) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: searchResults.length,
      // iOS 风格分隔线：从封面右侧开始，左侧留白
      // 缩进 = 左内边距 + 封面 + 间隙，跟随 _kCoverSize 自动变化
      separatorBuilder: (_, _) => Container(
        margin: EdgeInsets.only(
          left: _kRowPaddingStart + _kCoverSize + _kCoverGap,
        ),
        height: 1,
        color: style.separator,
      ),
      itemBuilder: (context, index) {
        final item = searchResults[index];
        return _SongRow(
          style: style,
          song: item,
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => SongDetailPage(
                  // 序号从 1 开始，不能固定传 1，否则点哪首都拿到第一首的详情
                  n: index + 1,
                  msg: item.song,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildError(_SearchStyle style, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle,
              size: 44,
              color: style.tertiary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: style.secondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              minimumSize: Size.zero,
              borderRadius: BorderRadius.circular(8),
              onPressed: () => _onSearch(_keyword),
              child: const Text('重试', style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(
    _SearchStyle style, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: style.tertiary),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: style.label,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: style.secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// 歌曲行：Apple Music 风格，左侧圆角封面 + 右侧时长与箭头
class _SongRow extends StatelessWidget {
  final _SearchStyle style;
  final ResSong song;
  final VoidCallback onTap;

  const _SongRow({
    required this.style,
    required this.song,
    required this.onTap,
  });

  String get _subtitle {
    if (song.album.isEmpty) return song.singer;
    return '${song.singer} · ${song.album}';
  }

  @override
  Widget build(BuildContext context) {
    final duration = _formatDuration(song.time);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // 取消 iOS 默认 44pt 最小点击区域，让行高贴合封面，整体更紧凑
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            // 封面：圆角 + 固定尺寸，cacheWidth 由 _kCoverSize 派生
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkImageWidget(
                src: song.picture,
                width: _kCoverSize,
                height: _kCoverSize,
                fit: BoxFit.cover,
                cacheWidth: (_kCoverSize * 3).round(),
                errorIcon: CupertinoIcons.music_note,
                errorIconSize: 24,
              ),
            ),
            const SizedBox(width: _kCoverGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song.song,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: style.label,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: style.secondary),
                  ),
                ],
              ),
            ),
            if (duration.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                duration,
                style: TextStyle(fontSize: 13, color: style.tertiary),
              ),
            ],
            const SizedBox(width: 6),
            Icon(CupertinoIcons.chevron_right, size: 14, color: style.tertiary),
          ],
        ),
      ),
    );
  }
}

/// 搜索历史：Apple 风格标签（胶囊）+ 单条删除 / 清空
class _SearchHistory extends StatelessWidget {
  final _SearchStyle style;
  final List<String> history;
  final void Function(String) onTap;
  final void Function(String) onDelete;
  final VoidCallback onClearAll;

  const _SearchHistory({
    required this.style,
    required this.history,
    required this.onTap,
    required this.onDelete,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(
            children: [
              Text(
                "搜索历史",
                style: TextStyle(fontSize: 13, color: style.tertiary),
              ),
              const Spacer(),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                onPressed: onClearAll,
                child: Text(
                  "清空",
                  style: TextStyle(fontSize: 13, color: style.secondary),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: history.map(_buildChip).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String text) {
    return Container(
      decoration: BoxDecoration(
        color: style.fill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(text),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text, style: TextStyle(fontSize: 14, color: style.label)),
                const SizedBox(width: 6),
                // 嵌套 GestureDetector：内层优先响应，仅删除单条
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onDelete(text),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      CupertinoIcons.xmark,
                      size: 12,
                      color: style.tertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
