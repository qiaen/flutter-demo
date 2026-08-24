import 'package:flutter/cupertino.dart';
import 'package:myflutter1/apis/songs.dart';
import 'package:myflutter1/apis/songs_model.dart';
import 'package:myflutter1/pages/home/songs/song_detail_page.dart';
import 'package:myflutter1/services/storage.dart';
// import 'package:flutter/material.dart';

/// 搜索历史本地存储的 key
const String _kSearchHistoryKey = 'search_history';

class SearchSongs extends StatefulWidget {
  const SearchSongs({super.key});

  @override
  State<SearchSongs> createState() => _SearchSongsState();
}

class _SearchSongsState extends State<SearchSongs> {
  /// 通知总开关
  // final bool _enableNotification = false;
  // final bool _enablePush = false;
  // final bool _enableSound = true;
  final TextEditingController _songKeyword = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  /// 搜索中标记，控制 loading 显示
  bool _loading = false;

  /// 搜索历史（最新的在最前面）
  List<String> _history = [];

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
    setState(() => _loading = true);
    final res = await ApiSongs.getSongs(
      ReqGetSongs(msg: value, token: "f84ao9lMF_q7husBWRfgUw"),
    );
    setState(() => _loading = false);
    // result 已在 ApiResponse 中根据 code==200 && data!=null 自动判断
    if (res.result) {
      await _saveHistory(value);
      setState(() {
        searchResults
          ..clear()
          ..addAll(res.data!.songs);
      });
    } else {
      // 失败：可按需根据 res.code / res.msg 自行处理
      debugPrint("搜索失败：code=${res.code}, msg=${res.msg}");
    }
  }

  /// 删除单条历史记录
  Future<void> _removeHistory(String value) async {
    final newList = _history.where((e) => e != value).toList();
    await LocalStorage.set(_kSearchHistoryKey, newList);
    setState(() => _history = newList);
  }

  // 模拟搜索结果数据
  final List<ResSong> searchResults = [];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("搜索")),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: CupertinoSearchTextField(
                controller: _songKeyword,
                focusNode: _focusNode,
                placeholder: "请输入搜索内容",
                onSubmitted: _onSearch,
                prefixInsets: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                suffixInsets: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CupertinoActivityIndicator(radius: 20))
                  : searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final item = searchResults[index];
                        return CupertinoListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (_) => SongDetailPage(
                                  n: item.index,
                                  msg: item.title,
                                ),
                              ),
                            );
                          },
                          title: Text(item.title),
                          subtitle: Text("${item.singer} · ${item.duration}"),
                          trailing: const Icon(
                            CupertinoIcons.double_music_note,
                            color: CupertinoColors.systemGrey4,
                            size: 14,
                          ),
                        );
                      },
                    )
                  : _history.isNotEmpty
                      ? _SearchHistory(
                          history: _history,
                          onTap: _onHistoryTap,
                          onDelete: _removeHistory,
                        )
                      : const Center(child: Text("暂无搜索结果")),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHistory extends StatelessWidget {
  final List<String> history;
  final void Function(String) onTap;
  final void Function(String) onDelete;

  const _SearchHistory({
    required this.history,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            "搜索历史",
            style: TextStyle(
              fontSize: 13,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return CupertinoListTile(
                onTap: () => onTap(item),
                title: Text(item),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => onDelete(item),
                  child: const Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.systemGrey4,
                    size: 18,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
