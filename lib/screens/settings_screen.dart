import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ads/ad_manager.dart';
import '../data/saju_texts.dart';
import '../l10n/app_localizations.dart';
import '../l10n/lang.dart';
import '../services/notification_service.dart';
import '../services/saju_service.dart';

/// 출생 정보 · 알림 설정 화면. 첫 실행 시 온보딩으로도 쓰인다.
class SettingsScreen extends StatefulWidget {
  final SajuService service;
  final NotificationService notifications;
  final bool isOnboarding;

  /// 온보딩 모드에서 저장 완료 시 호출. (일반 모드에서는 pop 한다.)
  final VoidCallback? onSaved;

  const SettingsScreen({
    super.key,
    required this.service,
    required this.notifications,
    this.isOnboarding = false,
    this.onSaved,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DateTime _birth = widget.service.birth ?? DateTime(1990, 1, 1, 12, 0);
  late bool _hourKnown = widget.service.hourKnown;
  bool? _solar; // null 이면 언어 기본값(한국어만 켬)
  late bool _notifOn = widget.notifications.enabled;
  late TimeOfDay _notifTime =
      TimeOfDay(hour: widget.notifications.hour, minute: widget.notifications.minute);

  bool _solarValue(BuildContext context) =>
      _solar ?? (widget.service.birth != null ? widget.service.solarCorrection : AppLang.of(context) == 'ko');

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: L10n.of(context).birthDatePickerHelp,
    );
    if (picked != null) {
      setState(() => _birth = DateTime(picked.year, picked.month, picked.day, _birth.hour, _birth.minute));
    }
  }

  Future<void> _pickBirthTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _birth.hour, minute: _birth.minute),
      helpText: L10n.of(context).birthTimePickerHelp,
    );
    if (picked != null) {
      setState(() => _birth = DateTime(_birth.year, _birth.month, _birth.day, picked.hour, picked.minute));
    }
  }

  Future<void> _pickNotifTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _notifTime,
      helpText: L10n.of(context).notificationTimeHelp,
    );
    if (picked != null) setState(() => _notifTime = picked);
  }

  Future<void> _save() async {
    await widget.service.save(
      birth: _birth,
      hourKnown: _hourKnown,
      solarCorrection: _solarValue(context),
    );
    await widget.notifications.setEnabled(_notifOn);
    await widget.notifications.setTime(_notifTime.hour, _notifTime.minute);
    if (!mounted) return;
    if (widget.isOnboarding) {
      // 첫 실행 온보딩에서는 광고 없이 바로 진입.
      widget.onSaved?.call();
    } else {
      // 설정 저장 시 전면 광고 → 닫히면 이전 화면으로.
      AdManager.instance.showInterstitialThen(() {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));
    // 띠는 입춘 기준이 정확하지만 설정 화면 미리보기는 연도만으로 표시.
    final zi = (_birth.year - 4) % 12;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOnboarding ? l.onboardingTitle : l.settingsTitle),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (widget.isOnboarding) ...[
            const SizedBox(height: 8),
            Text(l.onboardingHeadline,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(l.onboardingBody,
                style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 24),
          ],

          // ── 출생 정보 ────────────────────────────────────────────
          Text(l.birthSection, style: theme.textTheme.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHigh,
            shape: cardShape,
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Text(SajuTexts.zodiacEmoji[zi], style: const TextStyle(fontSize: 32)),
                  title: Text(l.birthDate, style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
                  subtitle: Text(DateFormat.yMMMMd(lang).format(_birth),
                      style: theme.textTheme.titleMedium?.copyWith(color: cs.onSurface)),
                  trailing: const Icon(Icons.edit_calendar_outlined),
                  onTap: _pickDate,
                ),
                ListTile(
                  enabled: _hourKnown,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: const Icon(Icons.access_time),
                  title: Text(l.birthTime, style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
                  subtitle: Text(
                    _hourKnown ? TimeOfDay(hour: _birth.hour, minute: _birth.minute).format(context) : l.unknownHour,
                    style: theme.textTheme.titleMedium?.copyWith(color: _hourKnown ? cs.onSurface : cs.outline),
                  ),
                  trailing: const Icon(Icons.schedule_outlined),
                  onTap: _hourKnown ? _pickBirthTime : null,
                ),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  title: Text(l.hourUnknown),
                  subtitle: Text(l.hourUnknownHint),
                  value: !_hourKnown,
                  onChanged: (v) => setState(() => _hourKnown = !v),
                ),
                if (_hourKnown)
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    title: Text(l.solarCorrection),
                    subtitle: Text(l.solarCorrectionHint),
                    value: _solarValue(context),
                    onChanged: (v) => setState(() => _solar = v),
                  ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── 알림 ────────────────────────────────────────────────
          Text(l.notificationSection, style: theme.textTheme.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHigh,
            shape: cardShape,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: Text(l.notificationToggleTitle),
                  subtitle: Text(l.notificationToggleSubtitle),
                  value: _notifOn,
                  onChanged: (v) => setState(() => _notifOn = v),
                ),
                if (_notifOn)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: const Icon(Icons.schedule_outlined),
                    title: Text(l.notificationTime),
                    trailing: Text(
                      _notifTime.format(context),
                      style: theme.textTheme.titleMedium?.copyWith(color: cs.primary),
                    ),
                    onTap: _pickNotifTime,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text(widget.isOnboarding ? l.goSeeSaju : l.save),
          ),
        ],
      ),
    );
  }
}
