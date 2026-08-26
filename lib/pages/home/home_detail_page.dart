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
  static const TextStyle tipTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.label,
  );
  static const TextStyle tipDesc = TextStyle(
    fontSize: 12,
    height: 1.4,
    color: CupertinoColors.systemGrey,
  );
  static const TextStyle recTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.label,
  );
  static const TextStyle recDesc = TextStyle(
    fontSize: 12,
    color: CupertinoColors.systemGrey,
  );
  static const TextStyle commentName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.label,
  );
  static const TextStyle commentTime = TextStyle(
    fontSize: 12,
    color: CupertinoColors.systemGrey,
  );
  static const TextStyle commentBody = TextStyle(
    fontSize: 14,
    height: 1.55,
    color: CupertinoColors.label,
  );
  static const TextStyle commentAction = TextStyle(
    fontSize: 11,
    color: CupertinoColors.systemGrey,
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
        // horizontal: _DetailTokens.horizontalPadding,
      ).copyWith(top: 22, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _DetailTokens.horizontalPadding,
            ),
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
                  text:
                      '午后的阳光从梧桐叶的缝隙里漏下来，在老巷的青石板上碎成一地光斑。巷口的糖水铺子支起招牌，锅里的热气慢悠悠地升腾，把整个街角都熏得温柔。',
                ),
                const SizedBox(height: 8),

                // 图文段落二
                ..._buildImageBlock(
                  image: 'https://picsum.photos/seed/detail2/1200/640',
                  caption: '屋顶花园',
                  text:
                      '沿着狭窄的楼梯往上，一扇不起眼的铁门后面，竟藏着一整片屋顶花园。番茄、薄荷与月季挤在旧木箱里，城市的喧嚣在这里被推得很远很远。',
                ),
                const SizedBox(height: 24),
                quote,
                const SizedBox(height: 8),
                _buildAuthor(),
                const SizedBox(height: 32),

                // 折叠说明
                _buildCollapsible(),
                const SizedBox(height: 28),

                // 实用贴士
                _buildTips(),
                const SizedBox(height: 28),
              ],
            ),
          ),

          // 相关推介
          _buildRecommendations(),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsetsGeometry.symmetric(
              horizontal: _DetailTokens.horizontalPadding,
            ),
            child:
                // 热门评论
                _buildComments(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ============================================================
  // 实用贴士模块
  // ============================================================
  Widget _buildTips() {
    const tips = [
      (
        icon: CupertinoIcons.tram_fill,
        title: '交通攻略',
        desc: '建议乘坐地铁2号线至市中心站，从A口出步行约5分钟即可到达。周边有多条公交线路可达，自驾请导航至附近停车场。',
      ),
      (
        icon: CupertinoIcons.clock_fill,
        title: '最佳时间',
        desc: '春秋两季气候宜人，是最佳的游览季节。早晨8-10点光线柔和，非常适合拍照。避开节假日高峰时段，可以获得更好的体验。',
      ),
      (
        icon: CupertinoIcons.money_dollar_circle_fill,
        title: '费用参考',
        desc: '大部分景点免费开放，部分特色展馆门票20-50元不等。周边餐饮人均消费30-80元，建议预留充足预算品尝当地美食。',
      ),
      (
        icon: CupertinoIcons.camera_fill,
        title: '拍照建议',
        desc: '清晨和黄昏的黄金时刻最适合拍摄。携带广角镜头可以捕捉更多建筑细节，定焦大光圈镜头则适合人像和特写。',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('实用贴士', style: _DetailTokens.sectionTitle),
            Icon(
              CupertinoIcons.sparkles,
              size: 18,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (final tip in tips) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _item.tint.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tip.icon, size: 18, color: _item.tint),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tip.title, style: _DetailTokens.tipTitle),
                      const SizedBox(height: 4),
                      Text(tip.desc, style: _DetailTokens.tipDesc),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  // ============================================================
  // 相关推介模块（横向滚动）
  // ============================================================
  Widget _buildRecommendations() {
    const recs = [
      (
        image: 'https://picsum.photos/seed/rec1/600/400',
        title: '周末徒步路线',
        desc: '5 条精选线路',
      ),
      (
        image: 'https://picsum.photos/seed/rec2/600/400',
        title: '城市咖啡馆',
        desc: '10 家必打卡',
      ),
      (
        image: 'https://picsum.photos/seed/rec3/600/400',
        title: '博物馆巡礼',
        desc: '文化之旅',
      ),
      (
        image: 'https://picsum.photos/seed/rec4/600/400',
        title: '夜市美食攻略',
        desc: '吃货必看',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            horizontal: _DetailTokens.horizontalPadding,
          ),
          child: const Text('相关推介', style: _DetailTokens.sectionTitle),
        ),

        const SizedBox(height: 14),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final rec = recs[index];

              // 判断第一个和最后一个
              final isFirst = index == 0;
              final isLast = index == recs.length - 1;

              return Padding(
                padding: EdgeInsets.only(
                  left: isFirst ? 16 : 0,
                  right: isLast ? 16 : 0,
                ),
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: NetworkImageWidget(
                          src: rec.image,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          cacheWidth: 450,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rec.title,
                              style: _DetailTokens.recTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(rec.desc, style: _DetailTokens.recDesc),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 热门评论模块
  // ============================================================
  Widget _buildComments() {
    const comments = [
      (
        name: '旅行达人小王',
        time: '2天前',
        content: '非常详细的攻略！上周末刚去了推荐的那条老街，真的是别有洞天，拍了好多好看的照片。',
        likes: 12,
      ),
      (
        name: '摄影爱好者',
        time: '3天前',
        content: '建筑那一节写得太好了，作为一个建筑摄影爱好者，这些地方我一个都不会错过！',
        likes: 8,
      ),
      (
        name: '美食猎人',
        time: '5天前',
        content: '照着美食地图吃了一圈，没有踩雷的！特别是那家藏在巷子里的老店，味道绝了。',
        likes: 5,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('热门评论', style: _DetailTokens.sectionTitle),
            Text(
              '查看全部 >',
              style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (final c in comments) ...[
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像（随机 seed）
              ClipOval(
                child: NetworkImageWidget(
                  src: 'https://picsum.photos/seed/${c.name}/100/100',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  cacheWidth: 120,
                  errorIcon: CupertinoIcons.person_fill,
                  errorIconSize: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(c.name, style: _DetailTokens.commentName),
                        const SizedBox(width: 8),
                        Text(c.time, style: _DetailTokens.commentTime),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(c.content, style: _DetailTokens.commentBody),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.heart,
                          size: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                        const SizedBox(width: 3),
                        Text('${c.likes}', style: _DetailTokens.commentAction),
                        const SizedBox(width: 16),
                        const Icon(
                          CupertinoIcons.chat_bubble,
                          size: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                        const SizedBox(width: 3),
                        const Text('回复', style: _DetailTokens.commentAction),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (c != comments.last)
            Container(
              margin: const EdgeInsets.only(top: 14),
              height: 1,
              color: CupertinoColors.systemGrey5,
            ),
        ],
      ],
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
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            // 内容 + 固定底部操作栏
            Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildHeader()),
                      SliverToBoxAdapter(child: _buildBody()),
                    ],
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
            // 悬浮导航
            _buildFloatingNavBar(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 底部固定操作栏
  // ============================================================
  Widget _buildBottomBar() {
    var bottomInset = MediaQuery.of(context).padding.bottom;
    bottomInset = bottomInset == 0.0 ? 10 : bottomInset;
    return Container(
      padding: EdgeInsets.only(
        left: _DetailTokens.horizontalPadding,
        right: _DetailTokens.horizontalPadding,
        top: 10,
        // bottom: bottomInset,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _BottomAction(
            icon: CupertinoIcons.heart,
            label: '点赞',
            color: CupertinoColors.systemRed,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _BottomAction(
            icon: CupertinoIcons.chat_bubble,
            label: '评论',
            color: CupertinoColors.activeBlue,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _BottomAction(
            icon: CupertinoIcons.share,
            label: '分享',
            color: CupertinoColors.activeGreen,
            onTap: () {},
          ),
          const Spacer(),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            minimumSize: Size.zero,
            borderRadius: BorderRadius.circular(6),
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text(
              '返回',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部操作按钮：图标 + 文字（纵向排布）
class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: CupertinoColors.systemGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
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
