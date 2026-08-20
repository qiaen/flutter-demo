import 'package:flutter/cupertino.dart';

/// 统一封装的网络图片组件。
///
/// 提供能力：
/// - 加载中占位（loading 态）
/// - 加载失败默认缺省图（errorBuilder 统一处理）
/// - 外部可传入 [src]、[width]、[height]、[fit]、[cacheWidth] 等参数
/// - 可选 [placeholderColor] 与 [errorIcon]，定制缺省图样式
///
/// 传入的 [width]/[height] 会同时作用于加载占位与失败缺省图，
/// 保证三种状态下尺寸一致，避免布局跳动。
class NetworkImageWidget extends StatelessWidget {
  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final int? cacheWidth;
  final Color? placeholderColor;
  final Color? errorIconColor;
  final double? errorIconSize;
  final IconData errorIcon;

  const NetworkImageWidget({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.placeholderColor,
    this.errorIconColor,
    this.errorIconSize,
    this.errorIcon = CupertinoIcons.photo,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = _buildPlaceholder();

    return Image.network(
      src,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      // 加载中先显示占位，避免空白闪烁
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder;
      },
      // 加载失败显示缺省图
      errorBuilder: (_, _, _) => placeholder,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: placeholderColor ?? CupertinoColors.systemGrey5,
      child: Center(
        child: Icon(
          errorIcon,
          size: errorIconSize ?? _defaultIconSize,
          color: errorIconColor ?? CupertinoColors.systemGrey3,
        ),
      ),
    );
  }

  double get _defaultIconSize {
    if (height != null && height! < 60) return height! * 0.6;
    if (width != null && width! < 60) return width! * 0.6;
    return 40;
  }
}
