import 'package:flutter/cupertino.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  static final List<Map<String, dynamic>> _events = [
    {
      'title': 'Flutter 技术沙龙',
      'date': '7月15日 14:00',
      'location': '线上直播',
      'color': CupertinoColors.activeBlue,
      'icon': CupertinoIcons.videocam_fill,
    },
    {
      'title': '夏日音乐节',
      'date': '7月20日 18:00',
      'location': '城市公园',
      'color': CupertinoColors.systemGreen,
      'icon': CupertinoIcons.music_note_2,
    },
    {
      'title': '创意市集',
      'date': '7月22日 10:00',
      'location': '艺术中心',
      'color': CupertinoColors.systemOrange,
      'icon': CupertinoIcons.bag_fill,
    },
    {
      'title': '编程马拉松',
      'date': '7月28日 09:00',
      'location': '创新工场',
      'color': CupertinoColors.systemPurple,
      'icon': CupertinoIcons.device_desktop,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Events'),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _events.length,
          itemBuilder: (context, index) {
            final event = _events[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(25, 0, 122, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      event['icon'] as IconData,
                      color: event['color'] as Color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event['date'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event['location'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 18,
                    color: CupertinoColors.systemGrey3,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
