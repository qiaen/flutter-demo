import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  /// 存储（不需要类型）
  static Future<void> set(String name, dynamic val, {int? min}) async {
    final prefs = await SharedPreferences.getInstance();
    final expired = min != null
        ? DateTime.now().millisecondsSinceEpoch + min * 60 * 1000
        : null;

    final store = {'data': val, 'expired': expired};

    await prefs.setString(name, jsonEncode(store));
  }

  /// 读取（指定类型）
  static Future<T?> get<T>(
    String name, {
    required T Function(dynamic) fromJson,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(name);
    if (val == null) return null;

    try {
      final obj = jsonDecode(val);
      final expired = obj['expired'];
      if (expired != null && expired < DateTime.now().millisecondsSinceEpoch) {
        await clear(name);
        return null;
      }
      return fromJson(obj['data']);
    } catch (e) {
      return null;
    }
  }

  /// 清除
  static Future<void> clear(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(name);
  }
}
