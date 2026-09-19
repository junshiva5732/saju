import 'package:flutter_test/flutter_test.dart';
import 'package:saju/saju/saju.dart';
import 'package:saju/saju/solar_terms.dart';

// 기준값은 lunar_python (tool/verify_saju.py) 으로 대조한 것. 모두 UTC+8 기준.
void main() {
  const cst = Duration(hours: 8);

  test('2000-01-01 is 戊午 day', () {
    expect(Saju.dayPillar(DateTime(2000, 1, 1)).toString(), '戊午');
  });

  test('1990-01-01 11:30 → 己巳 丙子 丙寅 甲午', () {
    final c = Saju.calc(DateTime(1990, 1, 1, 11, 30), cst);
    expect([c.year, c.month, c.day, c.hour].map((p) => p.toString()).join(' '), '己巳 丙子 丙寅 甲午');
  });

  test('before 입춘 belongs to previous year', () {
    final before = Saju.calc(DateTime(2024, 2, 4, 10, 0), cst); // 입춘 2024-02-04 16:27 CST
    final after = Saju.calc(DateTime(2024, 2, 4, 18, 0), cst);
    expect(before.year.toString(), '癸卯');
    expect(after.year.toString(), '甲辰');
    expect(before.month.toString(), '乙丑');
    expect(after.month.toString(), '丙寅');
  });

  test('23:00 belongs to next day (子時 starts the day)', () {
    final c = Saju.calc(DateTime(2024, 1, 1, 23, 30), cst);
    expect(c.day.toString(), Saju.dayPillar(DateTime(2024, 1, 2)).toString());
    expect(c.hour!.branch, 0);
  });

  test('unknown hour has no hour pillar and 6 characters', () {
    final c = Saju.calc(DateTime(1985, 6, 15, 12), cst, hourKnown: false);
    expect(c.hour, isNull);
    expect(c.characterCount, 6);
  });

  test('입춘 2026 within a few minutes of 2026-02-04 04:02 CST', () {
    final t = SolarTerms.termInstant(2026, 315).add(cst);
    expect(t.difference(DateTime.utc(2026, 2, 4, 4, 2)).inMinutes.abs(), lessThan(10));
  });

  test('ten gods: 甲 day master', () {
    expect(Saju.tenGod(0, 0), TenGod.friend);
    expect(Saju.tenGod(0, 1), TenGod.rivalry);
    expect(Saju.tenGod(0, 2), TenGod.eatingGod);
    expect(Saju.tenGod(0, 3), TenGod.hurtingOfficer);
    expect(Saju.tenGod(0, 4), TenGod.indirectWealth);
    expect(Saju.tenGod(0, 5), TenGod.directWealth);
    expect(Saju.tenGod(0, 6), TenGod.sevenKillings);
    expect(Saju.tenGod(0, 7), TenGod.directOfficer);
    expect(Saju.tenGod(0, 8), TenGod.indirectResource);
    expect(Saju.tenGod(0, 9), TenGod.directResource);
  });

  test('branch relations', () {
    expect(Saju.branchRelation(2, 8), BranchRelation.clash); // 寅申
    expect(Saju.branchRelation(0, 1), BranchRelation.sixHarmony); // 子丑
    expect(Saju.branchRelation(2, 6), BranchRelation.trine); // 寅午
    expect(Saju.branchRelation(0, 2), BranchRelation.none);
  });
}
