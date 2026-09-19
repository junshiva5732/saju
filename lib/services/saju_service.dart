import 'package:shared_preferences/shared_preferences.dart';

import '../data/saju_texts.dart';
import '../saju/saju.dart';

/// 하루치 운세. 오늘의 일진(日辰) 천간이 내 일간에 대해 어떤 십신인지로 결정된다.
class DailyFortune {
  final DateTime date;
  final Pillar today;
  final TenGod god;
  final BranchRelation relation;
  final int score; // 0~100
  final int luckyNumber;
  final FiveElement luckyElement;

  const DailyFortune({
    required this.date,
    required this.today,
    required this.god,
    required this.relation,
    required this.score,
    required this.luckyNumber,
    required this.luckyElement,
  });

  T get text => SajuTexts.dailyByGod[god.index];
  T get relationText => SajuTexts.dailyByRelation[relation.index];
  T get luckyColor => SajuTexts.elementColors[luckyElement.index];
  T get luckyDirection => SajuTexts.elementDirections[luckyElement.index];

  /// 별 1~5개.
  int get stars => ((score - 30) / 14).ceil().clamp(1, 5);
}

/// 사용자 프로필(생년월일시) 저장 + 사주·오늘의 운세 계산.
class SajuService {
  static const _kYear = 'birth_year';
  static const _kMonth = 'birth_month';
  static const _kDay = 'birth_day';
  static const _kHour = 'birth_hour';
  static const _kMinute = 'birth_minute';
  static const _kHourKnown = 'birth_hour_known';
  static const _kSolarCorrection = 'solar_correction';

  final SharedPreferences _prefs;
  SajuService(this._prefs);

  // ------------------------------------------------------------- 프로필

  /// 입력한 출생 시각(보정 전). 없으면 null.
  DateTime? get birth {
    final y = _prefs.getInt(_kYear);
    final m = _prefs.getInt(_kMonth);
    final d = _prefs.getInt(_kDay);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d, _prefs.getInt(_kHour) ?? 12, _prefs.getInt(_kMinute) ?? 0);
  }

  bool get hourKnown => _prefs.getBool(_kHourKnown) ?? true;

  /// 진태양시 보정(-30분). 한국(동경 127.5°)은 표준시(135°)보다 약 30분 늦으므로
  /// 전통 만세력은 출생 시각에서 30분을 뺀다. 기본값은 언어가 한국어일 때만 켬.
  bool get solarCorrection => _prefs.getBool(_kSolarCorrection) ?? false;

  Future<void> save({
    required DateTime birth,
    required bool hourKnown,
    required bool solarCorrection,
  }) async {
    await _prefs.setInt(_kYear, birth.year);
    await _prefs.setInt(_kMonth, birth.month);
    await _prefs.setInt(_kDay, birth.day);
    await _prefs.setInt(_kHour, birth.hour);
    await _prefs.setInt(_kMinute, birth.minute);
    await _prefs.setBool(_kHourKnown, hourKnown);
    await _prefs.setBool(_kSolarCorrection, solarCorrection);
  }

  // ------------------------------------------------------------- 계산

  /// 사주 원국. 프로필이 없으면 null.
  SajuChart? get chart {
    final b = birth;
    if (b == null) return null;
    var local = b;
    if (hourKnown && solarCorrection) local = local.subtract(const Duration(minutes: 30));
    if (!hourKnown) local = DateTime(b.year, b.month, b.day, 12);
    return Saju.calc(local, DateTime.now().timeZoneOffset, hourKnown: hourKnown);
  }

  /// 프로세스가 바뀌어도 같은 값을 내는 결정적 해시.
  static int _stableHash(List<int> parts) =>
      parts.fold(17, (h, v) => (h * 31 + v) & 0x7fffffff);

  DailyFortune fortuneFor(SajuChart chart, DateTime date) {
    final today = Saju.dayPillar(date);
    final god = Saju.tenGod(chart.day.stem, today.stem);
    final relation = Saju.branchRelation(chart.day.branch, today.branch);
    final h = _stableHash([date.year, date.month, date.day, chart.day.index, chart.year.index]);
    final jitter = (h % 9) - 4; // -4..4
    final score = (SajuTexts.dailyBaseScore[god.index] +
            SajuTexts.relationScore[relation.index] +
            jitter)
        .clamp(30, 99);
    return DailyFortune(
      date: date,
      today: today,
      god: god,
      relation: relation,
      score: score,
      luckyNumber: (h ~/ 9) % 45 + 1,
      luckyElement: chart.weakestElement,
    );
  }
}
