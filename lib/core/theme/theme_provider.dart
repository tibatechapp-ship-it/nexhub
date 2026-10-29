import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// وضع المظهر — light/dark/system مع حفظ الاختيار في SharedPreferences.
///
/// يتبع نمط [LocaleNotifier] (core/l10n/locale_provider.dart) حرفياً:
/// - القيمة تُحفظ عند التغيير وتُقرأ عند الإقلاع.
/// - الافتراضي 'system' — يحافظ على سلوك المنتج الحالي
///   (`themeMode: ThemeMode.system` في main.dart قبل هذه الميزة).
class ThemeModeState {
  /// 'light' | 'dark' | 'system'
  final String code;

  const ThemeModeState(this.code);

  /// الترجمة إلى [ThemeMode] التي يتوقعها MaterialApp.
  ThemeMode get mode {
    switch (code) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

class ThemeModeNotifier extends StateNotifier<ThemeModeState> {
  static const _prefKey = 'nexhub_theme_mode';

  ThemeModeNotifier() : super(const ThemeModeState('system')) {
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final saved = sp.getString(_prefKey);
    if (saved != null &&
        (saved == 'light' || saved == 'dark' || saved == 'system')) {
      state = ThemeModeState(saved);
    }
  }

  Future<void> setMode(String code) async {
    state = ThemeModeState(code);
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_prefKey, code);
  }
}

final appThemeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeModeState>(
  (ref) => ThemeModeNotifier(),
);
