import 'package:flutter/cupertino.dart';

import '../../widgets/network_image_widget.dart';

/// 详情页常量与文本样式集中管理
class _DetailTokens {
  static const double headerHeight = 320; // 顶部大图区域高度
  static const double navBarHeight = 44; // 顶部导航条高度
  static const double horizontalPadding = 20;

  static const TextStyle heroTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: CupertinoColors.white,
    letterSpacing: 0.2,
    height: 1.2,
  );
  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 15,
    color: CupertinoColors.white,
    height: 1.4,
  );
  static const TextStyle navTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.label,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: CupertinoColors.label,
    letterSpacing: 0.2,
  );
  static const TextStyle paragraph = TextStyle(
    fontSize: 15,
    height: 1.7,
    color: CupertinoColors.label,
    letterSpacing: 0.2,
  );
  static const TextStyle metaLabel = TextStyle(
    fontSize: 12,
    color: CupertinoColors.systemGrey,
    letterSpacing: 0.3,
  );
  static const TextStyle metaValue = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.label,
  );
  static const TextStyle quoteText = TextStyle(
    fontSize: 16,
    height: 1.6,
    fontStyle: FontStyle.italic,
    color: CupertinoColors.label,
  );
}

/// 详情页接收的数据
class HomeDetailItem {
  final String title;
  final String subtitle;
  final String desc;
  final String image;
  final Color tint;

  HomeDetailItem({
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.image,
    required this.tint,
  });

