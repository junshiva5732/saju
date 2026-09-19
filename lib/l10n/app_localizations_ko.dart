// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class L10nKo extends L10n {
  L10nKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '나의 사주팔자';

  @override
  String get onboardingTitle => '시작하기';

  @override
  String get settingsTitle => '설정';

  @override
  String get onboardingHeadline => '태어난 날짜와 시간을 알려주세요';

  @override
  String get onboardingBody =>
      '생년월일시로 사주 여덟 글자를 풀어 성격·오행·오늘의 운세를 보여드려요.\n입력한 정보는 기기에만 저장됩니다.';

  @override
  String get birthSection => '출생 정보';

  @override
  String get birthDate => '생년월일';

  @override
  String get birthDatePickerHelp => '생년월일 선택';

  @override
  String get birthTime => '태어난 시각';

  @override
  String get birthTimePickerHelp => '태어난 시각';

  @override
  String get hourUnknown => '태어난 시각을 몰라요';

  @override
  String get hourUnknownHint => '시주 없이 여섯 글자로 풀이해요';

  @override
  String get solarCorrection => '진태양시 보정 (-30분)';

  @override
  String get solarCorrectionHint => '한국 출생이면 켜두세요. 전통 만세력 방식이에요';

  @override
  String get notificationSection => '아침 알림';

  @override
  String get notificationToggleTitle => '매일 운세 알림';

  @override
  String get notificationToggleSubtitle => '오늘의 일진과 운세를 알려드려요';

  @override
  String get notificationTime => '알림 시간';

  @override
  String get notificationTimeHelp => '알림 시간';

  @override
  String get save => '저장';

  @override
  String get goSeeSaju => '내 사주 보러 가기';

  @override
  String get shareTooltip => '공유';

  @override
  String get settingsTooltip => '설정';

  @override
  String get myChart => '나의 사주 원국';

  @override
  String get pillarHour => '시주';

  @override
  String get pillarDay => '일주';

  @override
  String get pillarMonth => '월주';

  @override
  String get pillarYear => '연주';

  @override
  String get unknownHour => '모름';

  @override
  String get dayMasterLabel => '나의 일간';

  @override
  String dayMasterTitle(String name, String image) {
    return '$name · $image';
  }

  @override
  String get elementBalance => '오행 분포';

  @override
  String characterCount(int n) {
    return '$n글자 기준';
  }

  @override
  String get strongest => '강한 오행';

  @override
  String get weakest => '보완 오행';

  @override
  String get todayFortune => '오늘의 운세';

  @override
  String todayPillar(String pillar) {
    return '오늘의 일진 $pillar';
  }

  @override
  String get fortuneIndex => '운세 지수';

  @override
  String get luckyNumber => '행운의 숫자';

  @override
  String get luckyColor => '행운의 색';

  @override
  String get luckyDirection => '행운의 방향';

  @override
  String get seeDetail => '상세 해석 보기';

  @override
  String get detailTitle => '상세 해석';

  @override
  String get sectionPersonality => '일간으로 보는 성격';

  @override
  String get sectionElements => '오행 분석';

  @override
  String get sectionTenGods => '내 사주의 십신';

  @override
  String get sectionToday => '오늘의 운세 자세히';

  @override
  String godAt(String pillar, String part) {
    return '$pillar $part';
  }

  @override
  String get stemLabel => '천간';

  @override
  String get branchLabel => '지지';

  @override
  String get detailFooter => '사주는 재미와 참고로 보는 콘텐츠예요. 오늘도 좋은 하루 보내세요 🌙';

  @override
  String get shareTitle => '공유하기';

  @override
  String get shareAsImage => '이미지로 공유';

  @override
  String get shareAsText => '텍스트로 공유';

  @override
  String get shareHint => '카카오톡, 인스타그램 스토리, 문자 등으로 보낼 수 있어요';

  @override
  String get shareCardTitle => '나의 사주팔자';

  @override
  String get shareAppFooter => '나의 사주팔자 앱';

  @override
  String get shareImageCaption => '나의 사주팔자 ✨';

  @override
  String shareTextHeader(String date, String pillar) {
    return '📅 $date 오늘의 운세 · 일진 $pillar';
  }

  @override
  String shareTextChart(String chart) {
    return '🔮 내 사주: $chart';
  }

  @override
  String shareTextScore(int score) {
    return '운세 지수 $score점';
  }

  @override
  String get notifTitle => '🌙 오늘의 사주 운세가 도착했어요';

  @override
  String notifBody(String pillar, int score, String text) {
    return '일진 $pillar · 운세 지수 $score점 · $text';
  }

  @override
  String get notifChannelName => '오늘의 운세 알림';

  @override
  String get notifChannelDesc => '매일 아침 오늘의 사주 운세를 알려드립니다.';

  @override
  String zodiacLabel(String animal) {
    return '$animal띠';
  }

  @override
  String get webShareUnsupported => '이미지 공유는 앱에서만 가능해요';
}
