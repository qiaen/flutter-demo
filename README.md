# myflutter1

A new Flutter project.

## 环境要求

- [Flutter SDK](https://docs.flutter.dev/get-started/install)（含 `flutter` 命令行工具）
- Dart SDK（随 Flutter 一同安装）
- 对应平台的环境：
  - Android：Android Studio + Android SDK
  - iOS / macOS：Xcode（仅 macOS 可用）
  - Web：Chrome 等现代浏览器

> 安装完成后请运行 `flutter doctor` 检查环境是否就绪。

## 安装依赖

```bash
flutter pub get
```

## 运行项目

```bash
# 查看可用设备
flutter devices

# 运行到指定设备（可选：chrome / ios / android）
flutter run

# 运行到 Web
flutter run -d chrome
```

## 常用命令

```bash
# 检查代码问题
flutter analyze

# 运行单元测试
flutter test

# 打包构建
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

## 参考资源

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter 官方文档](https://docs.flutter.dev/)
