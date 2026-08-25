import 'package:flutter/cupertino.dart';
import 'package:myflutter1/components/custom_app_bar.dart';
import 'home_banner.dart';
import 'home_cards.dart';
import 'home_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          // 自定义导航栏：bg_navbar.png 背景，常驻显示（不依赖滚动）
          CustomAppBar(
            title: "自定义标题",
            onBack: () => Navigator.of(context).maybePop(),
            onSearch: () => debugPrint("搜索"),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: const [
                  // 1. Banner 图
                  HomeBanner(),
                  SizedBox(height: 16),
                  // 2. 左右排列的卡片
                  HomeCards(),
                  SizedBox(height: 16),
                  // 3. 列表
                  HomeList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
