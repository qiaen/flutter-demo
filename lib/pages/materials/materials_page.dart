import 'package:flutter/cupertino.dart';

class MaterialsPage extends StatelessWidget {
  const MaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Materials')),
      child: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: const [
            _MaterialCard(
              icon: CupertinoIcons.doc_fill,
              title: '文档资料',
              count: '23 份',
              color: CupertinoColors.systemBlue,
            ),
            _MaterialCard(
              icon: CupertinoIcons.video_camera_solid,
              title: '视频教程',
              count: '15 个',
              color: CupertinoColors.systemRed,
            ),
            _MaterialCard(
              icon: CupertinoIcons.book_solid,
              title: '电子书籍',
              count: '8 本',
              color: CupertinoColors.systemGreen,
            ),
            _MaterialCard(
              icon: CupertinoIcons.music_note_2,
              title: '音频资源',
              count: '32 首',
              color: CupertinoColors.systemOrange,
            ),
            _MaterialCard(
              icon: CupertinoIcons.photo,
              title: '图片素材',
              count: '56 张',
              color: CupertinoColors.systemPurple,
            ),
            _MaterialCard(
              icon: CupertinoIcons.archivebox_fill,
              title: '工具合集',
              count: '12 套',
              color: CupertinoColors.systemTeal,
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;
  final Color color;

  const _MaterialCard({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: CupertinoColors.systemGrey5.resolveFrom(context),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(25, 0, 122, 255),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 26, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
          ),
        ],
      ),
    );
  }
}
