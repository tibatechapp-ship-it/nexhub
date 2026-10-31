import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'NexHub'**
  String get appName;

  /// No description provided for @navWorkspace.
  ///
  /// In ar, this message translates to:
  /// **'المساحة'**
  String get navWorkspace;

  /// No description provided for @navHistory.
  ///
  /// In ar, this message translates to:
  /// **'السجل'**
  String get navHistory;

  /// No description provided for @navSnippets.
  ///
  /// In ar, this message translates to:
  /// **'المقتطفات'**
  String get navSnippets;

  /// No description provided for @navSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get navSettings;

  /// No description provided for @workspace.
  ///
  /// In ar, this message translates to:
  /// **'مساحة العمل'**
  String get workspace;

  /// No description provided for @noWorkspaces.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مستودعات بعد'**
  String get noWorkspaces;

  /// No description provided for @openExisting.
  ///
  /// In ar, this message translates to:
  /// **'فتح مستودع موجود'**
  String get openExisting;

  /// No description provided for @createNew.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء مستودع جديد'**
  String get createNew;

  /// No description provided for @browseFiles.
  ///
  /// In ar, this message translates to:
  /// **'تصفح الملفات'**
  String get browseFiles;

  /// No description provided for @searchPlaceholder.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في الأسماء والمحتوى...'**
  String get searchPlaceholder;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء'**
  String get create;

  /// No description provided for @open.
  ///
  /// In ar, this message translates to:
  /// **'فتح'**
  String get open;

  /// No description provided for @repoName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستودع'**
  String get repoName;

  /// No description provided for @notGitRepo.
  ///
  /// In ar, this message translates to:
  /// **'هذا المجلد ليس مستودع git'**
  String get notGitRepo;

  /// No description provided for @invalidPath.
  ///
  /// In ar, this message translates to:
  /// **'مسار غير صالح'**
  String get invalidPath;

  /// No description provided for @emptyRepo.
  ///
  /// In ar, this message translates to:
  /// **'المستودع فارغ'**
  String get emptyRepo;

  /// No description provided for @noSearchResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج'**
  String get noSearchResults;

  /// No description provided for @searching.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ البحث...'**
  String get searching;

  /// No description provided for @removeWorkspace.
  ///
  /// In ar, this message translates to:
  /// **'إزالة من القائمة'**
  String get removeWorkspace;

  /// No description provided for @historyEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد سجل بعد'**
  String get historyEmpty;

  /// No description provided for @snippetsEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مقتطفات بعد'**
  String get snippetsEmpty;

  /// No description provided for @binaryFile.
  ///
  /// In ar, this message translates to:
  /// **'ملف ثنائي'**
  String get binaryFile;

  /// No description provided for @fileTooLarge.
  ///
  /// In ar, this message translates to:
  /// **'الملف كبير جداً'**
  String get fileTooLarge;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @languageDesc.
  ///
  /// In ar, this message translates to:
  /// **'العربية / English / حسب النظام'**
  String get languageDesc;

  /// No description provided for @langArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// No description provided for @langEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langSystem.
  ///
  /// In ar, this message translates to:
  /// **'حسب النظام'**
  String get langSystem;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
