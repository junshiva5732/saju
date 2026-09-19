# 나의 사주팔자 (saju)

생년월일시 기반 사주(四柱) 원국 · 오행 · 십신 풀이 + 오늘의 운세 앱. AdMob 광고(배너 / 전면)로 수익화.
Flutter 로 작성, Android + iOS 대상. 한국어 · 영어 · 일본어 · 중국어(간체) 지원.
패키지 `com.jun5731.saju`. 구조는 [daily_fortune](https://github.com/junshiva5732/daily_fortune) 과 동일.

## 구조

```
lib/
  main.dart                    앱 진입, 테마, 온보딩 분기 (+ 웹 전용 ?demo=1&screen=… 스크린샷 모드)
  saju/solar_terms.dart        24절기 시각 천문 계산 (Meeus 저정밀 태양 황경, 오차 ≈ 2~6분)
  saju/saju.dart               사주 계산: 연·월·일·시주, 십신, 지지 관계, 오행 분포
  data/saju_texts.dart         해석 콘텐츠 × 4개 언어 (T 클래스 병기): 천간·지지·오행·일간 성격·십신·오늘의 운세
  services/saju_service.dart   출생 정보 저장(prefs) + 원국·오늘의 운세 계산
  services/notification_service.dart 매일 아침 알림 (7일치 개별 예약)
  ads/ad_ids.dart              AdMob 광고 단위 ID (디버그=테스트 ID, 릴리즈=실제 ID)  ← 출시 전 교체
  ads/ad_manager.dart          전면 광고 로드/노출 싱글톤 (하루 1회 게이트)
  widgets/banner_ad_widget.dart 하단 적응형 배너 (웹은 자리표시자)
  widgets/pillar_table.dart    사주 원국 표 + 오행 막대
  l10n/app_*.arb               UI 문자열 (tool/gen_arb.py 가 생성) → flutter gen-l10n
  screens/                     settings(온보딩 겸용) · home · detail · share_card
tool/
  verify_saju.dart / .py       사주 계산 검증 (lunar_python 과 2,600 케이스 대조, 절기 경계 ±6분 제외 전부 일치)
  gen_arb.py                   ARB 4개 언어 생성
  make_icon.py                 아이콘 원본 (Pillow) → dart run flutter_launcher_icons
  capture_web.py               웹 빌드를 Chrome 헤드리스(CDP)로 1080×1920 캡처 → store/raw
  make_store_assets.py         512 아이콘 · 1024×500 피처 그래픽 · 캡션 스크린샷 4장
store/                         listing.md(한국어 + Play Console 양식 답변) · listing_i18n.md(en/ja/zh)
docs/privacy-policy.html       개인정보처리방침 (GitHub Pages)
```

## 사주 계산 규칙

- 연주: 입춘(태양 황경 315°) 시각 기준. 월주: 12절(節) 시각 기준, 월간은 오호둔.
- 일주: 로컬 자정 기준 (2000-01-01 = 戊午). 23시 이후는 다음 날(자시 = 하루의 시작).
- 시주: 오서둔. "태어난 시각 모름"이면 시주 없이 6글자.
- 진태양시 보정: 설정에서 켜면 출생 시각 -30분 (한국 127.5°E 기준). 기본값은 한국어 로케일만 켬.
- 십신: 지지는 지장간 본기(本氣) 기준. 오행 개수는 천간 + 지지 본기 8글자(또는 6글자).
- 오늘의 운세: 오늘 일진 천간의 십신 → 기본 점수 + 일지와의 육합/삼합/충 가중 + 날짜 해시 ±4.

## 광고 노출 지점

| 위치 | 종류 | 동작 |
|---|---|---|
| 홈·상세 하단 | 배너 | 항상 표시 |
| "상세 해석 보기" 탭 | 전면 | **하루 첫 1회만** (`AdManager.showInterstitialOncePerDayThen`) |
| 설정 "저장" | 전면 | 매번 (온보딩 제외) |

보상형 광고는 쓰지 않는다.

## 개발 빌드

```bash
flutter pub get
flutter analyze
flutter build apk --debug
```

### 이 PC (Windows ARM64) 메모
- **Android 에뮬레이터 없음** (구글이 windows-arm64 빌드를 제공하지 않음, WSA 는 Snapdragon X 에서 부팅 실패).
  → UI 검증은 웹 빌드: `flutter build web && python -m http.server 8765 -d build/web` 후 Chrome 폰 뷰포트.
  → 실기기·광고 검증은 Play Console 사전 출시 보고서.
- Gradle "Unable to establish loopback connection" → `android/gradlew.bat` 상단에
  `JAVA_TOOL_OPTIONS=-Djdk.net.unixdomain.tmpdir=C:/tmp` 를 넣어 두었다 (`C:\tmp` 필요).
- Flutter 3.47 / Gradle 9.3 / AGP 9.1 / JDK 17 (ARM64).

## 출시 체크리스트

### 1. AdMob
- [ ] https://admob.google.com 에서 앱 등록 (Android) — 광고 단위 만들 때 **"파트너 입찰" 체크 금지**
- [ ] 광고 단위: 배너 / 전면 — 보상형은 사용 안 함
- [ ] `lib/ads/ad_ids.dart` 의 `_androidReal` 을 실제 ID 로 교체
- [ ] `android/app/src/main/AndroidManifest.xml` 의 `APPLICATION_ID` 교체 (지금은 Google 샘플 앱 ID)
- [ ] 개발 중 실제 ID로 광고 클릭 금지

### 2. 개인정보 / 정책
- [ ] 개인정보처리방침: https://junshiva5732.github.io/saju/privacy-policy.html (원본 `docs/privacy-policy.html`, GitHub Pages)

### 3. Android 출시
- [x] 릴리즈 서명 키: `android/upload-keystore.jks` + `android/key.properties` (git 제외 — **반드시 백업**)
- [x] 앱 아이콘: `tool/make_icon.py` → `dart run flutter_launcher_icons`
- [x] compileSdk / targetSdk 36, desugaring, R8
- [ ] `flutter build appbundle --release` → `build/app/outputs/bundle/release/app-release.aab`
- [ ] 스토어 등록 정보: `store/` (아이콘·피처 그래픽·스크린샷 4장·설명 4개 언어)
- [ ] Play Console: 비공개 테스트(12명 × 14일) → 프로덕션
- 새 버전 올릴 때마다 `pubspec.yaml` 의 `version: x.y.z+N` 의 N 을 올릴 것

### 4. iOS (Mac 필요)
- [ ] `ios/Runner/Info.plist` 에 `GADApplicationIdentifier` 추가, 앱 이름 lproj, ATT

## 상태

- 2026-09-19: 앱 구현 완료, 웹 미리보기 검증, 아이콘·서명·스토어 자산 생성.
