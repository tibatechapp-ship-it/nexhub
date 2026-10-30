import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// تهيئة عامة لكل الاختبارات — تنفَّذ قبل أي ملف اختبار.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // بيئة الاختبار بلا شبكة: منع google_fonts من محاولة تنزيل Cairo —
  // يتراجع تلقائياً إلى الخط الافتراضي داخل الاختبارات.
  GoogleFonts.config.allowRuntimeFetching = false;

  await testMain();
}
