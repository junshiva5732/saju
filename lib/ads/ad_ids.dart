import 'dart:io';

import 'package:flutter/foundation.dart';

/// AdMob 광고 단위 ID.
///
/// - 디버그 빌드(`flutter run`, `--debug`): 항상 Google 공식 테스트 ID.
///   개발 중 실제 광고를 클릭하면 무효 트래픽으로 계정이 정지될 수 있으므로.
/// - 릴리즈 빌드(`--release`, 스토어 배포): 실제 ID.
///
/// iOS 실제 ID 는 아직 없음. iOS 출시 전 AdMob 에 iOS 앱을 추가하고
/// 아래 `_iosReal` 3개와 ios/Runner/Info.plist 의 GADApplicationIdentifier 를 교체할 것.
class AdIds {
  AdIds._();

  // ── 실제 ID ─────────────────────────────────────────────────────────
  // TODO(AdMob): 앱 등록 후 실제 배너/전면 광고 단위 ID 로 교체. 교체 전까지는
  // 릴리즈 빌드도 테스트 ID 를 쓴다 (실제 ID 3개는 AndroidManifest 의 APPLICATION_ID 포함).
  static const _androidReal = _androidTest;

  // TODO(iOS): AdMob 에서 iOS 앱 등록 후 교체
  static const _iosReal = _iosTest;

  // ── Google 공식 테스트 ID ────────────────────────────────────────────
  static const _androidTest = _Ids(
    banner: 'ca-app-pub-3940256099942544/6300978111',
    interstitial: 'ca-app-pub-3940256099942544/1033173712',
  );
  static const _iosTest = _Ids(
    banner: 'ca-app-pub-3940256099942544/2934735716',
    interstitial: 'ca-app-pub-3940256099942544/4411468910',
  );

  static _Ids get _current {
    if (kIsWeb) return _androidTest; // 웹은 개발 미리보기 전용 (광고 미지원)
    if (kReleaseMode) return Platform.isAndroid ? _androidReal : _iosReal;
    return Platform.isAndroid ? _androidTest : _iosTest;
  }

  static String get banner => _current.banner;
  static String get interstitial => _current.interstitial;
}

class _Ids {
  final String banner;
  final String interstitial;
  const _Ids({required this.banner, required this.interstitial});
}
