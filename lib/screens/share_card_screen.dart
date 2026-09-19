import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/saju_texts.dart';
import '../l10n/app_localizations.dart';
import '../l10n/lang.dart';
import '../saju/saju.dart';
import '../services/saju_service.dart';
import '../widgets/pillar_table.dart';
import '../widgets/star_rating.dart';

/// 사주 원국 + 오늘의 운세를 카드 이미지로 만들어 공유하는 화면.
/// 카드 위젯을 RepaintBoundary 로 감싸 PNG 로 캡처한 뒤 share_plus 로 넘긴다.
class ShareCardScreen extends StatefulWidget {
  final SajuChart chart;
  final DailyFortune fortune;
  const ShareCardScreen({super.key, required this.chart, required this.fortune});

  @override
  State<ShareCardScreen> createState() => _ShareCardScreenState();
}

class _ShareCardScreenState extends State<ShareCardScreen> {
  final _cardKey = GlobalKey();
  bool _busy = false;

  Future<void> _shareImage() async {
    if (_busy) return;
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context).webShareUnsupported)));
      return;
    }
    setState(() => _busy = true);
    try {
      final boundary = _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/saju_${widget.fortune.date.toIso8601String().substring(0, 10)}.png');
      await file.writeAsBytes(bytes!.buffer.asUint8List());

      if (!mounted) return;
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        text: L10n.of(context).shareImageCaption,
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _shareText() {
    final c = widget.chart;
    final f = widget.fortune;
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final date = DateFormat.MMMMd(lang).format(f.date);
    final chartStr = c.pillars.reversed.map((p) => p?.toString() ?? '??').join(' ');
    final ds = c.day.stem;
    final text = '${l.shareTextHeader(date, f.today.toString())}\n'
        '${l.shareTextChart(chartStr)}\n'
        '${SajuTexts.stemEmoji[ds]} ${l.dayMasterLabel}: ${Saju.stemHanja[ds]} ${SajuTexts.stemNames[ds].of(lang)} · ${SajuTexts.stemImages[ds].of(lang)}\n\n'
        '${'⭐' * f.stars} ${l.shareTextScore(f.score)}\n'
        '${f.text.of(lang)}\n\n'
        '🍀 ${l.luckyNumber} ${f.luckyNumber} · ${f.luckyColor.of(lang)} · ${f.luckyDirection.of(lang)}';
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = L10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.shareTitle)),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: RepaintBoundary(
                  key: _cardKey,
                  child: _SajuCard(chart: widget.chart, fortune: widget.fortune),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: _busy ? null : _shareImage,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    icon: _busy
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.image_outlined),
                    label: Text(l.shareAsImage),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _shareText,
                    icon: const Icon(Icons.text_fields),
                    label: Text(l.shareAsText),
                  ),
                  Text(
                    l.shareHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 공유용 카드. 앱 테마와 무관하게 고정 색상(남보라 그라데이션)으로 그린다.
class _SajuCard extends StatelessWidget {
  final SajuChart chart;
  final DailyFortune fortune;
  const _SajuCard({required this.chart, required this.fortune});

  static const _cream = Color(0xFFFFF6D6);
  static const _gold = Color(0xFFFFD656);
  static const _muted = Color(0xFFB8A8E8);

  @override
  Widget build(BuildContext context) {
    final c = chart;
    final f = fortune;
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final ds = c.day.stem;

    return Container(
      width: 340,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B2A7A), Color(0xFF1B1238)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.shareCardTitle,
              style: const TextStyle(color: _cream, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            DateFormat.yMMMMd(lang).format(c.birth) +
                (c.hour == null ? '' : ' ${DateFormat.Hm(lang).format(c.birth)}'),
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          PillarTable(chart: c, onDark: true),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(SajuTexts.stemEmoji[ds], style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.dayMasterLabel, style: const TextStyle(color: _muted, fontSize: 11)),
                      Text(
                        '${Saju.stemHanja[ds]} ${SajuTexts.stemNames[ds].of(lang)} · ${SajuTexts.stemImages[ds].of(lang)}',
                        style: const TextStyle(color: _cream, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('${l.todayFortune} · ${f.today}', style: const TextStyle(color: _muted, fontSize: 12)),
          const SizedBox(height: 4),
          Text('${f.score}',
              style: const TextStyle(color: _cream, fontSize: 52, fontWeight: FontWeight.w800, height: 1)),
          const SizedBox(height: 6),
          StarRating(score: f.stars, size: 22, color: _gold),
          const SizedBox(height: 10),
          Text(
            f.text.of(lang),
            textAlign: TextAlign.center,
            style: const TextStyle(color: _cream, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔮', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(l.shareAppFooter, style: const TextStyle(color: _muted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
