import 'package:flutter/cupertino.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSizeChanged);
  }

  void _onSizeChanged() {
    if (_sheetController.size == 0) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _sheetController
      ..removeListener(_onSizeChanged)
      ..dispose();
    super.dispose();
  }

  static const List<Map<String, dynamic>> _detailSections = [
    {
      'title': '个人简介',
      'body':
          '热爱生活、热爱技术的 Flutter 开发者。喜欢探索城市角落，用代码和镜头记录世界。相信技术可以改变生活，也相信生活中的每一处风景都值得被珍藏。\n\n'
          '目前在从事移动端开发工作，业余时间喜欢旅行、摄影和美食探店。希望能通过这个平台结识更多志同道合的朋友。',
    },
    {
      'title': '职业经历',
      'body':
          '2020 年毕业于某高校计算机科学专业，毕业后加入某互联网公司担任移动端开发工程师。主要负责 iOS 和 Flutter 跨平台应用的架构设计与开发。\n\n'
          '参与过多个大型项目的研发，涵盖社交、电商、工具等多个领域。对用户体验有深刻的理解，追求极致的产品细节。',
    },
    {
      'title': '技能标签',
      'tags': [
        'Flutter',
        'iOS',
        'Swift',
        'Dart',
        'React Native',
        'UI/UX 设计',
        '产品思维',
        '团队协作',
        '敏捷开发',
      ],
    },
    {
      'title': '兴趣爱好',
      'body':
          '摄影：喜欢街拍和建筑摄影，用镜头捕捉城市的灵魂。\n'
          '旅行：已走过 20+ 个城市，下一个目标是环游日本。\n'
          '美食：不折不扣的吃货，愿意为一碗地道小吃排队两小时。\n'
          '阅读：偏爱人文社科类书籍，每月至少读完一本。',
    },
    {
      'title': '联系方式',
      'body':
          '邮箱：flutter_dev@example.com\n'
          'GitHub：github.com/flutter-lover\n'
          '个人网站：www.flutterlover.dev\n'
          '所在地：中国 · 上海',
    },
    {
      'title': '最近动态',
      'body':
          '📌 刚刚打卡了一家隐藏在老城区的咖啡馆，环境超赞！\n'
          '📌 正在学习 SwiftUI，准备写一篇对比 Flutter 的深度文章。\n'
          '📌 计划下个月去杭州徒步，有一起的小伙伴吗？\n'
          '📌 开源项目 Star 数突破 500，感谢大家的支持！',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // 1. 获取屏幕总高度
    final screenHeight = MediaQuery.of(context).size.height;

    // 2. 获取顶部安全区高度（即状态栏高度，通常在 44dp ~ 59dp 之间）
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // 3. iOS 标准导航栏高度固定为 44dp
    // const navigationBarHeight = 44.0;

    // 4. 计算非滚动区域（状态栏 + 导航栏）占全屏的比例，这里改了，
    // statusBarHeight不再+navigationBarHeight高度了
    final topBarRatio = (statusBarHeight) / screenHeight;

    // 5. 最终完美贴合的初始高度比例：1.0 减去顶栏比例
    final perfectInitialSize = 1.0 - topBarRatio;

    debugPrint('========== UserDetailPage 高度调试 ==========');
    debugPrint('screenHeight:        $screenHeight');
    debugPrint('statusBarHeight:     $statusBarHeight');
    // debugPrint('navigationBarHeight: $navigationBarHeight');
    debugPrint('topBarRatio:         $topBarRatio');
    debugPrint('perfectInitialSize:  $perfectInitialSize');
    debugPrint('父容器可用高度:       ${screenHeight - statusBarHeight}');
    debugPrint('sheet实际像素高度:    ${(screenHeight - statusBarHeight) * perfectInitialSize}');
    // debugPrint('期望像素高度:         ${screenHeight - statusBarHeight - navigationBarHeight}');
    debugPrint('==============================================');
    
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: perfectInitialSize,
        minChildSize: 0.0,
        maxChildSize: perfectInitialSize,
        expand: false,
        snap: true, // 1. 开启“吸附/回弹”功能
        snapSizes: [
          0.0,
          perfectInitialSize,
        ], // 2. 定义吸附锚点（必须包含 min 和 max 的值）
        builder: (ctx, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '用户详情',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 1,
                  color: CupertinoColors.systemGrey5,
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.only(bottom: 20 + bottomPadding),
                    children: [
                      // 顶部用户信息卡片
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: CupertinoColors.systemGrey5,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                'https://picsum.photos/seed/avatar/200/200',
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 64,
                                  height: 64,
                                  color: CupertinoColors.systemGrey5,
                                  child: const Icon(
                                    CupertinoIcons.person_fill,
                                    size: 36,
                                    color: CupertinoColors.systemGrey2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '用户名',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Flutter 爱好者 · 上海',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      _buildMiniStat('128', '关注'),
                                      const SizedBox(width: 20),
                                      _buildMiniStat('36', '粉丝'),
                                      const SizedBox(width: 20),
                                      _buildMiniStat('52', '收藏'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 详情段落
                      ..._detailSections.map((section) {
                        if (section.containsKey('tags')) {
                          return _buildTagsSection(
                            section['title'] as String,
                            section['tags'] as List<String>,
                          );
                        }
                        return _buildTextSection(
                          section['title'] as String,
                          section['body'] as String,
                        );
                      }),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextSection(String title, String body) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
              color: CupertinoColors.darkBackgroundGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(String title, List<String> tags) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(25, 0, 122, 255),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String count, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }
}
