import 'package:flutter/cupertino.dart';
import '../../widgets/network_image_widget.dart';
import 'home_detail_page.dart';

class HomeList extends StatelessWidget {
  const HomeList({super.key});

  static const List<Map<String, dynamic>> _items = [
    {
      'image': 'https://picsum.photos/seed/item1/200/200',
      'title': '发现城市秘境',
      'desc': '带你探索城市中不为人知的角落，感受独特的城市魅力与文化氛围。',
      'tag': '旅行',
    },
    {
      'image': 'https://picsum.photos/seed/item2/200/200',
      'title': '美食探店指南',
      'desc': '本地最受欢迎的餐厅合集，从街头小吃到高级料理一网打尽。',
      'tag': '美食',
    },
    {
      'image': 'https://picsum.photos/seed/item3/200/200',
      'title': '周末好去处',
      'desc': '周末不知道去哪玩？这份清单帮你规划完美周末行程。',
      'tag': '生活',
    },
    {
      'image': 'https://picsum.photos/seed/item4/200/200',
      'title': '摄影技巧入门',
      'desc': '从零开始学摄影，掌握构图、光影和后期处理的实用技巧。',
      'tag': '摄影',
    },
    {
      'image': 'https://picsum.photos/seed/item5/200/200',
      'title': '健康生活方式',
      'desc': '科学饮食与运动搭配，帮你建立健康的生活习惯。',
      'tag': '健康',
    },
    {
      'image': 'https://picsum.photos/seed/item6/200/200',
      'title': '科技前沿速递',
      'desc': '了解最新科技动态，把握人工智能、新能源等领域的发展趋势。',
      'tag': '科技',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '为你推荐',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // 控制是局部上下滚动还是整个页面滚动
          itemCount: _items.length,
          separatorBuilder: (_, _) => const Padding(
            padding: EdgeInsets.only(left: 90),
            child: SizedBox(
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: CupertinoColors.systemGrey5),
              ),
            ),
          ),
          itemBuilder: (context, index) {
            final item = _items[index];
            return _KeepAliveListItem(item: item, builder: buildListItem);
          },
        ),
      ],
    );
  }

  Widget buildListItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 关键！透明空白区域也可以响应点击
      onTap: () {
        Navigator.of(
          context,
          rootNavigator: true, //  知识点1 去掉的话，二级页面会有底部tab
        ).push(CupertinoPageRoute(builder: (_) => HomeDetailPage(item: item)));

        // Navigator.of(
        //   context,
        //   rootNavigator: true,
        //   MaterialPageRoute(builder: (_) => HomeDetailPage(item: item)),
        // );
        // Navigator.of(
        //   context,
        //   rootNavigator: true, // 知识点1 去掉的话，二级页面会有底部tab。
        // ).push(MaterialPageRoute(builder: (_) => HomeDetailPage(item: item)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkImageWidget(
                src: item['image'] as String,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                cacheWidth: 210, // 70 * 3，按 3x DPR 缓存，避免滚动时反复解码原图导致掉帧
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['desc'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(25, 0, 122, 255),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['tag'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: CupertinoColors.systemGrey3,
            ),
          ],
        ),
      ),
    );
  }
}

/// 给列表项做 keep-alive，滚动出屏后不被销毁，避免图片缓存被释放导致重新解码掉帧。
class _KeepAliveListItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final Widget Function(BuildContext, Map<String, dynamic>) builder;

  const _KeepAliveListItem({required this.item, required this.builder});

  @override
  State<_KeepAliveListItem> createState() => _KeepAliveListItemState();
}

class _KeepAliveListItemState extends State<_KeepAliveListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用，keep-alive 才能生效
    return widget.builder(context, widget.item);
  }
}
