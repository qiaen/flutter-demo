import 'package:flutter/cupertino.dart';

import '../../services/storage.dart';
import '../../widgets/network_image_widget.dart';

/// 详情页相关常量与共享样式，集中管理避免散落重复
class _DetailStyle {
  static const double imageHeight = 250;
  static const double navBarHeight = 44;
  static const double horizontalPadding = 16;
  static const String favKeyPrefix = 'fav_'; // 收藏状态 key 前缀，后接 item 唯一 id

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle bodyText = TextStyle(
    fontSize: 15,
    height: 1.8,
    letterSpacing: 0.3,
  );
  static const TextStyle descText = TextStyle(
    fontSize: 16,
    color: CupertinoColors.systemGrey,
    height: 1.6,
  );
  static const TextStyle tipTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle tipDesc = TextStyle(
    fontSize: 13,
    color: CupertinoColors.systemGrey,
    height: 1.4,
  );
  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 12,
    color: CupertinoColors.systemGrey,
  );
  static const TextStyle actionLabel = TextStyle(fontSize: 11);
}

/// 顶部大图 + 悬浮标题（固定不随内容滚动变化，放在 SliverToBoxAdapter）
class _HeaderImage extends StatelessWidget {
  final String image;
  final String title;

  const _HeaderImage(this.image, this.title);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        NetworkImageWidget(
          src: image,
          width: double.infinity,
          height: _DetailStyle.imageHeight,
          fit: BoxFit.cover,
          cacheWidth: (MediaQuery.of(context).size.width * 3).round(),
        ),
        Container(
          width: double.infinity,
          height: _DetailStyle.imageHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.25),
                Color.fromRGBO(0, 0, 0, 0),
                Color.fromRGBO(0, 0, 0, 0.35),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            title,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// 顶部悬浮导航栏：背景/标题/图标随滚动进度过渡
/// 通过 ValueListenableBuilder 包裹，只有自身随进度重建，不影响正文
class _FloatingNavBar extends StatelessWidget {
  final String title;
  final ValueNotifier<double> progress;

