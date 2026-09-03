import 'package:flutter/cupertino.dart';
import 'package:myflutter1/apis/songs.dart';
import 'package:myflutter1/apis/songs_model.dart';
import 'package:myflutter1/widgets/network_image_widget.dart';

/// 顶部封面高度（pt）。过大容易显得头重脚轻，并挤压底部信息卡片的视觉重量。
const double _kHeroHeight = 220;

/// 页面颜色 token
///
/// 注意：CupertinoColors.label / systemGrey 等是 CupertinoDynamicColor，
/// 直接作为 TextStyle.color 会回退到亮色基础色（黑色），暗黑模式下看不见，
/// 因此统一在此按当前 context 解析成真实主题色。
class _DetailStyle {
  final Color label;
  final Color secondary;
  final Color tertiary;
  final Color separator;
  final Color fill;
  final Color background;

  _DetailStyle(BuildContext context)
      : label = CupertinoDynamicColor.resolve(CupertinoColors.label, context),
        secondary = CupertinoDynamicColor.resolve(
          CupertinoColors.secondaryLabel,
          context,
        ),
        tertiary = CupertinoDynamicColor.resolve(
          CupertinoColors.systemGrey,
          context,
        ),
        separator = CupertinoDynamicColor.resolve(
          CupertinoColors.systemGrey5,
          context,
        ),
        fill = CupertinoDynamicColor.resolve(
          CupertinoColors.systemGrey6,
          context,
        ),
        background = CupertinoDynamicColor.resolve(
          CupertinoColors.systemBackground,
          context,
        );
}

/// 歌曲详情页
/// [n] 歌曲在列表中的序号，用于调用 getSongByN 获取详情。
/// [msg] 歌曲名称，作为接口参数传入。
class SongDetailPage extends StatefulWidget {
  final int n;
  final String msg;

