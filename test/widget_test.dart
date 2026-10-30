import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexhub/core/theme/app_theme.dart';

/// اختبارات ثيم NexHub — وضمان توافق الوضع الليلي/الفاتح مع Material 3.
///
/// (اختبارات مبدّل الوضع الليلي وربطه في MaterialApp موجودة في
/// theme_provider_test.dart — هذا الملف يغطي بنية الثيم نفسها.)
void main() {
  group('AppTheme — بنية الثيم الفاتح والداكن', () {
    test('كلاهما Material 3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
    });

    test('سطوع كل ثيم مطابق لاسمه (ColorScheme.fromSeed)', () {
      expect(AppTheme.light.colorScheme.brightness, Brightness.light);
      expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
    });

    test('الوضعان متقابلان فعلاً — سطوع السطح فاتح/داكن', () {
      // ColorScheme.fromSeed يعطي tones مختلفة عمداً لكل سطوع —
      // المهم أن الفاتح ساطع والداكن معتم (جودة الوضع الليلي).
      expect(AppTheme.light.colorScheme.surface.computeLuminance() > 0.5,
          isTrue);
      expect(AppTheme.dark.colorScheme.surface.computeLuminance() < 0.5,
          isTrue);
    });

    test('عناصر مشتركة لا تتغير بين الوضعين (elevation/الشكل)', () {
      final light = AppTheme.light;
      final dark = AppTheme.dark;

      // شريط التطبيق مسطح في الاثنين
      expect(light.appBarTheme.elevation, dark.appBarTheme.elevation);
      // خلفية السطح من مخطط الألوان لكل وضع (وليست لوناً صلباً واحداً)
      expect(light.scaffoldBackgroundColor, light.colorScheme.surface);
      expect(dark.scaffoldBackgroundColor, dark.colorScheme.surface);
      // خلفيتا الوضعين مختلفتان فعلاً
      expect(light.scaffoldBackgroundColor,
          isNot(dark.scaffoldBackgroundColor));
    });

    testWidgets('الوضع الداكن يُطبَّق فعلياً على الشجرة عند الطلب',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (context) => Text(
              Theme.of(context).brightness.name,
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      );
      expect(find.text('dark'), findsOneWidget);
    });
  });
}
