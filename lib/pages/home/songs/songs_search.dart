import 'package:flutter/cupertino.dart';
import 'package:myflutter1/apis/songs.dart';
import 'package:myflutter1/apis/songs_model.dart';
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

  /// 搜索中标记，控制 loading 显示
  bool _loading = false;

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
  Future<void> _onSearch(String value) async {
    debugPrint(value);
    setState(() => _loading = true);
    final res = await ApiSongs.getSongs(
      ReqGetSongs(msg: value, token: "f84ao9lMF_q7husBWRfgUw"),
    );
    setState(() => _loading = false);
    // result 已在 ApiResponse 中根据 code==200 && data!=null 自动判断
    if (res.result) {
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
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final item = searchResults[index];
                        return CupertinoListTile(
                          title: Text(item.title),
                          subtitle: Text("${item.singer} · ${item.duration}"),
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
