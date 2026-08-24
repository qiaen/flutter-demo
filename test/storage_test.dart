import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:myflutter1/services/storage.dart';

void main() {
  setUp(() {
    // 测试中用 mock 初始化 SharedPreferences，避免平台缺失报错
    SharedPreferences.setMockInitialValues({});
  });

  test('set 后 get 能取回值', () async {
    await LocalStorage.set('token', 'abc123');
    final val = await LocalStorage.get<String>(
      'token',
      fromJson: (e) => e as String,
    );
    expect(val, 'abc123');
  });

  test('get 不存在的 key 返回 null', () async {
    final val = await LocalStorage.get<String>(
      'not_exist',
      fromJson: (e) => e as String,
    );
    expect(val, isNull);
  });

  test('clear 后能清除已存的值', () async {
    await LocalStorage.set('name', 'qiaen');
    await LocalStorage.clear('name');
    final val = await LocalStorage.get<String>(
      'name',
      fromJson: (e) => e as String,
    );
    expect(val, isNull);
  });

  test('设置了过期时间且已过期时返回 null', () async {
    // min 为负会让 expired < now，构造"已经过期"的场景（min 单位：分钟）
    await LocalStorage.set('tmp', 'expired', min: -1);
    final val = await LocalStorage.get<String>(
      'tmp',
      fromJson: (e) => e as String,
    );
    expect(val, isNull);
  });

  test('未过期的 min 仍能取回', () async {
    await LocalStorage.set('keep', 42, min: 10); // 10 分钟后才过期
    final val = await LocalStorage.get<int>(
      'keep',
      fromJson: (e) => e as int,
    );
    expect(val, 42);
  });

  test('存储复杂对象（Map）能正确还原', () async {
    final map = {'id': 1, 'list': [1, 2, 3]};
    await LocalStorage.set('obj', map);
    final val = await LocalStorage.get<Map<String, dynamic>>(
      'obj',
      fromJson: (e) => Map<String, dynamic>.from(e as Map),
    );
    expect(val, map);
  });
}
