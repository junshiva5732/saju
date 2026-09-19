// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '我的八字';

  @override
  String get onboardingTitle => '开始';

  @override
  String get settingsTitle => '设置';

  @override
  String get onboardingHeadline => '请告诉我们你的出生日期与时间';

  @override
  String get onboardingBody => '根据出生年月日时排出八字命盘，为你解读性格、五行与今日运势。\n输入的信息仅保存在本机。';

  @override
  String get birthSection => '出生信息';

  @override
  String get birthDate => '出生日期';

  @override
  String get birthDatePickerHelp => '选择出生日期';

  @override
  String get birthTime => '出生时间';

  @override
  String get birthTimePickerHelp => '出生时间';

  @override
  String get hourUnknown => '不知道出生时间';

  @override
  String get hourUnknownHint => '不排时柱，按六字解读';

  @override
  String get solarCorrection => '真太阳时校正 (-30分钟)';

  @override
  String get solarCorrectionHint => '在韩国出生请开启，传统万年历方式';

  @override
  String get notificationSection => '早间提醒';

  @override
  String get notificationToggleTitle => '每日运势提醒';

  @override
  String get notificationToggleSubtitle => '每天早上告诉你今日日柱与运势';

  @override
  String get notificationTime => '提醒时间';

  @override
  String get notificationTimeHelp => '提醒时间';

  @override
  String get save => '保存';

  @override
  String get goSeeSaju => '查看我的八字';

  @override
  String get shareTooltip => '分享';

  @override
  String get settingsTooltip => '设置';

  @override
  String get myChart => '我的八字命盘';

  @override
  String get pillarHour => '时柱';

  @override
  String get pillarDay => '日柱';

  @override
  String get pillarMonth => '月柱';

  @override
  String get pillarYear => '年柱';

  @override
  String get unknownHour => '未知';

  @override
  String get dayMasterLabel => '我的日主';

  @override
  String dayMasterTitle(String name, String image) {
    return '$name · $image';
  }

  @override
  String get elementBalance => '五行分布';

  @override
  String characterCount(int n) {
    return '按$n字计算';
  }

  @override
  String get strongest => '最旺五行';

  @override
  String get weakest => '宜补五行';

  @override
  String get todayFortune => '今日运势';

  @override
  String todayPillar(String pillar) {
    return '今日日柱 $pillar';
  }

  @override
  String get fortuneIndex => '运势指数';

  @override
  String get luckyNumber => '幸运数字';

  @override
  String get luckyColor => '幸运颜色';

  @override
  String get luckyDirection => '幸运方位';

  @override
  String get seeDetail => '查看详细解读';

  @override
  String get detailTitle => '详细解读';

  @override
  String get sectionPersonality => '日主看性格';

  @override
  String get sectionElements => '五行分析';

  @override
  String get sectionTenGods => '命盘中的十神';

  @override
  String get sectionToday => '今日运势详解';

  @override
  String godAt(String pillar, String part) {
    return '$pillar$part';
  }

  @override
  String get stemLabel => '天干';

  @override
  String get branchLabel => '地支';

  @override
  String get detailFooter => '八字仅供娱乐与参考。祝你今天愉快 🌙';

  @override
  String get shareTitle => '分享';

  @override
  String get shareAsImage => '以图片分享';

  @override
  String get shareAsText => '以文字分享';

  @override
  String get shareHint => '可通过微信、短信等发送';

  @override
  String get shareCardTitle => '我的八字';

  @override
  String get shareAppFooter => '我的八字 App';

  @override
  String get shareImageCaption => '我的八字 ✨';

  @override
  String shareTextHeader(String date, String pillar) {
    return '📅 $date 今日运势 · 日柱 $pillar';
  }

  @override
  String shareTextChart(String chart) {
    return '🔮 我的八字: $chart';
  }

  @override
  String shareTextScore(int score) {
    return '运势指数 $score分';
  }

  @override
  String get notifTitle => '🌙 今日八字运势已送达';

  @override
  String notifBody(String pillar, int score, String text) {
    return '日柱 $pillar · 运势指数 $score分 · $text';
  }

  @override
  String get notifChannelName => '今日运势提醒';

  @override
  String get notifChannelDesc => '每天早上推送今日八字运势。';

  @override
  String zodiacLabel(String animal) {
    return '属$animal';
  }

  @override
  String get webShareUnsupported => '图片分享仅在 App 内可用';
}
