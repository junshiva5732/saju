import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads/ad_manager.dart';
import 'l10n/app_localizations.dart';
import 'l10n/lang.dart';
import 'screens/detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/share_card_screen.dart';
import 'services/notification_service.dart';
import 'services/saju_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // 광고 SDK 초기화는 앱 표시를 막지 않도록 기다리지 않는다.
  AdManager.instance.init(prefs);
  await initializeDateFormatting();
  final service = SajuService(prefs);
  final notifications = NotificationService(prefs);
  // 웹 미리보기/스토어 스크린샷 전용: ?demo=1 이면 예시 프로필을 넣는다 (tool/capture_web.ps1).
  if (kIsWeb && Uri.base.queryParameters['demo'] == '1') {
    await service.save(birth: DateTime(1990, 1, 1, 12, 0), hourKnown: true, solarCorrection: true);
  }
  runApp(SajuApp(service: service, notifications: notifications));
}

/// 웹 전용: ?screen=detail|share|settings 로 특정 화면을 바로 연다 (스크린샷 캡처용).
String? get _webScreen => kIsWeb ? Uri.base.queryParameters['screen'] : null;

class SajuApp extends StatelessWidget {
  final SajuService service;
  final NotificationService notifications;
  const SajuApp({super.key, required this.service, required this.notifications});

  static const _seed = Color(0xFF4B3AA8);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _seed, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: _seed, brightness: Brightness.dark, useMaterial3: true),
      onGenerateTitle: (context) => L10n.of(context).appTitle,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      localeResolutionCallback: AppLang.resolve,
      home: _Root(service: service, notifications: notifications),
    );
  }
}

/// 출생 정보가 없으면 온보딩(설정 화면)을 홈 대신 보여준다.
/// 온보딩은 별도 라우트가 아니라 루트 자체이므로 뒤로가기로 건너뛸 수 없다.
class _Root extends StatefulWidget {
  final SajuService service;
  final NotificationService notifications;
  const _Root({required this.service, required this.notifications});

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  @override
  Widget build(BuildContext context) {
    if (widget.service.birth == null) {
      return SettingsScreen(
        service: widget.service,
        notifications: widget.notifications,
        isOnboarding: true,
        onSaved: () => setState(() {}),
      );
    }
    final screen = _webScreen;
    if (screen != null && screen != 'home') {
      final chart = widget.service.chart!;
      final now = DateTime.now();
      final fortune = widget.service.fortuneFor(chart, DateTime(now.year, now.month, now.day));
      return switch (screen) {
        'detail' => DetailScreen(chart: chart, fortune: fortune),
        'share' => ShareCardScreen(chart: chart, fortune: fortune),
        'settings' => SettingsScreen(service: widget.service, notifications: widget.notifications),
        _ => HomeScreen(service: widget.service, notifications: widget.notifications),
      };
    }
    return HomeScreen(service: widget.service, notifications: widget.notifications);
  }
}
