// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '私の四柱推命';

  @override
  String get onboardingTitle => 'はじめる';

  @override
  String get settingsTitle => '設定';

  @override
  String get onboardingHeadline => '生まれた日時を教えてください';

  @override
  String get onboardingBody =>
      '生年月日時から命式（八字）を出し、性格・五行・今日の運勢をお届けします。\n入力した情報は端末内にのみ保存されます。';

  @override
  String get birthSection => '出生情報';

  @override
  String get birthDate => '生年月日';

  @override
  String get birthDatePickerHelp => '生年月日を選択';

  @override
  String get birthTime => '生まれた時刻';

  @override
  String get birthTimePickerHelp => '生まれた時刻';

  @override
  String get hourUnknown => '生まれた時刻がわからない';

  @override
  String get hourUnknownHint => '時柱なしの六文字で鑑定します';

  @override
  String get solarCorrection => '真太陽時補正 (-30分)';

  @override
  String get solarCorrectionHint => '韓国生まれの方はオン。伝統的な万年暦の方式です';

  @override
  String get notificationSection => '朝の通知';

  @override
  String get notificationToggleTitle => '毎日の運勢通知';

  @override
  String get notificationToggleSubtitle => '今日の日柱と運勢をお知らせします';

  @override
  String get notificationTime => '通知時刻';

  @override
  String get notificationTimeHelp => '通知時刻';

  @override
  String get save => '保存';

  @override
  String get goSeeSaju => '私の命式を見る';

  @override
  String get shareTooltip => '共有';

  @override
  String get settingsTooltip => '設定';

  @override
  String get myChart => '私の命式';

  @override
  String get pillarHour => '時柱';

  @override
  String get pillarDay => '日柱';

  @override
  String get pillarMonth => '月柱';

  @override
  String get pillarYear => '年柱';

  @override
  String get unknownHour => '不明';

  @override
  String get dayMasterLabel => '私の日干';

  @override
  String dayMasterTitle(String name, String image) {
    return '$name · $image';
  }

  @override
  String get elementBalance => '五行バランス';

  @override
  String characterCount(int n) {
    return '$n文字基準';
  }

  @override
  String get strongest => '強い五行';

  @override
  String get weakest => '補いたい五行';

  @override
  String get todayFortune => '今日の運勢';

  @override
  String todayPillar(String pillar) {
    return '今日の日柱 $pillar';
  }

  @override
  String get fortuneIndex => '運勢指数';

  @override
  String get luckyNumber => 'ラッキーナンバー';

  @override
  String get luckyColor => 'ラッキーカラー';

  @override
  String get luckyDirection => '吉方位';

  @override
  String get seeDetail => '詳しい鑑定を見る';

  @override
  String get detailTitle => '詳しい鑑定';

  @override
  String get sectionPersonality => '日干で見る性格';

  @override
  String get sectionElements => '五行分析';

  @override
  String get sectionTenGods => '命式の通変星';

  @override
  String get sectionToday => '今日の運勢の詳細';

  @override
  String godAt(String pillar, String part) {
    return '$pillar$part';
  }

  @override
  String get stemLabel => '天干';

  @override
  String get branchLabel => '地支';

  @override
  String get detailFooter => '四柱推命は楽しみと参考のためのコンテンツです。今日も良い一日を 🌙';

  @override
  String get shareTitle => '共有';

  @override
  String get shareAsImage => '画像で共有';

  @override
  String get shareAsText => 'テキストで共有';

  @override
  String get shareHint => 'LINE、インスタのストーリー、SMS などで送れます';

  @override
  String get shareCardTitle => '私の四柱推命';

  @override
  String get shareAppFooter => '私の四柱推命アプリ';

  @override
  String get shareImageCaption => '私の四柱推命 ✨';

  @override
  String shareTextHeader(String date, String pillar) {
    return '📅 $date 今日の運勢 · 日柱 $pillar';
  }

  @override
  String shareTextChart(String chart) {
    return '🔮 私の命式: $chart';
  }

  @override
  String shareTextScore(int score) {
    return '運勢指数 $score点';
  }

  @override
  String get notifTitle => '🌙 今日の四柱推命が届きました';

  @override
  String notifBody(String pillar, int score, String text) {
    return '日柱 $pillar · 運勢指数 $score点 · $text';
  }

  @override
  String get notifChannelName => '今日の運勢通知';

  @override
  String get notifChannelDesc => '毎朝、今日の運勢をお知らせします。';

  @override
  String zodiacLabel(String animal) {
    return '$animal年';
  }

  @override
  String get webShareUnsupported => '画像の共有はアプリでのみ可能です';
}
