import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ads/ad_manager.dart';
import '../data/saju_texts.dart';
import '../l10n/app_localizations.dart';
import '../l10n/lang.dart';
import '../saju/saju.dart';
import '../services/notification_service.dart';
import '../services/saju_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/pillar_table.dart';
import '../widgets/star_rating.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';
import 'share_card_screen.dart';

class HomeScreen extends StatefulWidget {
  final SajuService service;
  final NotificationService notifications;
  const HomeScreen({super.key, required this.service, required this.notifications});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SajuChart _chart;
  late DailyFortune _fortune;

  /// 웹 스크린샷 캡처용(?scroll=N). 앱에서는 항상 0.
  late final _scroll = ScrollController(
    initialScrollOffset:
        kIsWeb ? (double.tryParse(Uri.base.queryParameters['scroll'] ?? '') ?? 0) : 0,
  );

  @override
  void initState() {
    super.initState();
    _refresh();
    _setupNotifications();
  }

  void _refresh() {
    _chart = widget.service.chart!;
    final now = DateTime.now();
    _fortune = widget.service.fortuneFor(_chart, DateTime(now.year, now.month, now.day));
  }

  /// 첫 홈 진입 시 알림 권한을 묻고, 앞으로 7일치 알림을 (다시) 예약한다.
  Future<void> _setupNotifications() async {
    final n = widget.notifications;
    if (!n.enabled) return;
    final granted = await n.requestPermission();
    if (granted) await n.reschedule(widget.service);
  }

  void _openDetail() {
    // 하루 첫 상세 진입 때만 전면 광고. 닫히면(또는 광고 없으면) 상세 화면으로.
    AdManager.instance.showInterstitialOncePerDayThen(() {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DetailScreen(chart: _chart, fortune: _fortune)),
      );
    });
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          service: widget.service,
          notifications: widget.notifications,
        ),
      ),
    );
    if (mounted) setState(_refresh);
    widget.notifications.reschedule(widget.service);
  }

  void _share() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ShareCardScreen(chart: _chart, fortune: _fortune)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _chart;
    final f = _fortune;
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ds = c.day.stem;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          IconButton(onPressed: _share, icon: const Icon(Icons.share_outlined), tooltip: l.shareTooltip),
          IconButton(onPressed: _openSettings, icon: const Icon(Icons.settings_outlined), tooltip: l.settingsTooltip),
        ],
      ),
      body: ListView(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // ── 사주 원국 ────────────────────────────────────────────
          Row(
            children: [
              Text(l.myChart, style: theme.textTheme.titleMedium),
              const Spacer(),
              Text(
                '${SajuTexts.zodiacEmoji[c.zodiacIndex]} ${l.zodiacLabel(SajuTexts.zodiacAnimals[c.zodiacIndex].of(lang))}',
                style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat.yMMMMd(lang).format(c.birth) +
                (c.hour == null ? '' : ' ${DateFormat.Hm(lang).format(c.birth)}'),
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHigh,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
              child: PillarTable(chart: c),
            ),
          ),
          const SizedBox(height: 16),

          // ── 일간 카드 ────────────────────────────────────────────
          Card(
            elevation: 0,
            color: cs.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(SajuTexts.stemEmoji[ds], style: const TextStyle(fontSize: 44)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.dayMasterLabel,
                            style: theme.textTheme.labelMedium?.copyWith(color: cs.onPrimaryContainer)),
                        Text(
                          '${Saju.stemHanja[ds]} ${SajuTexts.stemNames[ds].of(lang)} · ${SajuTexts.stemImages[ds].of(lang)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold, color: cs.onPrimaryContainer),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          SajuTexts.elementKeywords[c.dayElement.index].of(lang),
                          style: theme.textTheme.bodyMedium?.copyWith(color: cs.onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── 오행 분포 ────────────────────────────────────────────
          Row(
            children: [
              Text(l.elementBalance, style: theme.textTheme.titleMedium),
              const Spacer(),
              Text(l.characterCount(c.characterCount),
                  style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHigh,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: [
                  ElementBars(chart: c),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Chip(label: l.strongest, element: c.strongestElement, lang: lang),
                      const SizedBox(width: 8),
                      _Chip(label: l.weakest, element: c.weakestElement, lang: lang),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── 오늘의 운세 ──────────────────────────────────────────
          Text(l.todayFortune, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.tertiaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '${DateFormat.yMMMMEEEEd(lang).format(f.date)} · ${l.todayPillar(f.today.toString())}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onTertiaryContainer),
                  ),
                  const SizedBox(height: 10),
                  Text('${f.score}',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onTertiaryContainer,
                        height: 1,
                      )),
                  Text(l.fortuneIndex,
                      style: theme.textTheme.labelLarge?.copyWith(color: cs.onTertiaryContainer)),
                  const SizedBox(height: 8),
                  StarRating(score: f.stars, size: 26),
                  const SizedBox(height: 12),
                  Text(
                    SajuTexts.tenGodNames[f.god.index].of(lang),
                    style: theme.textTheme.labelLarge?.copyWith(color: cs.onTertiaryContainer, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    f.text.of(lang),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: cs.onTertiaryContainer, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _LuckyTile(label: l.luckyNumber, value: '${f.luckyNumber}', icon: Icons.tag),
              const SizedBox(width: 10),
              _LuckyTile(label: l.luckyColor, value: f.luckyColor.of(lang), icon: Icons.palette_outlined),
              const SizedBox(width: 10),
              _LuckyTile(label: l.luckyDirection, value: f.luckyDirection.of(lang), icon: Icons.explore_outlined),
            ],
          ),
          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: _openDetail,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            icon: const Icon(Icons.auto_awesome),
            label: Text(l.seeDetail),
          ),
        ],
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final FiveElement element;
  final String lang;
  const _Chip({required this.label, required this.element, required this.lang});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ElementStyle.accentOf(element).withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 12, height: 12,
              decoration: BoxDecoration(color: ElementStyle.accentOf(element), shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text('$label · ${SajuTexts.elementShort[element.index].of(lang)}',
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}

class _LuckyTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _LuckyTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: cs.primary, size: 20),
            const SizedBox(height: 6),
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
