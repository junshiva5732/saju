import 'solar_terms.dart';

/// 오행. 인덱스 = 상생 순서(木→火→土→金→水→木).
enum FiveElement { wood, fire, earth, metal, water }

/// 십신(十神). 일간과의 관계.
enum TenGod {
  friend, // 비견
  rivalry, // 겁재
  eatingGod, // 식신
  hurtingOfficer, // 상관
  indirectWealth, // 편재
  directWealth, // 정재
  sevenKillings, // 편관
  directOfficer, // 정관
  indirectResource, // 편인
  directResource, // 정인
}

/// 지지 사이의 관계 (오늘의 운세용).
enum BranchRelation { none, sixHarmony, trine, clash }

/// 천간(0..9) + 지지(0..11) 한 기둥.
class Pillar {
  final int stem;
  final int branch;
  const Pillar(this.stem, this.branch);

  /// 육십갑자 인덱스 (甲子=0).
  factory Pillar.fromIndex(int i) => Pillar(i % 10, i % 12);

  int get index {
    for (var i = 0; i < 60; i++) {
      if (i % 10 == stem && i % 12 == branch) return i;
    }
    throw StateError('invalid pillar $stem/$branch');
  }

  FiveElement get stemElement => Saju.stemElement(stem);
  FiveElement get branchElement => Saju.branchElement(branch);

  @override
  String toString() => '${Saju.stemHanja[stem]}${Saju.branchHanja[branch]}';
}

/// 사주 원국 + 파생 정보.
class SajuChart {
  final DateTime birth; // 보정 적용 후 출생 시각(로컬)
  final Pillar year;
  final Pillar month;
  final Pillar day;
  final Pillar? hour; // 출생 시각 모르면 null

  const SajuChart({
    required this.birth,
    required this.year,
    required this.month,
    required this.day,
    this.hour,
  });

  int get dayStem => day.stem;
  FiveElement get dayElement => Saju.stemElement(day.stem);
  bool get dayIsYang => day.stem.isEven;

  /// 시주 → 일주 → 월주 → 연주 순 (표시는 오른쪽이 연주).
  List<Pillar?> get pillars => [hour, day, month, year];

  /// 오행 개수 (천간 + 지지 본기). 시주가 없으면 6글자 기준.
  Map<FiveElement, int> get elementCounts {
    final m = {for (final e in FiveElement.values) e: 0};
    for (final p in pillars) {
      if (p == null) continue;
      m[p.stemElement] = m[p.stemElement]! + 1;
      m[p.branchElement] = m[p.branchElement]! + 1;
    }
    return m;
  }

  int get characterCount => hour == null ? 6 : 8;

  /// 가장 많은 오행 / 가장 적은(없는) 오행. 동률이면 상생 순서상 앞의 것.
  FiveElement get strongestElement {
    final c = elementCounts;
    return FiveElement.values.reduce((a, b) => c[b]! > c[a]! ? b : a);
  }

  FiveElement get weakestElement {
    final c = elementCounts;
    return FiveElement.values.reduce((a, b) => c[b]! < c[a]! ? b : a);
  }

  /// 각 기둥 천간의 십신 (일간 자신은 null).
  TenGod? stemGod(Pillar? p) {
    if (p == null || identical(p, day)) return null;
    return Saju.tenGod(day.stem, p.stem);
  }

  /// 각 기둥 지지의 십신 (지장간 본기 기준).
  TenGod? branchGod(Pillar? p) {
    if (p == null) return null;
    return Saju.tenGod(day.stem, Saju.branchMainStem[p.branch]);
  }

  /// 원국에 등장하는 십신 (중복 제거, 등장 순).
  List<TenGod> get presentGods {
    final out = <TenGod>[];
    for (final p in pillars) {
      if (p == null) continue;
      final s = stemGod(p);
      final b = branchGod(p);
      if (s != null && !out.contains(s)) out.add(s);
      if (b != null && !out.contains(b)) out.add(b);
    }
    return out;
  }

  /// 띠 (연지 기준).
  int get zodiacIndex => year.branch;
}

/// 사주 계산기.
class Saju {
  Saju._();

  static const stemHanja = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  static const branchHanja = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  static FiveElement stemElement(int stem) => FiveElement.values[stem ~/ 2];

  static const _branchElements = [
    FiveElement.water, FiveElement.earth, FiveElement.wood, FiveElement.wood, FiveElement.earth, FiveElement.fire,
    FiveElement.fire, FiveElement.earth, FiveElement.metal, FiveElement.metal, FiveElement.earth, FiveElement.water,
  ];
  static FiveElement branchElement(int branch) => _branchElements[branch];

