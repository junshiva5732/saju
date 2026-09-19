import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ads/ad_ids.dart';

/// 화면 하단에 붙이는 적응형 배너. 로드 전/실패 시에는 높이 0.
///
/// 웹(개발 미리보기)에서는 광고 SDK 가 없으므로 같은 높이의 자리표시자를 그려
/// 레이아웃만 확인할 수 있게 한다.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kIsWeb) return;
    // 콜드 스타트 첫 프레임에는 화면 너비가 0으로 올 수 있다. MediaQuery 에 의존하고
    // 있으므로 너비가 잡히면 이 메서드가 다시 호출된다.
    final width = MediaQuery.sizeOf(context).width.truncate();
    if (_ad == null && width > 0) _load(width);
  }

  Future<void> _load(int width) async {
    final size =
        await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (size == null || !mounted) return;

    _ad = BannerAd(
      adUnitId: AdIds.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Banner load failed: $err');
          ad.dispose();
          _ad = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // 스토어 스크린샷 캡처(tool/capture_web.py, ?shot=1) 때는 자리표시자도 숨긴다.
      if (Uri.base.queryParameters['shot'] == '1') return const SizedBox.shrink();
      final cs = Theme.of(context).colorScheme;
      return SafeArea(
        top: false,
        child: Container(
          height: 60,
          width: double.infinity,
          color: cs.surfaceContainerHighest,
          alignment: Alignment.center,
          child: Text('AdMob banner (320×50 / adaptive)',
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
        ),
      );
    }
    final ad = _ad;
    if (ad == null || !_loaded) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}
