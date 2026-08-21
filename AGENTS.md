# AGENTS.md — Flutter Demo 学习项目

本文件为 CodeBuddy / AI 编码助手提供项目级协作规则与上下文。任何 AI 在本仓库内工作时，应先阅读本文件。

## 项目定位

- **类型**：Flutter Demo 学习项目（`myflutter1`）。
- **目的**：练习与验证 Flutter 常用能力（路由导航、图片加载、本地通知、跨平台构建等），非生产应用，不发布到 pub.dev。
- **风格偏好**：iOS 风格 UI，使用 `CupertinoApp` / `CupertinoPageRoute` / `CupertinoTabScaffold` 等 Cupertino 组件，而非 Material。
- **目标平台**：Android + iOS（偶尔 Web）。

## 环境

- Flutter 3.44.6 stable，Dart 3.12.2。
- `sdk: ^3.12.2`（见 `pubspec.yaml`）。
- 依赖：`cupertino_icons`、`flutter_local_notifications`。
- 运行前需 `flutter pub get`。

## 目录结构

```
lib/
  main.dart                  # 入口，CupertinoApp，初始化通知
  pages/
    home/                    # 首页（banner / 列表 / 详情）
    events/                  # 活动页
    materials/               # 素材页
    mine/                    # 我的（含通知、用户详情）
  widgets/
    network_image_widget.dart# 统一封装的 Image.network 组件
```

## 编码约定

1. **图片加载**：统一使用 `lib/widgets/network_image_widget.dart` 的 `NetworkImageWidget`，不要直接写 `Image.network`。该组件内置 loading 占位、错误缺省图，支持 `src / width / height / fit / cacheWidth / placeholderColor / errorIcon` 等参数。
   - 列表/卡片缩略图必须传 `cacheWidth`（建议逻辑尺寸 × DPR × 3）以控制解码内存、避免掉帧。
2. **UI 组件**：优先 Cupertino 组件；不在 Cupertino 项目中混用 Material（`Divider` 改用 `Container(height:1, color: CupertinoColors.systemGrey5)` 之类）。
3. **导航**：页面跳转用 `CupertinoPageRoute`；底部 Tab 用 `CupertinoTabScaffold`。
4. **本地通知**：使用 `flutter_local_notifications`，Android 与 iOS 初始化/权限/详情需同时配置（参考 `pages/mine/message_notify.dart`）。iOS 前台显示需在 `ios/Runner/SceneDelegate.swift` 设置 `UNUserNotificationCenter.delegate`。
5. **新增依赖**：写入 `pubspec.yaml` 后必须 `flutter pub get`，并注意 Android 端可能需要的原生配置（如 core library desugaring）。

## 平台注意事项

- **Android 权限**：网络图片需要 `INTERNET`；通知需要 `POST_NOTIFICATIONS`（见 `android/app/src/main/AndroidManifest.xml`）。
- **iOS 改动**：涉及原生 Swift/Objective-C 的改动（如 SceneDelegate）需整包重新构建（`flutter run`），热重载无效。

## 常用命令

```bash
flutter pub get
flutter run                 # 运行
flutter build apk --release # 打包 Android
flutter analyze             # 静态检查
flutter test                # 单元测试
```

## 与 AI 协作时的要求

- 改动后尽量保持最小改动原则，优先编辑现有文件而非新建文件。
- 涉及原生配置（Android `build.gradle.kts` / `AndroidManifest.xml`、iOS `*.swift` / `*.plist`）时，明确告知需要整包重建。
- 生成中文说明，代码注释保持简洁。
