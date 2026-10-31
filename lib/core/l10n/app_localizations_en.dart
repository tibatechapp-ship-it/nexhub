// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'NexHub';

  @override
  String get navWorkspace => 'Workspace';

  @override
  String get navHistory => 'History';

  @override
  String get navSnippets => 'Snippets';

  @override
  String get navSettings => 'Settings';

  @override
  String get workspace => 'Workspace';

  @override
  String get noWorkspaces => 'No repositories yet';

  @override
  String get openExisting => 'Open existing repository';

  @override
  String get createNew => 'Create new repository';

  @override
  String get browseFiles => 'Browse files';

  @override
  String get searchPlaceholder => 'Search names and content...';

  @override
  String get search => 'Search';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get open => 'Open';

  @override
  String get repoName => 'Repository name';

  @override
  String get notGitRepo => 'This folder is not a git repository';

  @override
  String get invalidPath => 'Invalid path';

  @override
  String get emptyRepo => 'Repository is empty';

  @override
  String get noSearchResults => 'No results';

  @override
  String get searching => 'Searching...';

  @override
  String get removeWorkspace => 'Remove from list';

  @override
  String get historyEmpty => 'No history yet';

  @override
  String get snippetsEmpty => 'No snippets yet';

  @override
  String get binaryFile => 'Binary file';

  @override
  String get fileTooLarge => 'File too large';

  @override
  String get language => 'Language';

  @override
  String get languageDesc => 'العربية / English / System';

  @override
  String get langArabic => 'العربية';

  @override
  String get langEnglish => 'English';

  @override
  String get langSystem => 'System default';
}
