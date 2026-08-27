import 'package:flutter/cupertino.dart';

/// 自定义导航栏：使用 bg.png 作为背景，常驻显示（不依赖滚动）
///
/// 参数说明：
/// - [title] 必填标题
/// - [leading] 左侧插槽：传入则优先显示该 Widget；不传时根据 [showBack] 显示默认返回按钮
/// - [trailing] 右侧插槽：传入任意 Widget（点击事件由传入 Widget 自行定义）
/// - [showBack] 左侧未传插槽时，是否显示默认返回按钮（点击默认 Navigator.pop），默认 true
class CustomAppBar extends StatelessWidget {
  final String title;
  final double height;

  /// 左侧插槽：自定义 Widget，优先级高于默认返回按钮
  final Widget? leading;

  /// 右侧插槽：自定义 Widget（点击事件在 Widget 内部定义）
  final Widget? trailing;

  /// 未传入 [leading] 时，是否显示默认返回按钮
  final bool showBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.height = 44,
    this.leading,
    this.trailing,
    this.showBack = true,
  });

  /// 默认返回按钮（点击直接 pop，无需外部传回调）
  Widget _defaultBack(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      onPressed: () => Navigator.of(context).maybePop(),
      child: const Icon(CupertinoIcons.back, color: CupertinoColors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      // 背景图铺满整个导航栏区域（含状态栏）
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            // 知识点：Text(MediaQuery.of(context).platformBrightness.toString()) 这个是查询平台的，不是自己定义的
            CupertinoTheme.of(context).brightness == Brightness.dark
                ? 'assets/images/bg_black.jpg'
                : 'assets/images/bg.jpg',
          ),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      padding: EdgeInsets.only(top: safeTop),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            // Text(CupertinoTheme.of(context).brightness.toString()),
            // 左侧：插槽优先，否则按 showBack 显示默认返回
            leading ??
                (showBack ? _defaultBack(context) : const SizedBox.shrink()),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // 右侧：插槽（没有则不占位）
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
