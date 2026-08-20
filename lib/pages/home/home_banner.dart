import 'package:flutter/cupertino.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView(
        children: [
          _buildBannerItem(
            context,
            'https://picsum.photos/seed/banner1/800/360',
            '夏日特惠',
            '全场低至五折',
            const Color(0xFFFF6B6B),
          ),
          _buildBannerItem(
            context,
            'https://picsum.photos/seed/banner2/800/360',
            '新品上市',
            '探索最新潮流',
            const Color(0xFF4ECDC4),
          ),
          _buildBannerItem(
            context,
            'https://picsum.photos/seed/banner3/800/360',
            '限时活动',
            '立即参与赢好礼',
            const Color(0xFFFFE66D),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(
    BuildContext context,
    String imageUrl,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withValues(alpha: 0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              cacheWidth: (MediaQuery.of(context).size.width * 3).round(), // 按 3x DPR 缓存
              errorBuilder: (_, __, _) => Container(color: color),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                      shadows: [
                        Shadow(blurRadius: 4, color: CupertinoColors.black),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.white,
                      shadows: [
                        Shadow(blurRadius: 2, color: CupertinoColors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
