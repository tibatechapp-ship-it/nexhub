// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'NexHub';

  @override
  String get navWorkspace => 'المساحة';

  @override
  String get navHistory => 'السجل';

  @override
  String get navSnippets => 'المقتطفات';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get workspace => 'مساحة العمل';

  @override
  String get noWorkspaces => 'لا توجد مستودعات بعد';

  @override
  String get openExisting => 'فتح مستودع موجود';

  @override
  String get createNew => 'إنشاء مستودع جديد';

  @override
  String get browseFiles => 'تصفح الملفات';

  @override
  String get searchPlaceholder => 'ابحث في الأسماء والمحتوى...';

  @override
  String get search => 'بحث';

  @override
  String get cancel => 'إلغاء';

  @override
  String get create => 'إنشاء';

  @override
  String get open => 'فتح';

  @override
  String get repoName => 'اسم المستودع';

  @override
  String get notGitRepo => 'هذا المجلد ليس مستودع git';

  @override
  String get invalidPath => 'مسار غير صالح';

  @override
  String get emptyRepo => 'المستودع فارغ';

  @override
  String get noSearchResults => 'لا توجد نتائج';

  @override
  String get searching => 'جارٍ البحث...';

  @override
  String get removeWorkspace => 'إزالة من القائمة';

  @override
  String get historyEmpty => 'لا يوجد سجل بعد';

  @override
  String get snippetsEmpty => 'لا توجد مقتطفات بعد';

  @override
  String get binaryFile => 'ملف ثنائي';

  @override
  String get fileTooLarge => 'الملف كبير جداً';

  @override
  String get language => 'اللغة';

  @override
  String get languageDesc => 'العربية / English / حسب النظام';

  @override
  String get langArabic => 'العربية';

  @override
  String get langEnglish => 'English';

  @override
  String get langSystem => 'حسب النظام';
}