  const SongDetailPage({super.key, required this.n, required this.msg});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  bool _loading = true;
  ResSongInfo? _info;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _errorMsg = null;
    });
    final res = await ApiSongs.getSongByN(
      ReqGetSongs(msg: widget.msg, n: widget.n.toString(), page: "1"),
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (res.result) {
        _info = res.data;
      } else {
        _errorMsg = res.msg.isNotEmpty ? res.msg : "获取详情失败";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = _DetailStyle(context);
    final info = _info;
    return CupertinoPageScaffold(
      backgroundColor: style.background,
      // 已有数据时始终保留滚动视图，不能用 _loading 直接替换成加载态：
      // 下拉刷新会触发 _loadDetail，若此时把 CustomScrollView（内含
      // CupertinoSliverRefreshControl）从树上移除，刷新控件会在刷新尚未完成时
      // 被 dispose，其内部对刷新状态的空断言就会抛 Unexpected null value。
      child: info == null
          ? _loading
                ? const Center(child: CupertinoActivityIndicator(radius: 16))
                : _buildError(style, _errorMsg ?? '暂无歌曲信息')
          : _buildContent(style, info),
    );
  }

  Widget _buildError(_DetailStyle style, String message) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.exclamationmark_circle,
                size: 46,
                color: style.tertiary,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(fontSize: 14, color: style.secondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                borderRadius: BorderRadius.circular(8),
                onPressed: _loadDetail,
                child: const Text("重试", style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(_DetailStyle style, ResSongInfo info) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return CustomScrollView(
      slivers: [
        // 必须用 Sliver 版本的导航栏：CustomScrollView 的 slivers 列表
        // 只接受 SliverRenderObject，普通 CupertinoNavigationBar 会渲染失败
        const CupertinoSliverNavigationBar(
          largeTitle: Text('歌曲详情'),
          previousPageTitle: '返回',
        ),
        CupertinoSliverRefreshControl(onRefresh: _loadDetail),
        // 顶部封面：滚动时随内容一起上移
        SliverToBoxAdapter(child: _buildHeroImage(info)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // 歌名 + 歌手 + 时长
              _buildTitleBlock(info, style),
              const SizedBox(height: 18),
              // 操作按钮
              _buildActions(info, style),
              const SizedBox(height: 22),
              // 音频规格
              _buildSpecs(info, style),
              const SizedBox(height: 22),
              // 资源信息
              _buildResourceInfo(info, style),
              // 底部安全区，保证能滚到底
              SizedBox(height: bottomInset + 24),
            ]),
          ),
        ),
      ],
    );
  }

  /// 顶部大图：封面 + 底部渐变（保证顶部图标与文字可读）
  ///
  /// 必须用 SizedBox 固定高度：本组件位于 SliverToBoxAdapter 中，
  /// 视口给的是无界高度约束（0<=h<=Infinity），
  /// 而 Stack(fit: expand) 会试图撑满父级，直接导致
  /// "BoxConstraints forces an infinite height" 断言。
  Widget _buildHeroImage(ResSongInfo info) {
    return SizedBox(
      height: _kHeroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkImageWidget(
            src: info.picture,
            width: double.infinity,
            height: _kHeroHeight,
            fit: BoxFit.cover,
            cacheWidth: (MediaQuery.of(context).size.width * 3).round(),
            errorIcon: CupertinoIcons.music_albums,
            errorIconSize: 56,
          ),
          // 顶部渐变：与导航栏自然过渡，避免硬切
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CupertinoColors.black.withValues(alpha: 0.45),
                    CupertinoColors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBlock(ResSongInfo info, _DetailStyle style) {
    final duration = _formatDuration(info.time);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          info.song,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: style.label,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          info.singer,
          style: TextStyle(fontSize: 16, color: style.secondary),
        ),
        if (info.album.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            info.album,
            style: TextStyle(fontSize: 13, color: style.tertiary),
          ),
        ],
        if (duration.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                CupertinoIcons.time,
                size: 13,
                color: style.tertiary,
              ),
              const SizedBox(width: 4),
              Text(
                duration,
                style: TextStyle(fontSize: 13, color: style.tertiary),
              ),
              const SizedBox(width: 12),
              _QualityBadge(quality: info.quality, format: info.format),
            ],
          ),
        ],
      ],
    );
  }

  /// 操作区：播放 / 复制链接（无链接时禁用）
  Widget _buildActions(ResSongInfo info, _DetailStyle style) {
    return Row(
      children: [
        Expanded(
          child: CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(vertical: 12),
            borderRadius: BorderRadius.circular(12),
            onPressed: info.hasUrl ? () => _showPlayTip() : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(CupertinoIcons.play_fill, size: 18),
                SizedBox(width: 6),
                Text("播放", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _CircleAction(
          icon: CupertinoIcons.link,
          style: style,
          enabled: info.hasUrl,
          onTap: () => _copyUrl(info.url),
        ),
        const SizedBox(width: 12),
        _CircleAction(
          icon: CupertinoIcons.share,
          style: style,
          enabled: info.hasUrl,
          onTap: () => _copyUrl(info.url),
        ),
      ],
    );
  }

  /// 音频规格：格式 / 码率 / 大小
  Widget _buildSpecs(ResSongInfo info, _DetailStyle style) {
    final items = <(IconData, String, String)>[
      (CupertinoIcons.waveform, "格式", info.format.isEmpty
          ? "—"
          : info.format.toUpperCase()),
      (CupertinoIcons.chart_bar, "码率", info.bitrate.isEmpty
          ? "—"
          : "${info.bitrate} kbps"),
      (CupertinoIcons.doc, "大小", info.size.isEmpty ? "—" : info.size),
    ];
    return _GroupCard(
      style: style,
      title: "音频规格",
      children: [
        Row(
          children: items
              .map(
                (e) => Expanded(
                  child: _SpecItem(
                    style: style,
                    icon: e.$1,
                    label: e.$2,
                    value: e.$3,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  /// 资源信息：ID / rid
  Widget _buildResourceInfo(ResSongInfo info, _DetailStyle style) {
    return _GroupCard(
      style: style,
      title: "资源信息",
      children: [
        _InfoRow(style: style, label: "歌曲 ID", value: '${info.id}'),
        Container(height: 1, color: style.separator),
        _InfoRow(style: style, label: "资源 ID", value: info.rid),
      ],
    );
  }

  void _showPlayTip() {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text("提示"),
        content: const Text("本 Demo 未接入播放器，仅展示数据。"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("知道了"),
          ),
        ],
      ),
    );
  }

  void _copyUrl(String url) {
    // TODO: 接入 clipboard 插件后实现复制
    debugPrint("待复制链接：$url");
  }
}

/// 顶部大图下方的内容卡片
class _GroupCard extends StatelessWidget {
  final _DetailStyle style;
  final String title;
  final List<Widget> children;

  const _GroupCard({
    required this.style,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, bottom: 6),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              color: style.tertiary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: style.fill,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}

/// 规格项：图标 + 标签 + 数值
class _SpecItem extends StatelessWidget {
  final _DetailStyle style;
  final IconData icon;
  final String label;
  final String value;

  const _SpecItem({
    required this.style,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Icon(icon, size: 20, color: style.secondary),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: style.label,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: style.tertiary),
          ),
        ],
      ),
    );
  }
}

/// 信息行：左标签右数值
class _InfoRow extends StatelessWidget {
  final _DetailStyle style;
  final String label;
  final String value;

  const _InfoRow({
    required this.style,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: style.secondary),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "—" : value,
              style: TextStyle(fontSize: 14, color: style.label),
            ),
          ),
        ],
      ),
    );
  }
}

/// 圆形图标按钮
class _CircleAction extends StatelessWidget {
  final IconData icon;
  final _DetailStyle style;
  final bool enabled;
  final VoidCallback onTap;

  const _CircleAction({
    required this.icon,
    required this.style,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: enabled ? onTap : null,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: style.fill,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? style.label : style.tertiary,
        ),
      ),
    );
  }
}

/// 音质角标
class _QualityBadge extends StatelessWidget {
  final ResSongQuality quality;
  final String format;

  const _QualityBadge({required this.quality, required this.format});

  String get _text {
    switch (quality) {
      case ResSongQuality.masterLossless:
        return "母带";
      case ResSongQuality.hiRes:
        return "Hi-Res";
      case ResSongQuality.lossless:
        return "无损";
      case ResSongQuality.high:
        return "高品质";
      case ResSongQuality.standard:
        return "标准";
      case ResSongQuality.unknown:
        return format.isEmpty ? "未知" : format.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLossless = quality == ResSongQuality.masterLossless ||
        quality == ResSongQuality.hiRes ||
        quality == ResSongQuality.lossless;
    final accent = isLossless
        ? CupertinoColors.systemOrange
        : CupertinoColors.systemGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: accent.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: accent,
        ),
      ),
    );
  }
}

/// 秒数字符串（如 "252"）格式化为 m:ss
String _formatDuration(String raw) {
  final seconds = int.tryParse(raw.trim());
  if (seconds == null || seconds <= 0) return '';
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '$m:${s.toString().padLeft(2, "0")}';
}
