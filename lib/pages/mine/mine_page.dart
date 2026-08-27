import 'package:flutter/cupertino.dart';
import 'package:myflutter1/pages/mine/message_notify.dart';
import '../../widgets/network_image_widget.dart';
import 'settings_page.dart';
import 'user_detail_page.dart';
// import 'package:smooth_sheets/smooth_sheets.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Mine')),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // 头像区域
            Center(
              child: GestureDetector(
                onTap: () {
                  // 方式1 加rootNavigator true，会带着appbar从底部弹出，不加会页面向上，导航从右边滑出来
                  // Navigator.of(context, rootNavigator: true).push(
                  //   CupertinoModalSheetRoute(
                  //     builder: (context) => const UserDetailPage(),
                  //   ),
                  // );

                  // 方式2 带着导航从底部弹出，和上面rootNavigator true几乎一样
                  // showAdaptiveModalSheet(
                  //   context: context,
                  //   builder: (context) => const UserDetailPage(),
                  // );

                  // 方式3，这是Cupertino自带的，和苹果，老版sheet几乎一样，貌似不支持控制上页不缩放
                  // showCupertinoSheet(
                  //   context: context,
                  //   showDragHandle: true,
                  //   scrollableBuilder:
                  //       (BuildContext context, ScrollController controller) {
                  //         Widget widgetBuilder(BuildContext context) =>
                  //             const UserDetailPage();
                  //         return widgetBuilder(context);
                  //       },
                  // );

                  // showCupertinoModalPopup<void>(
                  //   context: context,
                  //   builder: (_) => const UserDetailPage(),
                  // );
                  // 苹果样式的缩放形式压入导航页面
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoSheetRoute(
                      scrollableBuilder:
                          (BuildContext context, ScrollController controller) {
                            Widget widgetBuilder(BuildContext _) =>
                                UserDetailPage();
                            return widgetBuilder(context);
                          },
                    ),
                  );
                },
                child: const Column(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipOval(child: _UserAvatar()),
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
              context: context,
              children: [
                _buildMenuRow(context, CupertinoIcons.person_2_fill, '个人信息'),
                _buildMenuRow(context, CupertinoIcons.settings_solid, '设置'),
                _buildMenuRow(context, CupertinoIcons.bell_solid, '消息通知'),
              ],
            ),
            const SizedBox(height: 12),
            _buildSection(
              context: context,
              children: [
                _buildMenuRow(context, CupertinoIcons.heart_solid, '我的收藏'),
                _buildMenuRow(context, CupertinoIcons.clock_solid, '浏览历史'),
                _buildMenuRow(context, CupertinoIcons.share_solid, '分享给朋友'),
              ],
            ),
            const SizedBox(height: 12),
            _buildSection(
              context: context,
              children: [_buildMenuRow(context, CupertinoIcons.info, '关于我们')],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required List<Widget> children,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey5.resolveFrom(context),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuRow(BuildContext context, IconData icon, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (title == "设置") {
          Navigator.of(
            context,
            rootNavigator: true, // 去掉的话，二级页面会带底部 tab
          ).push(CupertinoPageRoute(builder: (_) => const SettingsPage()));
        } else if (title == "消息通知") {
          Navigator.of(
            context,
            rootNavigator: true, //  知识点1 去掉的话，二级页面会有底部tab
          ).push(CupertinoPageRoute(builder: (_) => MessageNotify()));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: CupertinoColors.activeBlue),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: CupertinoColors.systemGrey3,
            ),
          ],
        ),
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
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
        ),
      ],
    );
  }
}