  /// 지장간 본기(本氣): 子癸 丑己 寅甲 卯乙 辰戊 巳丙 午丁 未己 申庚 酉辛 戌戊 亥壬
  static const branchMainStem = [9, 5, 0, 1, 4, 2, 3, 5, 6, 7, 4, 8];

  /// 일간 [dayStem] 에서 본 [other] 천간의 십신.
  static TenGod tenGod(int dayStem, int other) {
    final d = dayStem ~/ 2, o = other ~/ 2;
    final samePolarity = (dayStem % 2) == (other % 2);
    final rel = (o - d + 5) % 5; // 0 같음, 1 내가 생함, 2 내가 극함, 3 나를 극함, 4 나를 생함
    return switch (rel) {
      0 => samePolarity ? TenGod.friend : TenGod.rivalry,
      1 => samePolarity ? TenGod.eatingGod : TenGod.hurtingOfficer,
      2 => samePolarity ? TenGod.indirectWealth : TenGod.directWealth,
      3 => samePolarity ? TenGod.sevenKillings : TenGod.directOfficer,
      _ => samePolarity ? TenGod.indirectResource : TenGod.directResource,
    };
  }

  /// 지지 관계: 육합 / 삼합 / 충 / 없음.
  static BranchRelation branchRelation(int a, int b) {
    final diff = (a - b).abs();
    if (diff == 6) return BranchRelation.clash;
    if ((a + b) % 12 == 1) return BranchRelation.sixHarmony; // 子丑 寅亥 卯戌 辰酉 巳申 午未
    if (diff == 4 || diff == 8) return BranchRelation.trine;
    return BranchRelation.none;
  }

  // ---------------------------------------------------------------- 기둥 계산

  /// 로컬 자정 기준 일진. 1 일 = 60 갑자 한 칸. 2000-01-01 = 戊午(54).
  static Pillar dayPillar(DateTime localDate) {
    final jdn = _civilJdn(localDate.year, localDate.month, localDate.day);
    return Pillar.fromIndex((jdn + 49) % 60);
  }

  static int _civilJdn(int y, int m, int d) {
    final a = (14 - m) ~/ 12;
    final yy = y + 4800 - a;
    final mm = m + 12 * a - 3;
    return d + (153 * mm + 2) ~/ 5 + 365 * yy + yy ~/ 4 - yy ~/ 100 + yy ~/ 400 - 32045;
  }

  /// [local] 출생 시각(보정 완료, 로컬) 과 그 지역의 UTC 오프셋으로 사주를 만든다.
  ///
  /// - 연주: 입춘(315°) 시각 이전이면 전년.
  /// - 월주: 12절 시각 기준. 월간은 오호둔(연간에서 파생).
  /// - 일주: 23시 이후는 다음 날로 본다(자시 = 하루의 시작).
  /// - 시주: 오서둔(일간에서 파생). [hourKnown] 이 false 면 null.
  static SajuChart calc(DateTime local, Duration utcOffset, {bool hourKnown = true}) {
    var civil = DateTime(local.year, local.month, local.day, local.hour, local.minute);
    if (hourKnown && civil.hour >= 23) civil = civil.add(const Duration(hours: 1));
    final utc = DateTime.utc(local.year, local.month, local.day, local.hour, local.minute).subtract(utcOffset);

    // 연주
    var solarYear = local.year;
    if (utc.isBefore(SolarTerms.termInstant(local.year, 315))) solarYear -= 1;
    final yearPillar = Pillar.fromIndex((solarYear - 4) % 60);

    // 월주: 입춘부터 12절을 순서대로 지나며 마지막으로 지난 절의 인덱스
    var monthIdx = 0; // 0 = 寅月
    for (var i = 0; i < 12; i++) {
      final lon = SolarTerms.monthTermLongitudes[i];
      // 입춘(2월)~대설(12월)은 solarYear, 소한(1월)만 다음 해
      final termYear = i == 11 ? solarYear + 1 : solarYear;
      final t = SolarTerms.termInstant(termYear, lon);
      if (!utc.isBefore(t)) monthIdx = i;
    }
    final monthStem = ((yearPillar.stem % 5) * 2 + 2 + monthIdx) % 10;
    final monthPillar = Pillar(monthStem, (monthIdx + 2) % 12);

    // 일주
    final dayP = dayPillar(DateTime(civil.year, civil.month, civil.day));

    // 시주
    Pillar? hourP;
    if (hourKnown) {
      final hb = ((local.hour + 1) ~/ 2) % 12;
      hourP = Pillar(((dayP.stem % 5) * 2 + hb) % 10, hb);
    }

    return SajuChart(birth: local, year: yearPillar, month: monthPillar, day: dayP, hour: hourP);
  }
}
