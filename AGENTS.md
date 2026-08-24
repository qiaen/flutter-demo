# AGENTS.md — Flutter Demo 学习项目

本文件为 CodeBuddy / AI 编码助手提供项目级协作规则与上下文。任何 AI 在本仓库内工作时，应先阅读本文件。

## 项目定位

- **类型**：Flutter Demo 学习项目（`myflutter1`）。
- **目的**：练习与验证 Flutter 常用能力（路由导航、图片加载、本地通知、跨平台构建等），非生产应用，不发布到 pub.dev。
- **风格偏好**：iOS 风格 UI，使用 `CupertinoApp` / `CupertinoPageRoute` / `CupertinoTabScaffold` 等 Cupertino 组件，而非 Material。
- **目标平台**：Android + iOS（偶尔 Web）。

## 环境

- Flutter 3.47.1 stable，Dart 3.13.1（由 Flutter 自带，升级自 3.44.6 / 3.12.2）。
- `sdk: ^3.13.0`（见 `pubspec.yaml`）。
- 依赖：`cupertino_icons`、`flutter_local_notifications`、`dio`、`webview_flutter`（Web 端另需 `webview_flutter_web`，但本项目 Demo 主要在 iOS/Android 验证）。
- 运行前需 `flutter pub get`。
- 原生工具链（已满足 3.47 要求）：Gradle 9.1.0 / AGP 9.0.1 / Kotlin 2.3.20 / Xcode 26.5。

## 目录结构

```
lib/
  main.dart                  # 入口，CupertinoApp；Web 端注册 webview_flutter_web 实现
  services/
    http.dart                # 基于 Dio 的 HttpService 单例封装（get/post + ApiResponse）
    apis.dart                # 通用 API 入口（示例 login）
  apis/
    songs.dart               # 歌曲相关接口（ApiSongs：getSongs / getSongByN）
    songs_model.dart         # 歌曲模型（ResSong / ResSongs / ResSongInfo / ResSongPlayUrl / ReqGetSongs）
  pages/
    home/
      home_page.dart         # 首页
      home_cards.dart        # 卡片区，"每日签到"点击打开 WebView
      home_list.dart / home_banner.dart / home_detail_page.dart
      songs/
        songs_search.dart    # 歌曲搜索页（列表 → 点击进详情）
        song_detail_page.dart# 歌曲详情页（getSongByN + WebView 风格展示）
        webview_page.dart    # 通用 WebView 页（Cupertino 风格）
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
3. **导航**：页面跳转用 `CupertinoPageRoute`；底部 Tab 用 `CupertinoTabScaffold`。Cupertino 页面默认支持边缘左滑返回。
4. **网络层**：
   - 统一走 `services/http.dart` 的 `HttpService`（Dio 单例），或经 `apis/*.dart` 的封装方法（如 `ApiSongs.getSongs`）。
   - 响应统一为 `ApiResponse<T>`，其中 `result` 字段已在解析时自动判断（后端约定 `code == 200 && data != null` 为成功）。调用方**只需判断 `res.result`**：`if (res.result) { 用 res.data! } else { 按需用 res.code / res.msg 处理 }`。
   - model 的 `fromJson(Map<String, dynamic>)` 可直接作为 `fromData` 传给 `Http.get/post`（根签名已对齐 Map 类型）。
   - 失败（网络/DioException）仍会抛异常，调用处需 `try/catch` 兜底，避免白屏。
5. **本地通知**：使用 `flutter_local_notifications`，Android 与 iOS 初始化/权限/详情需同时配置（参考 `pages/mine/message_notify.dart`）。iOS 前台显示需在 `ios/Runner/SceneDelegate.swift` 设置 `UNUserNotificationCenter.delegate`。
6. **WebView**：使用 `webview_flutter`，通用页在 `pages/home/webview_page.dart`（`CupertinoPageScaffold` + `WebViewWidget`），带加载菊花。Android/iOS 可用；Web 端需在 `main.dart` 注册 `WebWebViewPlatform()`。
7. **新增依赖**：写入 `pubspec.yaml` 后必须 `flutter pub get`，并注意 Android 端可能需要的原生配置（如 core library desugaring）。

## 平台注意事项

- **Android 权限**：网络图片需要 `INTERNET`；通知需要 `POST_NOTIFICATIONS`（见 `android/app/src/main/AndroidManifest.xml`）。
- **60Hz 锁定**：红米 Note 15 / HyperOS 对未加入白名单的 App 锁定 60Hz，属系统行为，代码（含 `flutter_displaymode`）无法解锁，无需继续排查。
- **iOS 改动**：涉及原生 Swift/Objective-C 的改动（如 SceneDelegate）需整包重新构建（`flutter run`），热重载无效。
- **Flutter 3.47 兼容性**：Cupertino 旧导入（`package:flutter/cupertino.dart`）仍向后兼容，无需迁移到独立包。

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