  const _FloatingNavBar(this.title, this.progress);

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    return ValueListenableBuilder<double>(
      valueListenable: progress,
      builder: (context, p, _) {
        final iconColor = p > 0.5
            ? CupertinoColors.label
            : CupertinoColors.white;
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: CupertinoColors.systemBackground.withValues(alpha: p),
            padding: EdgeInsets.only(top: safeTop),
            child: SizedBox(
              height: _DetailStyle.navBarHeight,
              child: Row(
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Icon(CupertinoIcons.back, color: iconColor),
                  ),
                  Expanded(
                    child: Center(
                      child: Opacity(
                        opacity: p,
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: CupertinoColors.label,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () => debugPrint('编辑'),
                    child: Icon(CupertinoIcons.pencil, color: iconColor),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.only(right: 12, left: 4),
                    onPressed: () => debugPrint('更多'),
                    child: Icon(
                      CupertinoIcons.ellipsis_vertical,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 正文段落卡片
class _RichSection extends StatelessWidget {
  final Map<String, String> section;

  const _RichSection(this.section);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _DetailStyle.horizontalPadding,
          ),
          child: Text(section['title']!, style: _DetailStyle.sectionTitle),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _DetailStyle.horizontalPadding,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: NetworkImageWidget(
              src: section['image']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              cacheWidth: (MediaQuery.of(context).size.width * 3).round(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _DetailStyle.horizontalPadding,
          ),
          child: Text(section['body']!, style: _DetailStyle.bodyText),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _DetailStyle.horizontalPadding,
          ),
          child: Container(height: 1, color: CupertinoColors.systemGrey5),
        ),
      ],
    );
  }
}

/// 实用贴士卡片
class _TipCard extends StatelessWidget {
  final Map<String, dynamic> tip;

  const _TipCard(this.tip);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color.fromARGB(25, 0, 122, 255),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              tip['icon'] as IconData,
              size: 18,
              color: CupertinoColors.activeBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip['title'] as String, style: _DetailStyle.tipTitle),
                const SizedBox(height: 4),
                Text(tip['desc'] as String, style: _DetailStyle.tipDesc),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 相关推荐横向卡片
class _RecommendCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const _RecommendCard(this.image, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: NetworkImageWidget(
              src: image,
              width: 150,
              height: 100,
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
                  title,
                  style: _DetailStyle.cardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: _DetailStyle.cardSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 用户评论卡片
class _CommentCard extends StatelessWidget {
  final Map<String, String> comment;

  const _CommentCard(this.comment);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: NetworkImageWidget(
              src: comment['avatar']!,
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
                    Text(
                      comment['name']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment['time']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment['content']!,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(
                      CupertinoIcons.heart,
                      size: 14,
                      color: CupertinoColors.systemGrey3,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '12',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey3,
                      ),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      CupertinoIcons.chat_bubble,
                      size: 14,
                      color: CupertinoColors.systemGrey3,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '回复',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 收藏/评论/分享操作按钮
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _ActionButton(
    this.icon,
    this.label,
    this.onTap, {
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? CupertinoColors.systemRed
        : CupertinoColors.systemGrey;
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(
            isActive ? CupertinoIcons.heart_fill : icon,
            size: 22,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(label, style: _DetailStyle.actionLabel.copyWith(color: color)),
        ],
      ),
    );
  }
}

class HomeDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const HomeDetailPage({super.key, required this.item});

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  bool isFavorited = false;

  final ScrollController _scrollController = ScrollController();
  // 滚动进度通知器：导航栏只监听它，正文不参与重建
  final ValueNotifier<double> _scrollProgress = ValueNotifier<double>(0);

  // 用于生成收藏 key 的唯一标识
  String get _favKey =>
      _DetailStyle.favKeyPrefix +
      (widget.item['id'] ?? widget.item['title']).toString();

  // 模拟富文本段落，用于测试长页面滚动
  static const List<Map<String, String>> _richSections = [
    {
      'title': '探索之旅',
      'image': 'https://picsum.photos/seed/travel1/800/400',
      'body':
          '城市不仅仅是钢筋水泥的丛林，更是一本厚重的历史书。每一条老街巷弄，每一座古老建筑，都在默默诉说着这座城市的前世今生。漫步其中，仿佛穿越时空，与历史对话。\n\n'
          '在这个快节奏的时代，我们常常忽略了身边的美好。放慢脚步，用心感受，你会发现城市的每一个角落都藏着惊喜。从清晨第一缕阳光洒在老城墙上的温柔，到傍晚时分巷口飘来的饭菜香，这些都是城市最真实、最动人的风景。',
    },
    {
      'title': '文化底蕴',
      'image': 'https://picsum.photos/seed/culture/800/400',
      'body':
          '每座城市都有自己独特的文化基因。这些基因深藏在当地人的生活方式、饮食习惯、方言俚语之中。走进当地的菜市场，你会看到最鲜活的城市面貌；坐下来喝一碗地道的小吃，你能品尝到这座城市最本真的味道。\n\n'
          '非物质文化遗产是城市的灵魂。那些代代相传的手艺、节日庆典、民间艺术，都承载着先辈们的智慧与情感。保护这些珍贵的文化遗产，就是在守护我们共同的精神家园。',
    },
    {
      'title': '建筑之美',
      'image': 'https://picsum.photos/seed/arch/800/400',
      'body':
          '建筑是凝固的音乐，也是城市的名片。从古典园林的曲径通幽，到现代摩天大楼的直冲云霄，建筑风格的变迁记录着城市的发展轨迹。中西合璧的老洋房、青砖灰瓦的四合院、充满设计感的文创园区，每一处都是建筑美学的绝佳范本。\n\n'
          '不妨拿起相机，用镜头捕捉那些被忽略的建筑细节——精美的雕花窗棂、斑驳的红砖墙面、充满几何美感的楼梯结构。你会发现，原来身边的建筑如此迷人。',
    },
    {
      'title': '美食地图',
      'image': 'https://picsum.photos/seed/food1/800/400',
      'body':
          '一方水土养一方人，一座城市的美食最能体现其风土人情。从百年老字号到网红新店，从街头小摊到米其林餐厅，每一道菜背后都有故事。\n\n'
          '清晨的一碗热腾腾的豆浆油条、午后的一杯手冲咖啡、深夜的一串炭火烧烤，这些看似平凡的日常，却是城市生活中最温暖的慰藉。带上这份美食地图，开启一场舌尖上的城市之旅吧。',
    },
    {
      'title': '艺术空间',
      'image': 'https://picsum.photos/seed/art1/800/400',
      'body':
          '当代艺术正在悄然改变城市的面貌。废弃的工厂变身为创意园区，老旧的地下空间成为独立书店和画廊，甚至连街角的墙壁都成为了街头艺术家的画布。\n\n'
          '美术馆、博物馆、Livehouse、小剧场……这些文化空间为城市注入了源源不断的活力。在这里，你可以与艺术零距离接触，感受创作者的心跳与呼吸。',
    },
    {
      'title': '自然绿洲',
      'image': 'https://picsum.photos/seed/nature1/800/400',
      'body':
          '在钢筋水泥的包围中，一片绿地就是城市的肺。无论是市中心的人民公园，还是郊外的湿地保护区，这些自然空间为都市人提供了休憩放松的场所。\n\n'
          '春天看樱花烂漫，夏天听蝉鸣阵阵，秋天赏银杏金黄，冬天寻腊梅幽香。四季更替，大自然用它的方式提醒着我们：生活的美好，往往就在身边。',
    },
  ];

  static const List<Map<String, dynamic>> _tips = [
    {
      'icon': CupertinoIcons.map_fill,
      'title': '交通攻略',
      'desc': '建议乘坐地铁2号线至市中心站，从A口出步行约5分钟即可到达。周边有多条公交线路可达，自驾请导航至附近停车场。',
    },
    {
      'icon': CupertinoIcons.clock_fill,
      'title': '最佳时间',
      'desc': '春秋两季气候宜人，是最佳的游览季节。早晨8-10点光线柔和，非常适合拍照。避开节假日高峰时段，可以获得更好的体验。',
    },
    {
      'icon': CupertinoIcons.money_dollar_circle_fill,
      'title': '费用参考',
      'desc': '大部分景点免费开放，部分特色展馆门票20-50元不等。周边餐饮人均消费30-80元，建议预留充足预算品尝当地美食。',
    },
    {
      'icon': CupertinoIcons.camera_fill,
      'title': '拍照建议',
      'desc': '清晨和黄昏的黄金时刻最适合拍摄。携带广角镜头可以捕捉更多建筑细节，定焦大光圈镜头则适合人像和特写。',
    },
  ];

  static const List<Map<String, String>> _comments = [
    {
      'avatar': 'https://picsum.photos/seed/user1/100/100',
      'name': '旅行达人小王',
      'time': '2天前',
      'content': '非常详细的攻略！上周末刚去了推荐的那条老街，真的是别有洞天，拍了好多好看的照片。',
    },
    {
      'avatar': 'https://picsum.photos/seed/user2/100/100',
      'name': '摄影爱好者',
      'time': '3天前',
      'content': '建筑那一节写得太好了，作为一个建筑摄影爱好者，这些地方我一个都不会错过！',
    },
    {
      'avatar': 'https://picsum.photos/seed/user3/100/100',
      'name': '美食猎人',
      'time': '5天前',
      'content': '照着美食地图吃了一圈，没有踩雷的！特别是那家藏在巷子里的老店，味道绝了。',
    },
    {
      'avatar': 'https://picsum.photos/seed/user4/100/100',
      'name': '城市探索者',
      'time': '1周前',
      'content': '在这座城市生活了十年，看了这篇文章才发现还有这么多没去过的地方。感谢分享！',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadFavorite();
  }

  void _onScroll() {
    final safeTop = MediaQuery.of(context).padding.top;
    final threshold =
        _DetailStyle.imageHeight - _DetailStyle.navBarHeight - safeTop;
    final p = threshold <= 0
        ? 1.0
        : (_scrollController.offset / threshold).clamp(0.0, 1.0);
    // 进度无变化时跳过通知，进一步减少无效重建
    if ((_scrollProgress.value - p).abs() > 0.01) {
      _scrollProgress.value = p;
    }
  }

  /// 进入页面读取收藏状态
  Future<void> _loadFavorite() async {
    final saved = await LocalStorage.get<bool>(
      _favKey,
      fromJson: (e) => e as bool,
    );
    if (saved != null && mounted) {
      setState(() => isFavorited = saved);
    }
  }

  /// 切换收藏并持久化
  Future<void> _toggleFavorite() async {
    final next = !isFavorited;
    setState(() => isFavorited = next);
    await LocalStorage.set(_favKey, next);
    debugPrint(next ? '收藏' : '取消收藏');
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.item['title'] as String;

    return CupertinoPageScaffold(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // 顶部大图 + 悬浮标题（独立 Sliver）
                SliverToBoxAdapter(
                  child: _HeaderImage(widget.item['image'] as String, title),
                ),

                // 描述 + 分割线（独立 Sliver）
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _DetailStyle.horizontalPadding,
                        ),
                        child: Text(
                          widget.item['desc'] as String,
                          style: _DetailStyle.descText,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(height: 1, color: CupertinoColors.systemGrey5),
                    ],
                  ),
                ),

                // 正文段落列表（独立 SliverList，按需构建）
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _RichSection(_richSections[index]),
                    childCount: _richSections.length,
                  ),
                ),

                // 实用贴士
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Container(height: 8, color: CupertinoColors.systemGrey6),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _DetailStyle.horizontalPadding,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '实用贴士',
                              style: _DetailStyle.sectionTitle,
                            ),
                            const SizedBox(height: 16),
                            ..._tips.map((tip) => _TipCard(tip)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 相关推荐（横向滚动独立 Sliver）
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 8, color: CupertinoColors.systemGrey6),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: _DetailStyle.horizontalPadding,
                              ),
                              child: Text(
                                '相关推荐',
                                style: _DetailStyle.sectionTitle,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 170,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 6,
                                ),
                                children: const [
                                  _RecommendCard(
                                    'https://picsum.photos/seed/rec1/300/200',
                                    '周末徒步路线',
                                    '5条精选路线',
                                  ),
                                  _RecommendCard(
                                    'https://picsum.photos/seed/rec2/300/200',
                                    '城市咖啡馆',
                                    '10家必打卡',
                                  ),
                                  _RecommendCard(
                                    'https://picsum.photos/seed/rec3/300/200',
                                    '博物馆巡礼',
                                    '文化之旅',
                                  ),
                                  _RecommendCard(
                                    'https://picsum.photos/seed/rec4/300/200',
                                    '夜市美食攻略',
                                    '吃货必看',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 用户评论
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 8, color: CupertinoColors.systemGrey6),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _DetailStyle.horizontalPadding,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('热门评论', style: _DetailStyle.sectionTitle),
                                Text(
                                  '查看全部 >',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ..._comments.map((c) => _CommentCard(c)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 底部操作
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(height: 1, color: CupertinoColors.systemGrey5),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            _ActionButton(
                              CupertinoIcons.heart,
                              '收藏',
                              _toggleFavorite,
                              isActive: isFavorited,
                            ),
                            const SizedBox(width: 24),
                            _ActionButton(
                              CupertinoIcons.chat_bubble,
                              '评论',
                              () => debugPrint('评论'),
                            ),
                            const SizedBox(width: 24),
                            _ActionButton(
                              CupertinoIcons.share,
                              '分享',
                              () => debugPrint('分享'),
                            ),
                            const Spacer(),
                            CupertinoButton.filled(
                              onPressed: () {},
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              child: const Text('开始探索'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom, // 自动读取距离底部的高度，比设置安全距离好点，安全距离底部会留padding，导致滚动不到
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 悬浮导航栏：监听滚动进度，仅自身重建
            _FloatingNavBar(title, _scrollProgress),
          ],
        ),
      ),
    );
  }
}
