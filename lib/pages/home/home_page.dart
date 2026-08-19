import 'package:flutter/cupertino.dart';
import 'home_banner.dart';
import 'home_cards.dart';
import 'home_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: const [
            // 1. Banner 图
            HomeBanner(),
            SizedBox(height: 16),
            // 2. 左右排列的卡片
            HomeCards(),
            SizedBox(height: 20),
            // 3. 列表
            HomeList(),
          ],
        ),
      ),
    );
  }
}
