import 'package:flutter/material.dart';

import '../data/saju_texts.dart';
import '../l10n/app_localizations.dart';
import '../l10n/lang.dart';
import '../saju/saju.dart';

/// 오행별 색 (셀 배경 / 글자).
class ElementStyle {
  ElementStyle._();

  static const bg = [
    Color(0xFF2E7D32), // 木
    Color(0xFFC62828), // 火
    Color(0xFFF9A825), // 土
    Color(0xFFE6E6E6), // 金
    Color(0xFF1565C0), // 水
  ];

  static const fg = [
    Colors.white,
    Colors.white,
    Color(0xFF3B2A00),
    Color(0xFF333333),
    Colors.white,
  ];

  /// 막대·칩처럼 밝은 배경 위에 쓰는 진한 색 (金 은 셀 배경이 너무 밝아 따로 둔다).
  static const accent = [
    Color(0xFF2E7D32),
    Color(0xFFC62828),
    Color(0xFFF9A825),
    Color(0xFF8A8A8A),
    Color(0xFF1565C0),
  ];

  static Color bgOf(FiveElement e) => bg[e.index];
  static Color fgOf(FiveElement e) => fg[e.index];
  static Color accentOf(FiveElement e) => accent[e.index];
}

/// 사주 원국 표. 왼쪽부터 시주 · 일주 · 월주 · 연주 (전통 표기 순서).
class PillarTable extends StatelessWidget {
  final SajuChart chart;

  /// 공유 카드처럼 고정 색 배경 위에 그릴 때 true (라벨 색을 밝게).
  final bool onDark;
  const PillarTable({super.key, required this.chart, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final labels = [l.pillarHour, l.pillarDay, l.pillarMonth, l.pillarYear];
    final cs = Theme.of(context).colorScheme;
    final labelColor = onDark ? const Color(0xFFD9CCFF) : cs.onSurfaceVariant;

    return Row(
      children: [
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _PillarColumn(
              label: labels[i],
              pillar: chart.pillars[i],
              isDay: i == 1,
              stemGod: chart.stemGod(chart.pillars[i]),
              branchGod: chart.branchGod(chart.pillars[i]),
              lang: lang,
              labelColor: labelColor,
              unknownText: l.unknownHour,
              dayMasterText: l.dayMasterLabel,
            ),
          ),
        ],
      ],
    );
  }
}

class _PillarColumn extends StatelessWidget {
  final String label;
  final Pillar? pillar;
  final bool isDay;
  final TenGod? stemGod;
  final TenGod? branchGod;
  final String lang;
  final Color labelColor;
  final String unknownText;
  final String dayMasterText;

  const _PillarColumn({
    required this.label,
    required this.pillar,
    required this.isDay,
    required this.stemGod,
    required this.branchGod,
    required this.lang,
    required this.labelColor,
    required this.unknownText,
    required this.dayMasterText,
  });

  @override
  Widget build(BuildContext context) {
    final p = pillar;
    final small = TextStyle(fontSize: 11, color: labelColor, height: 1.2);
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: labelColor)),
        const SizedBox(height: 6),
        Text(
          p == null ? '' : (isDay ? dayMasterText : SajuTexts.tenGodShort[stemGod!.index].of(lang)),
          style: small,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        _Cell(
          hanja: p == null ? '?' : Saju.stemHanja[p.stem],
          reading: p == null ? unknownText : SajuTexts.stemNames[p.stem].of(lang),
          element: p?.stemElement,
          highlight: isDay,
        ),
        const SizedBox(height: 6),
        _Cell(
          hanja: p == null ? '?' : Saju.branchHanja[p.branch],
          reading: p == null ? unknownText : SajuTexts.branchNames[p.branch].of(lang),
          element: p?.branchElement,
          highlight: false,
        ),
        const SizedBox(height: 4),
        Text(
          p == null ? '' : SajuTexts.tenGodShort[branchGod!.index].of(lang),
          style: small,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  final String hanja;
  final String reading;
  final FiveElement? element;
  final bool highlight;
  const _Cell({required this.hanja, required this.reading, required this.element, required this.highlight});

  @override
  Widget build(BuildContext context) {
    final e = element;
    final bg = e == null ? Colors.grey.shade400 : ElementStyle.bgOf(e);
    final fg = e == null ? Colors.white : ElementStyle.fgOf(e);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: highlight ? Border.all(color: const Color(0xFFFFD656), width: 3) : null,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(hanja,
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: fg, height: 1.1)),
            ),
            Text(reading,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: fg.withValues(alpha: 0.9))),
          ],
        ),
      ),
    );
  }
}

/// 오행 분포 막대.
class ElementBars extends StatelessWidget {
  final SajuChart chart;
  const ElementBars({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    final lang = AppLang.of(context);
    final counts = chart.elementCounts;
    final total = chart.characterCount;
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final e in FiveElement.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Text(SajuTexts.elementShort[e.index].of(lang),
                      style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: counts[e]! / total,
                      minHeight: 14,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      color: ElementStyle.accentOf(e),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 20,
                  child: Text('${counts[e]}', textAlign: TextAlign.right, style: theme.textTheme.labelLarge),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
