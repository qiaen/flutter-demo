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
    // WebView 背景设为透明，由页面本体的暗黑/亮色背景透出，
    // 避免网页白底在暗黑模式下刺眼。
    _controller = WebViewController()
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            _applyDarkBackgroundIfNeeded();
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) {
            debugPrint("资源加载失败: ${error.description}");
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    // 超时保护：5 秒内未加载完成（onPageFinished 未触发）也停止菊花，避免一直转圈。
    Future.delayed(const Duration(seconds: 0), () {
      if (mounted && _loading) {
        debugPrint("WebView 加载超时（5s），停止 loading");
        setState(() => _loading = false);
      }
    });
  }

  /// 暗黑模式下给网页注入深色 body 背景与 color-scheme，
  /// 让未自带暗黑主题的网页也呈现深色底（网页自身已适配暗黑则不受影响）。
  void _applyDarkBackgroundIfNeeded() {
    if (!mounted) return;
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    if (!isDark) return;
    const js = """
      (function() {
        var s = document.createElement('style');
        s.textContent = 'html,body{background:#000!important;color-scheme:dark!important;}';
        document.head.appendChild(s);
      })();
    """;
    _controller.runJavaScript(js);
  }

  @override
  Widget build(BuildContext context) {
    final bg = CupertinoDynamicColor.resolve(
      CupertinoColors.systemBackground,
      context,
    );
    return CupertinoPageScaffold(
      backgroundColor: bg,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        // iOS 风格：左侧返回按钮（默认带边缘滑动返回）
      ),
      child: SafeArea(
        bottom: false,
        child: ColoredBox(
          color: bg,
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_loading)
                const Center(child: CupertinoActivityIndicator(radius: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
