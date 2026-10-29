import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NexHubApp()));
}

class NexHubApp extends ConsumerWidget {
  const NexHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    // UX audit: اللغة لم تعد مقفولة على 'ar' — الإعداد يُحفظ ويُقرأ من
    // SharedPreferences (افتراضياً 'ar' حفاظاً على سلوك المنتج الحالي).
    final loc = ref.watch(appLocaleProvider);
    return MaterialApp.router(
      title: 'NexHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // الوضع الليلي: الاختيار (light/dark/system) محفوظ في SharedPreferences
      // ويُقرأ عبر appThemeModeProvider (core/theme/theme_provider.dart).
      themeMode: ref.watch(appThemeModeProvider).mode,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: loc.materialLocale,
    );
  }
}
