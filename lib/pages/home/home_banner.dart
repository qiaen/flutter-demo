import 'package:flutter/cupertino.dart';
import 'home_detail_page.dart';
import '../../widgets/network_image_widget.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView(
        children: [
          _BannerItem(
            image: 'https://picsum.photos/seed/banner1/1200/540',
            title: '夏日特惠',
            subtitle: '全场低至五折',
            desc: '精选夏日新品与经典畅销款，参与活动即可享受五折优惠，先到先得。',
            tint: const Color(0xFFFF6B6B),
          ),
          _BannerItem(
            image: 'https://picsum.photos/seed/banner2/1200/540',
            title: '新品上市',
            subtitle: '探索最新潮流',
            desc: '本季新品悉数登场，从街头潮流到极简主义，捕捉每一份灵感。',
            tint: const Color(0xFF4ECDC4),
          ),
          _BannerItem(
            image: 'https://picsum.photos/seed/banner3/1200/540',
            title: '限时活动',
            subtitle: '立即参与赢好礼',
            desc: '参与限时活动即有机会赢取限定周边与神秘大奖，错过等一年。',
            tint: const Color(0xFFFFE66D),
          ),
        ],
      ),
    );
  }
}

class _BannerItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String desc;
  final Color tint;

  const _BannerItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(
            builder: (_) => HomeDetailPage(
              item: {
                'title': title,
                'subtitle': subtitle,
                'desc': desc,
                'image': image,
                'tint': tint,
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: tint.withValues(alpha: 0.1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkImageWidget(
                src: image,
                fit: BoxFit.cover,
                cacheWidth: (MediaQuery.of(context).size.width * 3)
                    .round(), // 3x DPR
                placeholderColor: tint,
                errorIconColor: CupertinoColors.white,
              ),
              // 底部暗化渐变，保证标题在浅图上也可读
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        CupertinoColors.black.withValues(alpha: 0.05),
                        CupertinoColors.black.withValues(alpha: 0.45),
                      ],
                      stops: const [0.55, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
