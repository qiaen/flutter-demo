import 'package:flutter/cupertino.dart';
import '../../widgets/network_image_widget.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('用户详情')),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: 20 + bottomPadding),
          children: [
            // 顶部用户信息卡片
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: CupertinoColors.systemGrey5.resolveFrom(context),
                ),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: NetworkImageWidget(
                      src: 'https://picsum.photos/seed/avatar/200/200',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorIcon: CupertinoIcons.person_fill,
                      errorIconColor: CupertinoColors.systemGrey2,
                      errorIconSize: 36,
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
                  context: context,
                );
              }
              return _buildTextSection(
                section['title'] as String,
                section['body'] as String,
                context: context,
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection(
    String title,
    String body, {
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey5.resolveFrom(context),
        ),
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
            style: TextStyle(
              fontSize: 14,
              height: 1.7,
              // 知识点：如果TextStyle用了const，这里就不能变色，会报错
              color: CupertinoColors.systemGrey.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(
    String title,
    List<String> tags, {
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey5.resolveFrom(context),
        ),
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
