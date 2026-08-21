import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// 进入页面时，自动聚焦
  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  /// 搜索完成，即用户点击键盘搜索按钮 void表示这个函数没有返回，如果是 Int _onSearch表示返回数字
  void _onSearch(String value) {
    debugPrint(value);
  }

  // 模拟搜索结果数据
  final List<Map<String, String>> searchResults = [
    {
      "song_title": "庙堂之外",
      "pay": "付费",
      "song_mid": "001k6sxm1dA47V",
      "singer_name": "陈楚生",
    },
    {
      "song_title": "平凡之路",
      "pay": "免费",
      "song_mid": "002abcde12345",
      "singer_name": "朴树",
    },
    {
      "song_title": "演员",
      "pay": "付费",
      "song_mid": "003xyz987654",
      "singer_name": "薛之谦",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("搜索")),
      child: SafeArea(
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
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final item = searchResults[index];
                  return CupertinoListTile(
                    title: Text(item["song_title"] ?? ""),
                    subtitle: Text("${item["singer_name"]} · ${item["pay"]}"),
                    trailing: const Icon(
                      CupertinoIcons.double_music_note,
                      color: CupertinoColors.systemGrey4,
                      size: 14,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
