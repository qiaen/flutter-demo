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
          // bg.png 背景，常驻显示（不依赖滚动）
          // 左侧不传 → 默认显示返回按钮（点击自动 pop）
          // 右侧插槽传入搜索按钮，点击事件在 Widget 内部自定义
          CustomAppBar(
            title: "",
            showBack: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                'assets/images/cfl_logo_b.png',
                height: 22,
                fit: BoxFit.contain,
              ),
            ),
            // 打卡日历图片
            trailing: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/calendar_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '21',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6F4E37), // 咖啡色
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    CupertinoTheme.of(context).brightness == Brightness.dark
                        ? 'assets/images/bg_black.jpg'
                        : 'assets/images/bg.jpg',
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: SafeArea(
                top: false,
                bottom: false,
                child: ListView(
                  // 底部预留 tab 栏高度 + 安全区，避免内容被遮挡
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                    top: 16,
                  ),
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
