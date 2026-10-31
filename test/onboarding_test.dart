import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nexhub/features/onboarding/data/onboarding_provider.dart';
import 'package:nexhub/features/onboarding/presentation/onboarding_flow.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// بيئة اختبار بـGoRouter حقيقي — أزرار الجولة تستدعي context.go فعلياً.
Widget _harness() {
  final router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingFlow(),
      ),
      GoRoute(
        path: '/workspace',
        builder: (_, __) => const Scaffold(body: Text('WORKSPACE')),
      ),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('onboardingRedirectFor — قرار التوجيه', () {
    test('أول تشغيل: أي مسار يُرسل إلى /onboarding', () async {
      SharedPreferences.setMockInitialValues({});
      final target = await onboardingRedirectFor('/workspace');
      expect(target, '/onboarding');
    });

    test('من أتمّ الجولة: يبقى في مكانه', () async {
      SharedPreferences.setMockInitialValues({
        OnboardingNotifier.prefKey: true,
      });
      final target = await onboardingRedirectFor('/workspace');
      expect(target, isNull);
    });

    test('من على مسار الجولة نفسه لا يُعاد توجيهه (لا حلقة)', () async {
      SharedPreferences.setMockInitialValues({});
      final target = await onboardingRedirectFor('/onboarding');
      expect(target, isNull);
    });
  });

  group('OnboardingFlow — الجولة نفسها', () {
    Future<void> pumpFlow(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(_harness());
      await tester.pumpAndSettle();
    }

    testWidgets('الصفحة الأولى ظاهرة والمؤشرات الخمسة موجودة',
        (tester) async {
      await pumpFlow(tester);
      // PageView يبني صفحاته بترفُّل — الصفحة 0 فقط في الشجرة إلزامياً
      expect(find.byKey(const Key('onboarding_page_0')), findsOneWidget);
      expect(find.text('أهلاً بك في NexHub'), findsOneWidget);
      for (var i = 0; i < 5; i++) {
        expect(find.byKey(Key('onboarding_dot_$i')), findsOneWidget);
      }
    });

    testWidgets('زر التالي يتقدم خطوة بخطوة حتى ابدأ الآن', (tester) async {
      await pumpFlow(tester);
      expect(find.byKey(const Key('onboarding_next')), findsOneWidget);
      const titles = [
        'أهلاً بك في NexHub',
        'افتح مجلدك وابدأ',
        'اعمل أول Commit بالعربية',
        'بلا إنترنت… وبلا سحابة',
        'وكيل AI وأدوات يومية',
      ];
      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byKey(const Key('onboarding_next')));
        await tester.pumpAndSettle();
        expect(find.text(titles[i + 1]), findsOneWidget);
      }
      expect(find.byKey(const Key('onboarding_start')), findsOneWidget);
    });

    testWidgets('تخطي يُتمّ الجولة ويحفظ العلم ويصل للمساحة', (tester) async {
      await pumpFlow(tester);
      await tester.tap(find.byKey(const Key('onboarding_skip')));
      await tester.pumpAndSettle();
      final sp = await SharedPreferences.getInstance();
      expect(sp.getBool(OnboardingNotifier.prefKey), isTrue);
      expect(find.text('WORKSPACE'), findsOneWidget);
    });

    testWidgets('ابدأ الآن في آخر صفحة يُتمّ الجولة', (tester) async {
      await pumpFlow(tester);
      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byKey(const Key('onboarding_next')));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byKey(const Key('onboarding_start')));
      await tester.pumpAndSettle();
      final sp = await SharedPreferences.getInstance();
      expect(sp.getBool(OnboardingNotifier.prefKey), isTrue);
    });
  });
}
