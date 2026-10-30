import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexhub/core/theme/app_theme.dart';
import 'package:nexhub/core/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// الوضع الليلي — ThemeMode (light/dark/system) محفوظ في SharedPreferences.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  /// إتاحة اكتمال ThemeModeNotifier._load ( تهيئة كسولة عند أول read).
  Future<void> flush() async {
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }

  group('ThemeModeState — النموذج', () {
    test('التحويل إلى ThemeMode', () {
      expect(const ThemeModeState('light').mode, ThemeMode.light);
      expect(const ThemeModeState('dark').mode, ThemeMode.dark);
      expect(const ThemeModeState('system').mode, ThemeMode.system);
    });
  });

  group('ThemeModeNotifier — الحالة والحفظ', () {
    test('الافتراضي: system (يحافظ على سلوك المنتج)', () async {
      // ضمان نقاء المتجر مهما كان تاريخ المفردة في هذه العملية
      final sp = await SharedPreferences.getInstance();
      await sp.remove('nexhub_theme_mode');

      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(appThemeModeProvider); // إنشاء Notifier (كسول)
      await flush();

      expect(container.read(appThemeModeProvider).code, 'system');
      expect(container.read(appThemeModeProvider).mode, ThemeMode.system);
    });

    test('setMode: يغيّر الحالة فوراً ويحفظ في SharedPreferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(appThemeModeProvider);
      await flush();

      await container.read(appThemeModeProvider.notifier).setMode('dark');
      expect(container.read(appThemeModeProvider).code, 'dark');
      expect(container.read(appThemeModeProvider).mode, ThemeMode.dark);

      final sp = await SharedPreferences.getInstance();
      expect(sp.getString('nexhub_theme_mode'), 'dark');
    });

    test('الاستعادة عند الإقلاع: يقرأ القيمة المحفوظة', () async {
      // كتابة عبر المفردة نفسها — أضمن من mock-initial بعد إنشائها
      final sp = await SharedPreferences.getInstance();
      await sp.setString('nexhub_theme_mode', 'light');

      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(appThemeModeProvider);
      await flush();

      expect(container.read(appThemeModeProvider).mode, ThemeMode.light);
    });

    test('الاستعادة: القيم غير الصالحة تُتجاهل (يبقى system)', () async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString('nexhub_theme_mode', 'hacked');

      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(appThemeModeProvider);
      await flush();

      expect(container.read(appThemeModeProvider).code, 'system');
    });

    test('حاوية جديدة بعد التبديل تستعيد الاختيار (دورة حياة كاملة)',
        () async {
      final c1 = ProviderContainer();
      c1.read(appThemeModeProvider);
      await flush(); // اكتمال _load قبل الإتلاف (يمنع كتابة ما بعد dispose)
      await c1.read(appThemeModeProvider.notifier).setMode('dark');
      c1.dispose();

      final c2 = ProviderContainer();
      addTearDown(c2.dispose);
      c2.read(appThemeModeProvider);
      await flush();
      expect(c2.read(appThemeModeProvider).mode, ThemeMode.dark);
    });
  });

  group('الربط مع MaterialApp — عرض فعلي', () {
    testWidgets('themeMode مربوط ديناميكياً — الداكن يُطبَّق على الشجرة',
        (tester) async {
      // نقاء المتجر قبل الإقلاع
      final sp = await SharedPreferences.getInstance();
      await sp.remove('nexhub_theme_mode');

      await tester.pumpWidget(
        const ProviderScope(child: _ThemeHarness()),
      );
      await tester.pumpAndSettle();

      // الافتراضي system
      expect(find.text('mode=system'), findsOneWidget);

      // التبديل إلى الداكن من الواجهة
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('mode=dark'), findsOneWidget);
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(materialApp.themeMode, ThemeMode.dark);
      // الثيم الداكن فعلاً هو المعروض
      expect(
        Theme.of(tester.element(find.text('mode=dark'))).brightness,
        Brightness.dark,
      );

      // محفوظ
      expect(
        (await SharedPreferences.getInstance())
            .getString('nexhub_theme_mode'),
        'dark',
      );
    });
  });
}

/// واجهة مصغّرة تعكس ربط main.dart: themeMode من appThemeModeProvider.
class _ThemeHarness extends ConsumerWidget {
  const _ThemeHarness();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appThemeModeProvider).mode;
    return MaterialApp(
      title: 'NexHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      home: Scaffold(
        body: Center(child: Text('mode=${mode.name}')),
        floatingActionButton: FloatingActionButton(
          key: const Key('toDark'),
          onPressed: () =>
              ref.read(appThemeModeProvider.notifier).setMode('dark'),
        ),
      ),
    );
  }
}
