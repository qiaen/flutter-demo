import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// 统一封装的网络图片组件。
///
/// 提供能力：
/// - 加载中占位（loading 态）
/// - 加载失败默认缺省图（errorBuilder / errorWidget 统一处理）
/// - 外部可传入 [src]、[width]、[height]、[fit]、[cacheWidth] 等参数
/// - 可选 [placeholderColor] 与 [errorIcon]，定制缺省图样式
/// - 图片直接显示，不做淡入渐显过渡
///
/// ## 缓存策略
/// - **移动端（Android/iOS）**：使用 `cached_network_image` 做磁盘持久缓存，
///   图片加载成功后写入本地磁盘，App 重启后直接读缓存，避免重复从网络加载。
/// - **Web 端（Chrome 等）**：回退到 `Image.network`，借助浏览器自带的 HTTP
///   缓存实现本地复用（`cached_network_image` 在 Web 的缓存管理器不可靠，
///   且可能引发二次访问图片不显示的问题）。
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
    if (kIsWeb) {
      // Web 端：浏览器自带 HTTP 磁盘缓存，避免 cached_network_image 在 Web 上的缓存异常
      return Image.network(
        src,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        // 加载中先显示占位，避免空白闪烁
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
        // 加载失败显示缺省图
        errorBuilder: (_, _, _) => _buildPlaceholder(),
      );
    }

    // 移动端：磁盘持久缓存
    return CachedNetworkImage(
      imageUrl: src,
      width: width,
      height: height,
      fit: fit,
      // 控制解码内存宽度，与 Image.network 的 cacheWidth 语义一致，做参数映射
      memCacheWidth: cacheWidth,
      // 关闭默认淡入渐显，图片加载完成后直接显示
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) => _buildPlaceholder(),
      errorWidget: (_, _, _) => _buildPlaceholder(),
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
