import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

/// 设置页：展示 App 缓存占用情况（网络图片缓存），并提供清空缓存能力。
///
/// 图片缓存由 `cached_network_image` 底层 `flutter_cache_manager` 管理，
/// 缓存文件存放在应用支持目录下的 `libCachedImageData/` 文件夹中。
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _cacheBytes = 0; // 缓存总字节数
  bool _calculating = true; // 是否正在统计
  bool _clearing = false; // 是否正在清空

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  /// 定位图片缓存目录
  ///
  /// `flutter_cache_manager` 将缓存文件存放在系统【临时目录】下的
  /// `libCachedImageData/` 文件夹中（见其 `IOFileSystem` 的
  /// `getTemporaryDirectory()`），而不是应用支持目录，因此这里必须用
  /// `getTemporaryDirectory()` 才能统计到实际占用。
  Future<Directory?> _cacheDirectory() async {
    if (kIsWeb) return null; // Web 端无文件系统磁盘缓存
    final tmpDir = await getTemporaryDirectory();
    final dir = Directory('${tmpDir.path}/libCachedImageData');
    if (await dir.exists()) return dir;
    return null;
  }

  /// 递归计算目录大小（字节）
  Future<int> _dirSize(Directory dir) async {
    int total = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        total += await entity.length();
      }
    }
    return total;
  }

  /// 统计缓存占用
  Future<void> _loadCacheSize() async {
    try {
      final dir = await _cacheDirectory();
      int total = 0;
      if (dir != null) {
        total = await _dirSize(dir);
      }
      if (mounted) {
        setState(() {
          _cacheBytes = total;
          _calculating = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _calculating = false);
    }
  }

  /// 清空缓存
  Future<void> _clearCache() async {
    if (_clearing) return;
    setState(() => _clearing = true);
    try {
      if (!kIsWeb) {
        // 清空 flutter_cache_manager 管理的缓存文件
        await DefaultCacheManager().emptyCache();
        // 兜底：删除缓存目录中残留文件
        final dir = await _cacheDirectory();
        if (dir != null && await dir.exists()) {
          await dir.delete(recursive: true);
        }
      }
      if (mounted) {
        setState(() {
          _cacheBytes = 0;
          _clearing = false;
          _calculating = false;
        });
        _showAlert('清理完成', '缓存已清空');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _clearing = false);
        _showAlert('清理失败', '请稍后重试');
      }
    }
  }

  void _showAlert(String title, String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('好'),
          ),
        ],
      ),
    );
  }

  /// 将字节数格式化为可读的 KB/MB
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('设置')),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          // 缓存占用卡片
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CupertinoColors.systemGrey5.resolveFrom(context),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      CupertinoIcons.trash,
                      size: 20,
                      color: CupertinoColors.activeBlue,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '缓存占用',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 占用数值
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _calculating ? '统计中…' : _formatBytes(_cacheBytes),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        // color: CupertinoColors.label, // 黑色，不设置颜色就跟随系统
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        '（网络图片缓存）',
                        style: TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 清空缓存按钮
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    onPressed: _clearing || _calculating ? null : _clearCache,
                    child: Text(_clearing ? '正在清理…' : '清空缓存'),
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  '清空后，图片会在下次访问时重新从网络加载。',
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
