import 'package:flutter/cupertino.dart';
import 'package:myflutter1/pages/home/songs/songs_search.dart';
import 'package:myflutter1/pages/home/webview_page.dart';

class HomeCards extends StatelessWidget {
  const HomeCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildCard(
              context: context,
              icon: CupertinoIcons.gift_fill,
              title: '每日签到',
              subtitle: '领积分换好礼',
              color: const Color(0xFFFF9500),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCard(
              context: context,
              icon: CupertinoIcons.star_fill,
              title: '热门推荐',
              subtitle: '精选内容合集',
              color: const Color(0xFF007AFF),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCard(
              context: context,
              icon: CupertinoIcons.flame_fill,
              title: '排行榜',
              subtitle: '看看谁最火',
              color: const Color(0xFFFF3B30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == '每日签到') {
          // 每日签到：打开 WebView
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (_) => const WebViewPage(
                url: 'https://koc-creator-dev.aceon.gg',
                title: '每日签到',
              ),
            ),
          );
          return;
        }
        // 其它卡片：保持原跳转逻辑
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(CupertinoPageRoute(builder: (_) => SearchSongs()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(
            alpha: CupertinoTheme.of(context).brightness == Brightness.dark
                ? 0.4
                : 0.1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
