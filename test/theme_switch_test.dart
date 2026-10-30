import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexhub/core/l10n/app_localizations.dart';
import 'package:nexhub/core/theme/app_theme.dart';
import 'package:nexhub/core/theme/theme_provider.dart';
import 'package:nexhub/features/settings/presentation/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// مبدّل الثيم في صفحة الإعدادات — SegmentedButton (Material 3):
/// يجب أن يغيّر ThemeMode فعلياً ويحفظ الاختيار.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  /// إتاحة اكتمال التحميلات غير المتزامنة للمزودات (theme/locale/ai).
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
  }

  Future<SegmentedButton<String>> segmented(WidgetTester tester) async {
    return tester.widget<SegmentedButton<String>>(
      find.byType(SegmentedButton<String>),
    );
  }

  testWidgets('اختيار داكن من SegmentedButton يغيّر ThemeMode فعلياً ويُحفظ',
      (tester) async {
    // نقاء المتجر قبل الإقلاع
    final sp = await SharedPreferences.getInstance();
    await sp.remove('nexhub_theme_mode');

    await tester.pumpWidget(const ProviderScope(child: _SettingsHarness()));
    await settle(tester);

    // الحالة الابتدائية: system محدد، والثيم ليس داكناً بالضرورة
    expect(find.byType(SegmentedButton<String>), findsOneWidget);
    expect((await segmented(tester)).selected, {'system'});
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );

    // ★ الفعل: اختيار "داكن" من الواجهة نفسها
    await tester.tap(find.text('داكن'));
    await settle(tester);

    // التحديد انتقل إلى داكن
    expect((await segmented(tester)).selected, {'dark'});
    // ThemeMode تغيّر فعلياً في MaterialApp
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    // الثيم الداكن مطبَّق فعلاً على الشجرة
    expect(
      Theme.of(tester.element(find.text('داكن'))).brightness,
      Brightness.dark,
    );
    // محفوظ في SharedPreferences
    expect(
      (await SharedPreferences.getInstance()).getString('nexhub_theme_mode'),
      'dark',
    );
  });

  testWidgets('القيمة المحفوظة (dark) تُستعاد كمقطع محدد عند الإقلاع',
      (tester) async {
    SharedPreferences.setMockInitialValues({'nexhub_theme_mode': 'dark'});

    await tester.pumpWidget(const ProviderScope(child: _SettingsHarness()));
    await settle(tester);

    expect((await segmented(tester)).selected, {'dark'});
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('التبديل داكن ⇒ فاتح يعيد السطوع الفاتح ويحدّث الحفظ',
      (tester) async {
    SharedPreferences.setMockInitialValues({'nexhub_theme_mode': 'dark'});

    await tester.pumpWidget(const ProviderScope(child: _SettingsHarness()));
    await settle(tester);

    await tester.tap(find.text('فاتح'));
    await settle(tester);

    expect((await segmented(tester)).selected, {'light'});
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
    expect(
      Theme.of(tester.element(find.text('فاتح'))).brightness,
      Brightness.light,
    );
    expect(
      (await SharedPreferences.getInstance()).getString('nexhub_theme_mode'),
      'light',
    );
  });
}

/// حامل يعكس ربط main.dart تماماً: themeMode من appThemeModeProvider،
/// مع المفوضات العربية التي تحتاجها صفحة الإعدادات.
class _SettingsHarness extends ConsumerWidget {
  const _SettingsHarness();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(appThemeModeProvider).mode,
      home: const SettingsPage(),
    );
  }
}
