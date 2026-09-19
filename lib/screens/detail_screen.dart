import 'package:flutter/material.dart';

import '../data/saju_texts.dart';
import '../l10n/app_localizations.dart';
import '../l10n/lang.dart';
import '../saju/saju.dart';
import '../services/saju_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/pillar_table.dart';
import '../widgets/star_rating.dart';

/// 상세 해석: 일간 성격 · 오행 분석 · 십신 · 오늘의 운세.
class DetailScreen extends StatelessWidget {
  final SajuChart chart;
  final DailyFortune fortune;
  const DetailScreen({super.key, required this.chart, required this.fortune});

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final c = chart;
    final f = fortune;
    final ds = c.day.stem;
    final counts = c.elementCounts;
    final strong = c.strongestElement;
    final weak = c.weakestElement;

    return Scaffold(
      appBar: AppBar(title: Text(l.detailTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // ── 일간 성격 ────────────────────────────────────────────
          _Section(
            icon: Icons.person_outline,
            title: l.sectionPersonality,
            color: cs.primaryContainer,
            onColor: cs.onPrimaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(SajuTexts.stemEmoji[ds], style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${Saju.stemHanja[ds]} ${SajuTexts.stemNames[ds].of(lang)} · ${SajuTexts.stemImages[ds].of(lang)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: cs.onPrimaryContainer),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(SajuTexts.dayMaster[ds].of(lang),
                    style: theme.textTheme.bodyLarge?.copyWith(color: cs.onPrimaryContainer, height: 1.6)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── 오행 분석 ────────────────────────────────────────────
          _Section(
            icon: Icons.donut_large_outlined,
            title: l.sectionElements,
            color: cs.surfaceContainerHigh,
            onColor: cs.onSurface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElementBars(chart: c),
                const SizedBox(height: 12),
                _ElementNote(
                  element: strong,
                  label: '${l.strongest} · ${SajuTexts.elementNames[strong.index].of(lang)} (${counts[strong]})',
                  text: SajuTexts.elementStrong[strong.index].of(lang),
                ),
                const SizedBox(height: 10),
                _ElementNote(
                  element: weak,
                  label: '${l.weakest} · ${SajuTexts.elementNames[weak.index].of(lang)} (${counts[weak]})',
                  text: SajuTexts.elementWeak[weak.index].of(lang),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── 십신 ────────────────────────────────────────────────
          _Section(
            icon: Icons.grid_view_outlined,
            title: l.sectionTenGods,
            color: cs.surfaceContainerHigh,
            onColor: cs.onSurface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final g in c.presentGods) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: cs.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(SajuTexts.tenGodNames[g.index].of(lang),
                            style: theme.textTheme.labelMedium?.copyWith(
                                color: cs.onSecondaryContainer, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(SajuTexts.tenGodMeaning[g.index].of(lang),
                            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                Text(_positions(l, lang),
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── 오늘의 운세 ──────────────────────────────────────────
          _Section(
            icon: Icons.wb_sunny_outlined,
            title: l.sectionToday,
            color: cs.tertiaryContainer,
            onColor: cs.onTertiaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(l.todayPillar(f.today.toString()),
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: cs.onTertiaryContainer)),
                    const Spacer(),
                    StarRating(score: f.stars, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${SajuTexts.tenGodNames[f.god.index].of(lang)} · ${l.fortuneIndex} ${f.score}',
                  style: theme.textTheme.labelLarge?.copyWith(color: cs.onTertiaryContainer),
                ),
                const SizedBox(height: 10),
                Text(f.text.of(lang),
                    style: theme.textTheme.bodyLarge?.copyWith(color: cs.onTertiaryContainer, height: 1.6)),
                if (f.relation != BranchRelation.none) ...[
                  const SizedBox(height: 10),
                  Text(f.relationText.of(lang),
                      style: theme.textTheme.bodyMedium?.copyWith(color: cs.onTertiaryContainer, height: 1.5)),
                ],
                const SizedBox(height: 10),
                Text(
                  '🍀 ${l.luckyNumber} ${f.luckyNumber} · ${l.luckyColor} ${f.luckyColor.of(lang)} · ${l.luckyDirection} ${f.luckyDirection.of(lang)}',
                  style: theme.textTheme.bodySmall?.copyWith(color: cs.onTertiaryContainer),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.detailFooter,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }

  /// "연주 천간 정관 · 연주 지지 편인 …" 형태의 위치 요약.
  String _positions(L10n l, String lang) {
    final labels = [l.pillarHour, l.pillarDay, l.pillarMonth, l.pillarYear];
    final parts = <String>[];
    for (var i = 3; i >= 0; i--) {
      final p = chart.pillars[i];
      if (p == null) continue;
      final s = chart.stemGod(p);
      final b = chart.branchGod(p);
      if (s != null) {
        parts.add('${l.godAt(labels[i], l.stemLabel)} ${SajuTexts.tenGodShort[s.index].of(lang)}');
      }
      if (b != null) {
        parts.add('${l.godAt(labels[i], l.branchLabel)} ${SajuTexts.tenGodShort[b.index].of(lang)}');
      }
    }
    return parts.join(' · ');
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color onColor;
  final Widget child;
  const _Section({
    required this.icon,
    required this.title,
    required this.color,
    required this.onColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: onColor),
                const SizedBox(width: 10),
                Text(title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: onColor)),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _ElementNote extends StatelessWidget {
  final FiveElement element;
  final String label;
  final String text;
  const _ElementNote({required this.element, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ElementStyle.accentOf(element).withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: ElementStyle.accentOf(element), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(text, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