  factory HomeDetailItem.fromMap(Map<String, dynamic> map) {
    return HomeDetailItem(
      title: (map['title'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? '').toString(),
      desc: (map['desc'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      tint: map['tint'] is Color
          ? map['tint'] as Color
          : const Color(0xFFFF6B6B),
    );
  }
}

class HomeDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const HomeDetailPage({super.key, required this.item});

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _bgAnimController;
  late final HomeDetailItem _item;

  /// 0.0 表示完全透明（顶部），1.0 表示完全不透明（已完全滚动到图片下方）
  double _scrollProgress = 0;

  @override
  void initState() {
    super.initState();
    _item = HomeDetailItem.fromMap(widget.item);
    _scrollController = ScrollController()..addListener(_handleScroll);
    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _bgAnimController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final safeTop = MediaQuery.of(context).padding.top;
    final range =
        _DetailTokens.headerHeight - _DetailTokens.navBarHeight - safeTop;
    final raw = range <= 0 ? 1.0 : _scrollController.offset / range;
    final next = raw.clamp(0.0, 1.0);
    if ((next - _scrollProgress).abs() < 0.005) return;
    setState(() => _scrollProgress = next);
  }

  // ============================================================
  // 顶部大图 + 悬浮标题
  // ============================================================
  Widget _buildHeader() {
    return SizedBox(
      height: _DetailTokens.headerHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 底层图片
          NetworkImageWidget(
            src: _item.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: _DetailTokens.headerHeight,
            cacheWidth: (MediaQuery.of(context).size.width * 3).round(),
            placeholderColor: _item.tint,
          ),
          // 顶部黑色渐变阴影：用于保护返回/编辑/更多图标以及标题的可读性
          // 即使图源是浅色也能看清
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 140,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CupertinoColors.black.withValues(alpha: 0.55),
                    CupertinoColors.black.withValues(alpha: 0.25),
                    CupertinoColors.black.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // 底部黑色渐变阴影：保护底部悬浮标题文字
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    CupertinoColors.black.withValues(alpha: 0.7),
                    CupertinoColors.black.withValues(alpha: 0.3),
                    CupertinoColors.black.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          // 悬浮标题：左下角
          Positioned(
            left: _DetailTokens.horizontalPadding,
            right: _DetailTokens.horizontalPadding,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: CupertinoColors.white.withValues(alpha: 0.35),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    '发现 · 城市秘境',
                    style: _DetailTokens.heroSubtitle.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(_item.title, style: _DetailTokens.heroTitle),
                if (_item.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(_item.subtitle, style: _DetailTokens.heroSubtitle),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 顶部悬浮导航（透明 → 滚动后渐变白色）
  // ============================================================
  Widget _buildFloatingNavBar() {
    final safeTop = MediaQuery.of(context).padding.top;
    // 图标颜色：滚动过半切换为深色，保证在白色背景上可读
    final iconColor = Color.lerp(
      CupertinoColors.white,
      CupertinoColors.label,
      _scrollProgress,
    )!;
    // 标题透明度：滚动后渐显
    final titleOpacity = _scrollProgress;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.withValues(
            alpha: _scrollProgress,
          ),
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.systemGrey5.withValues(
                alpha: _scrollProgress * 0.6,
              ),
              width: 0.5,
            ),
          ),
        ),
        padding: EdgeInsets.only(top: safeTop),
        child: SizedBox(
          height: _DetailTokens.navBarHeight,
          child: Row(
            children: [
              _NavBarButton(
                icon: CupertinoIcons.back,
                color: iconColor,
                onTap: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: Center(
                  child: Opacity(
                    opacity: titleOpacity,
                    child: Text(
                      _item.title,
                      style: _DetailTokens.navTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              _NavBarButton(
                icon: CupertinoIcons.pencil,
                color: iconColor,
                onTap: () {
                  // 编辑
                },
              ),
              _NavBarButton(
                icon: CupertinoIcons.ellipsis,
                color: iconColor,
                padding: const EdgeInsets.only(right: 12, left: 4),
                onTap: () {
                  // 更多
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 正文：简短分段，保证可滚动测试即可
  // ============================================================
  Widget _buildBody() {
    final meta = _buildMetaRow();
    final paragraphs = _buildParagraphs();
    final quote = _buildQuote();

    return Container(
      color: CupertinoColors.systemBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: _DetailTokens.horizontalPadding,
      ).copyWith(top: 22, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 描述
          Text(_item.desc, style: _DetailTokens.paragraph),
          const SizedBox(height: 20),

          // 元信息（标签）
          meta,
          const SizedBox(height: 24),

          // 标题
          Text('关于这场旅程', style: _DetailTokens.sectionTitle),
          const SizedBox(height: 12),
          ...paragraphs,
          const SizedBox(height: 8),

          // 图文段落一
          ..._buildImageBlock(
            image: 'https://picsum.photos/seed/detail1/1200/640',
            caption: '老巷口的暖光',
            text: '午后的阳光从梧桐叶的缝隙里漏下来，在老巷的青石板上碎成一地光斑。巷口的糖水铺子支起招牌，锅里的热气慢悠悠地升腾，把整个街角都熏得温柔。',
          ),
          const SizedBox(height: 8),

          // 图文段落二
          ..._buildImageBlock(
            image: 'https://picsum.photos/seed/detail2/1200/640',
            caption: '屋顶花园',
            text: '沿着狭窄的楼梯往上，一扇不起眼的铁门后面，竟藏着一整片屋顶花园。番茄、薄荷与月季挤在旧木箱里，城市的喧嚣在这里被推得很远很远。',
          ),
          const SizedBox(height: 24),
          quote,
          const SizedBox(height: 8),
          _buildAuthor(),
          const SizedBox(height: 32),

          // 折叠说明
          _buildCollapsible(),
        ],
      ),
    );
  }

  Widget _buildMetaRow() {
    final entries = const [
      ('时长', '约 3 小时'),
      ('难度', '★☆☆☆☆'),
      ('适合', '亲子 / 朋友'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entries[i].$1, style: _DetailTokens.metaLabel),
                  const SizedBox(height: 4),
                  Text(entries[i].$2, style: _DetailTokens.metaValue),
                ],
              ),
            ),
            if (i != entries.length - 1)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 1,
                  height: 28,
                  color: CupertinoColors.systemGrey4,
                ),
              ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildParagraphs() {
    final texts = const [
      '步入老城的小巷，光线在青砖上慢慢褪去，脚步声被两侧斑驳的墙面轻轻接住。每一处转角都可能藏着一家不起眼的小店、一面涂鸦、或者一段无人知晓的故事。',
      '城市的秘境往往不在地图上，而在愿意慢下来的人眼里。它们可能是屋顶上的菜园、狭窄弄堂尽头的老虎窗、或者某扇午后亮着暖光的门。',
      '建议选择一个晴朗的上午出发，带上一杯喜欢的饮品和一本小笔记，随手记录下让你心头一动的东西。结束时，你会发现这座城市比想象中更温柔。',
    ];
    return [
      for (final t in texts) ...[
        Text(t, style: _DetailTokens.paragraph),
        const SizedBox(height: 12),
      ],
    ];
  }

  /// 图文段落：圆角图片 + 图注 + 说明文字
  List<Widget> _buildImageBlock({
    required String image,
    required String caption,
    required String text,
  }) {
    return [
      ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: NetworkImageWidget(
          src: image,
          width: double.infinity,
          height: 190,
          fit: BoxFit.cover,
          cacheWidth: (MediaQuery.of(context).size.width * 3).round(),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        caption,
        style: _DetailTokens.metaLabel.copyWith(
          fontSize: 12,
          letterSpacing: 0.4,
        ),
      ),
      const SizedBox(height: 10),
      Text(text, style: _DetailTokens.paragraph),
    ];
  }

  Widget _buildQuote() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: _item.tint, width: 3)),
      ),
      child: Text(
        '“旅行不是为了赶路，而是为了在某个转角，重新认识自己与这座城市的关系。”',
        style: _DetailTokens.quoteText,
      ),
    );
  }

  Widget _buildAuthor() {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Text(
        '—— 编辑部',
        style: _DetailTokens.metaLabel.copyWith(letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildCollapsible() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.info_circle, color: _item.tint, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              '本页为示例页面，详细信息以后端接口返回为准。',
              style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: Stack(
        children: [
          // 内容滚动层
          Positioned.fill(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildBody()),
              ],
            ),
          ),
          // 悬浮导航
          _buildFloatingNavBar(),
        ],
      ),
    );
  }
}

/// 顶部导航栏按钮：保持 44pt 可点击区域，图标色按滚动进度变化
class _NavBarButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  const _NavBarButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding,
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Icon(icon, color: color, size: 22),
    );
  }
}
