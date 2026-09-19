// 검증용: stdin 으로 "y m d H M" 을 받아 사주 4기둥을 출력한다 (UTC+8 기준).
// python tool/verify_saju.py 가 lunar_python 결과와 대조한다.
import 'dart:convert';
import 'dart:io';

import 'package:saju/saju/saju.dart';

void main() {
  final lines = stdin.transform(utf8.decoder).transform(const LineSplitter());
  lines.listen((line) {
    final p = line.trim().split(RegExp(r'\s+')).map(int.parse).toList();
    if (p.length < 5) return;
    final c = Saju.calc(DateTime(p[0], p[1], p[2], p[3], p[4]), const Duration(hours: 8));
    stdout.writeln('$line => ${c.year} ${c.month} ${c.day} ${c.hour}');
  });
}
