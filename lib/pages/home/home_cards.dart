import 'package:flutter/cupertino.dart';
import 'package:myflutter1/pages/home/songs/songs_search.dart';

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
        // Navigator.of(context, rootNavigator: true).push(
        //   CupertinoSheetRoute(
        //     scrollableBuilder:
        //         (BuildContext context, ScrollController controller) {
        //           Widget widgetBuilder(BuildContext _) => SearchSongs();
        //           return widgetBuilder(context);
        //         },
        //   ),
        // ); // 类似小猫音乐ios 26之前的那种sheet
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(CupertinoPageRoute(builder: (_) => SearchSongs()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
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
