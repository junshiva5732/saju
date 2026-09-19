import 'dart:math';

/// 태양 황경 기반 24절기 계산.
///
/// 사주의 연주(입춘)·월주(12절) 경계는 절기 "시각"으로 정해지므로 표가 아니라
/// 천문 계산으로 구한다. Meeus, *Astronomical Algorithms* 25장의 저정밀 태양 위치
/// 공식을 쓴다 (오차 ≈ 0.01° ≈ 15분). 절기 경계 ±15분 안의 출생만 영향을 받는다.
class SolarTerms {
  SolarTerms._();

  static double _rad(double deg) => deg * pi / 180;
  static double _norm(double deg) => deg - 360 * (deg / 360).floorToDouble();

  /// 율리우스일(UT). [dt] 는 UTC 기준으로 해석한다.
  static double julianDay(DateTime dt) {
    final u = dt.toUtc();
    var y = u.year;
    var m = u.month;
    final d = u.day +
        (u.hour + (u.minute + (u.second + u.millisecond / 1000) / 60) / 60) / 24;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + d + b - 1524.5;
  }

  /// 율리우스일 → UTC DateTime.
  static DateTime fromJulianDay(double jd) {
    final ms = ((jd - 2440587.5) * 86400000).round();
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }

  /// 겉보기 태양 황경(도). [jd] 는 UT 율리우스일. ΔT(≈70초) 는 무시한다.
  static double sunLongitude(double jd) {
    final t = (jd - 2451545.0) / 36525;
    final l0 = 280.46646 + 36000.76983 * t + 0.0003032 * t * t;
    final m = _rad(357.52911 + 35999.05029 * t - 0.0001537 * t * t);
    final c = (1.914602 - 0.004817 * t - 0.000014 * t * t) * sin(m) +
        (0.019993 - 0.000101 * t) * sin(2 * m) +
        0.000289 * sin(3 * m);
    final omega = _rad(125.04 - 1934.136 * t);
    return _norm(l0 + c - 0.00569 - 0.00478 * sin(omega));
  }

  /// 해당 연도(그레고리력)에 태양 황경이 [longitude]° 가 되는 순간(UTC).
  ///
  /// [longitude] 는 15° 단위 절기 각도. 결과는 항상 그레고리력 [year] 안의 순간이다
  /// (285° 소한 = 1월 초 … 255° 대설 = 12월 초).
  /// 뉴턴 반복으로 수렴시킨다 (태양은 하루 ≈0.9856° 이동).
  static DateTime termInstant(int year, int longitude) {
    // 초기 추정: 춘분(0°)=3/21 기준. 285°(소한)~345°(경칩) 는 같은 해 1~3월이므로 음수 오프셋.
    final offsetDeg = longitude >= 285 ? longitude - 360 : longitude;
    var jd = julianDay(DateTime.utc(year, 3, 21)) + offsetDeg * 365.2422 / 360;
    for (var i = 0; i < 6; i++) {
      var diff = longitude - sunLongitude(jd);
      diff -= 360 * (diff / 360).roundToDouble();
      jd += diff / 0.98565;
      if (diff.abs() < 1e-6) break;
    }
    return fromJulianDay(jd);
  }

  /// 12절(節) 의 황경. 인덱스 0 = 입춘(寅月 시작) … 11 = 소한(丑月 시작).
  static const monthTermLongitudes = [315, 345, 15, 45, 75, 105, 135, 165, 195, 225, 255, 285];
}
