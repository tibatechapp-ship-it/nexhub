import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// لغة التطبيق — تفكّ قفل `Locale('ar')` المفروض في main.dart
/// (تدقيق UX §5.6/N-3، المرحلة 3 من خارطة الأولويات).
///
/// القيمة تُحفظ في SharedPreferences ويُقرأ منها عند الإقلاع:
/// - 'ar'     → العربية (الافتراضي — يحافظ على سلوك المنتج الحالي)
/// - 'en'     → English
/// - 'system' → حسب لغة النظام (locale: null في MaterialApp)
class LocaleState {
  final String code;
  const LocaleState(this.code);

  Locale? get materialLocale =>
      code == 'system' ? null : Locale(code);
}

class LocaleNotifier extends StateNotifier<LocaleState> {
  static const _prefKey = 'nexhub_locale';

  LocaleNotifier() : super(const LocaleState('ar')) {
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final saved = sp.getString(_prefKey);
    if (saved == 'ar' || saved == 'en' || saved == 'system') {
      state = LocaleState(saved);
    }
  }

  Future<void> setLocale(String code) async {
    state = LocaleState(code);
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_prefKey, code);
  }
}

final appLocaleProvider =
    StateNotifierProvider<LocaleNotifier, LocaleState>(
  (ref) => LocaleNotifier(),
);
