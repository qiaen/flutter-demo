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
          // 左侧不传 → 默认显示返回按钮（点击自动 pop）
          // 右侧插槽传入搜索按钮，点击事件在 Widget 内部自定义
          CustomAppBar(
            title: "",
            showBack: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                'assets/images/cfl_logo_b.png',
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
            trailing: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () => debugPrint("搜索"),
              child: const Icon(
                CupertinoIcons.search,
                color: CupertinoColors.white,
              ),
            ),
          ),
          // 需求1 页面使用背景图bg.png
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
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
          ),
        ],
      ),
    );
  }
}
