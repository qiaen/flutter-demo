import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 通用 WebView 页面
/// [url] 要加载的链接地址
/// [title] 导航栏标题
class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({super.key, required this.url, this.title = ''});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _loading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        // iOS 风格：左侧返回按钮（默认带边缘滑动返回）
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const Center(child: CupertinoActivityIndicator(radius: 20)),
          ],
        ),
      ),
    );
  }
}
