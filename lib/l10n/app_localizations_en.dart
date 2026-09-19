// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Saju';

  @override
  String get onboardingTitle => 'Get started';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get onboardingHeadline => 'Tell us when you were born';

  @override
  String get onboardingBody =>
      'Your birth date and time become the eight characters of your Saju (Four Pillars): personality, five elements and today\'s fortune.\nYour data stays on this device.';

  @override
  String get birthSection => 'Birth info';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get birthDatePickerHelp => 'Select date of birth';

  @override
  String get birthTime => 'Time of birth';

  @override
  String get birthTimePickerHelp => 'Time of birth';

  @override
  String get hourUnknown => 'I don\'t know my birth time';

  @override
  String get hourUnknownHint => 'Reads six characters without the hour pillar';

  @override
  String get solarCorrection => 'True solar time (-30 min)';

  @override
  String get solarCorrectionHint =>
      'Turn on if born in Korea; traditional almanac method';

  @override
  String get notificationSection => 'Morning notification';

  @override
  String get notificationToggleTitle => 'Daily fortune notification';

  @override
  String get notificationToggleSubtitle =>
      'Today\'s day pillar and fortune every morning';

  @override
  String get notificationTime => 'Notification time';

  @override
  String get notificationTimeHelp => 'Notification time';

  @override
  String get save => 'Save';

  @override
  String get goSeeSaju => 'See my Saju';

  @override
  String get shareTooltip => 'Share';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get myChart => 'My Four Pillars';

  @override
  String get pillarHour => 'Hour';

  @override
  String get pillarDay => 'Day';

  @override
  String get pillarMonth => 'Month';

  @override
  String get pillarYear => 'Year';

  @override
  String get unknownHour => 'N/A';

  @override
  String get dayMasterLabel => 'My Day Master';

  @override
  String dayMasterTitle(String name, String image) {
    return '$name · $image';
  }

  @override
  String get elementBalance => 'Five elements';

  @override
  String characterCount(int n) {
    return 'based on $n characters';
  }

  @override
  String get strongest => 'Strongest';

  @override
  String get weakest => 'To strengthen';

  @override
  String get todayFortune => 'Today\'s fortune';

  @override
  String todayPillar(String pillar) {
    return 'Today\'s pillar $pillar';
  }

  @override
  String get fortuneIndex => 'Fortune index';

  @override
  String get luckyNumber => 'Lucky number';

  @override
  String get luckyColor => 'Lucky color';

  @override
  String get luckyDirection => 'Lucky direction';

  @override
  String get seeDetail => 'See full reading';

  @override
  String get detailTitle => 'Full reading';

  @override
  String get sectionPersonality => 'Personality by Day Master';

  @override
  String get sectionElements => 'Element analysis';

  @override
  String get sectionTenGods => 'Ten Gods in my chart';

  @override
  String get sectionToday => 'Today in detail';

  @override
  String godAt(String pillar, String part) {
    return '$pillar $part';
  }

  @override
  String get stemLabel => 'stem';

  @override
  String get branchLabel => 'branch';

  @override
  String get detailFooter =>
      'Saju is for fun and reflection. Have a wonderful day 🌙';

  @override
  String get shareTitle => 'Share';

  @override
  String get shareAsImage => 'Share as image';

  @override
  String get shareAsText => 'Share as text';

  @override
  String get shareHint => 'Send via messaging apps, stories or SMS';

  @override
  String get shareCardTitle => 'My Saju';

  @override
  String get shareAppFooter => 'My Saju app';

  @override
  String get shareImageCaption => 'My Saju ✨';

  @override
  String shareTextHeader(String date, String pillar) {
    return '📅 $date fortune · day pillar $pillar';
  }

  @override
  String shareTextChart(String chart) {
    return '🔮 My chart: $chart';
  }

  @override
  String shareTextScore(int score) {
    return 'Fortune index $score';
  }

  @override
  String get notifTitle => '🌙 Your Saju fortune for today';

  @override
  String notifBody(String pillar, int score, String text) {
    return 'Day pillar $pillar · index $score · $text';
  }

  @override
  String get notifChannelName => 'Daily fortune';

  @override
  String get notifChannelDesc => 'Your Saju fortune every morning.';

  @override
  String zodiacLabel(String animal) {
    return 'Year of the $animal';
  }

  @override
  String get webShareUnsupported =>
      'Image sharing is available in the app only';
}
