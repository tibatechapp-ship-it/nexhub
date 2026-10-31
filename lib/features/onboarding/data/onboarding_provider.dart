import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// جولة أول تشغيل — أسبوع 1 من خارطة المنتَجة (الهوية والسرد).
///
/// القرار: الراوتر يوجه الزائر الأول إلى `/onboarding` قبل أي شاشة أخرى،
/// وبعد إتمام الجولة (أو تخطيها) لا تظهر ثانيةً. المنطق القابل للاختبار
/// معزول في [onboardingRedirectFor] حتى يبقى اختباره حتمياً بلا ضخ
/// أعمال go_router الداخلية.
class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _load();
  }

  static const prefKey = 'nexhub_onboarding_complete_v1';

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    state = sp.getBool(prefKey) ?? false;
  }

  /// إتمام الجولة (زر «ابدأ الآن» أو «تخطي») — تُحفظ فوراً.
  Future<void> complete() async {
    state = true;
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(prefKey, true);
  }
}

final onboardingCompleteProvider =
    StateNotifierProvider<OnboardingNotifier, bool>(
  (ref) => OnboardingNotifier(),
);

/// قرار التوجيه: أول من يفتح التطبيق (العلم غير محفوظ) يُرسل إلى
/// `/onboarding` من أي مسار؛ من أتمّ الجولة يكمل مكانه. من على مسار
/// الجولة نفسه لا يُعاد توجيهه (تجنب حلقة).
///
/// [sp] معامل اختياري للاختبارات (SharedPreferences.setMockInitialValues).
Future<String?> onboardingRedirectFor(
  String path, {
  SharedPreferences? sp,
}) async {
  sp ??= await SharedPreferences.getInstance();
  final done = sp.getBool(OnboardingNotifier.prefKey) ?? false;
  if (done || path == '/onboarding') {
    return null;
  }
  return '/onboarding';
}
