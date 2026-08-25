import 'package:flutter/cupertino.dart';

/// 自定义导航栏：使用 bg_navbar.png 作为背景，常驻显示（不依赖滚动）
class CustomAppBar extends StatelessWidget {
  final String title;
  final double height;
  final VoidCallback? onBack;
  final VoidCallback? onSearch;

  const CustomAppBar({
    super.key,
    required this.title,
    this.height = 44,
    this.onBack,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      // 背景图铺满整个导航栏区域（含状态栏）
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_navbar.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.only(top: safeTop),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: onBack,
              child: const Icon(
                CupertinoIcons.back,
                color: CupertinoColors.white,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: onSearch ?? () => debugPrint("搜索"),
              child: const Icon(
                CupertinoIcons.search,
                color: CupertinoColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
