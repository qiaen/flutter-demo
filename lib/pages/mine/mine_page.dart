import 'package:flutter/cupertino.dart';
import '../../widgets/network_image_widget.dart';
import 'user_detail_page.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Mine'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // 头像区域
            Center(
              child: GestureDetector(
                onTap: () {
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (_) => const UserDetailPage(),
                  );
                },
                child: const Column(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipOval(
                        child: _UserAvatar(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '用户名',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Flutter 爱好者',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 统计数据
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _StatItem(count: '128', label: '关注'),
                  _StatItem(count: '36', label: '粉丝'),
                  _StatItem(count: '52', label: '收藏'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 菜单列表
            _buildSection(
              children: [
                _buildMenuRow(CupertinoIcons.person_2_fill, '个人信息'),
                _buildMenuRow(CupertinoIcons.settings_solid, '设置'),
                _buildMenuRow(CupertinoIcons.bell_solid, '消息通知'),
              ],
            ),
            const SizedBox(height: 12),
            _buildSection(
              children: [
                _buildMenuRow(CupertinoIcons.heart_solid, '我的收藏'),
                _buildMenuRow(CupertinoIcons.clock_solid, '浏览历史'),
                _buildMenuRow(CupertinoIcons.share_solid, '分享给朋友'),
              ],
            ),
            const SizedBox(height: 12),
            _buildSection(
              children: [
                _buildMenuRow(CupertinoIcons.info, '关于我们'),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuRow(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: CupertinoColors.activeBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: CupertinoColors.systemGrey3,
          ),
        ],
      ),
    );
  }
}

// ---------- 用户头像 ----------
class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return NetworkImageWidget(
      src: 'https://picsum.photos/seed/avatar/200/200',
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorIcon: CupertinoIcons.person_fill,
      errorIconColor: CupertinoColors.systemGrey2,
      errorIconSize: 44,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }
}
