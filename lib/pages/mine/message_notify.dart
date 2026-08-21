import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessageNotify extends StatefulWidget {
  const MessageNotify({super.key});

  @override
  State<MessageNotify> createState() => _MessageNotifyState();
}

class _MessageNotifyState extends State<MessageNotify> {
  /// 通知总开关
  bool _enableNotification = false;
  bool _enablePush = false;
  bool _enableSound = true;

  final FlutterLocalNotificationsPlugin _localNotify =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// 初始化通知插件（必须在使用前调用，否则安卓上 show() 无效）
  Future<void> _initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotify.initialize(initSettings);
    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  /// 请求通知权限（安卓 13+ 需要）
  Future<void> _requestPermission() async {
    final androidImpl = _localNotify
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();
    }
  }

  /// 发起本地通知
  Future<void> _triggerLocalNotification() async {
    // 未初始化或插件不可用时静默返回
    if (!_initialized) {
      await _initialize();
    }
    // 先请求权限，避免安卓 13+ 未授权导致无效果
    await _requestPermission();

    const androidDetail = AndroidNotificationDetails(
      "default_channel",
      "默认通知",
      channelDescription: "应用普通通知",
      importance: Importance.high,
      priority: Priority.high,
    );
    const notifyDetail = NotificationDetails(android: androidDetail);
    await _localNotify.show(
      DateTime.now().millisecond,
      "中国福利彩票中心",
      "恭喜您！ 您于 2026 年 8 月 21 日投注的中国福利彩票双色球（第 2026102 期），经开奖系统比对，您所选号码与当期开奖号码完全一致，喜中一等奖 1 注！",
      notifyDetail,
    );
  }

  /// 苹果风格设置项行（封装开关行，复用）
  Widget _buildSwitchRow(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text("消息通知")),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: CupertinoColors.systemGrey5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSwitchRow("接收应用通知", _enableNotification, (
                        val,
                      ) async {
                        if (val) {
                          await _requestPermission();
                        }
                        setState(() {
                          _enableNotification = val;
                        });
                      }),
                      Container(height: 1, color: CupertinoColors.systemGrey5),
                      _buildSwitchRow("离线推送消息", _enablePush, (val) {
                        setState(() {
                          _enablePush = val;
                        });
                      }),
                      Container(height: 1, color: CupertinoColors.systemGrey5),
                      _buildSwitchRow("通知提示音", _enableSound, (val) {
                        setState(() {
                          _enableSound = val;
                        });
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: _triggerLocalNotification,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text('发起本机通知'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "提示：国内安卓设备离线推送需要接入厂商推送服务；模拟器无法测试推送。",
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey2,
                  ),
                ),
                // 留出底部安全距离
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
