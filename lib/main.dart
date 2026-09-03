import 'package:flutter/cupertino.dart';
import 'pages/home/home_page.dart';
import 'pages/events/events_page.dart';
import 'pages/materials/materials_page.dart';
import 'pages/mine/mine_page.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 🔒 只允许竖屏，禁止横屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 仅手机竖直向上
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        // brightness: Brightness.dark, // 控制项目暗黑模式 / 日间模式 / 不写就是跟随系统
        primaryColor: CupertinoColors.activeBlue, // 全局活跃主色调（影响图标和文字）
      ),
      home: MainTabPage(),
    );
  }
}

class MainTabPage extends StatelessWidget {
  const MainTabPage({super.key});

  // 统一的页面映射列表
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const EventsPage();
      case 2:
        return const MaterialsPage();
      case 3:
        return const MinePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 采用标准的 iOS 原生 TabScaffold 声明方式
    return CupertinoTabScaffold(
      // 1. 底部 Tab 栏配置：默认自带完美的 iOS 磨砂毛玻璃效果
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home, size: 22),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar, size: 22),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder, size: 22),
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person, size: 22),
            label: 'Mine',
          ),
        ],
      ),
      // 2. 页面构建器：index 由系统的 Scaffold 自动控制并传入
      tabBuilder: (context, index) {
        return CupertinoTabView(builder: (context) => _getPage(index));
      },
    );
  }
}
