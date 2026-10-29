import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';

const repoFeatureKeys = <String>[
  'terminal',
  'sync',
  'ci',
  'notifications',
  'web',
  'team',
  'plugins',
];

const repoFeatureLabels = <String, String>{
  'terminal': 'Terminal مدمج',
  'sync': 'مزامنة مع remote',
  'ci': 'CI/CD محلي (أوامر)',
  'notifications': 'مركز إشعارات المستودع',
  'web': 'لوحة ويب محلية',
  'team': 'فريق (بيانات محلية)',
  'plugins': 'إضافات (سكربتات)',
};

class RepoFeaturesRepository {
  RepoFeaturesRepository(this._db);
  final AppDatabase _db;

  Future<Map<String, bool>> allFor(int repoId) async {
    final rows = await (_db.select(_db.repoFeatures)
          ..where((t) => t.repoId.equals(repoId)))
        .get();
    final map = {for (final k in repoFeatureKeys) k: false};
    for (final r in rows) {
      map[r.feature] = r.enabled;
    }
    return map;
  }

  Stream<Map<String, bool>> watchFor(int repoId) {
    return (_db.select(_db.repoFeatures)
          ..where((t) => t.repoId.equals(repoId)))
        .watch()
        .map((rows) {
      final map = {for (final k in repoFeatureKeys) k: false};
      for (final r in rows) {
        map[r.feature] = r.enabled;
      }
      return map;
    });
  }

  Future<bool> isEnabled(int repoId, String feature) async {
    final row = await (_db.select(_db.repoFeatures)
          ..where((t) =>
              t.repoId.equals(repoId) & t.feature.equals(feature)))
        .getSingleOrNull();
    return row?.enabled ?? false;
  }

  Future<void> toggle(int repoId, String feature, bool enabled) async {
    await _db.into(_db.repoFeatures).insertOnConflictUpdate(
          RepoFeaturesCompanion.insert(
            repoId: repoId,
            feature: feature,
            enabled: Value(enabled),
          ),
        );
  }
}

final repoFeaturesRepositoryProvider = Provider<RepoFeaturesRepository>((ref) {
  return RepoFeaturesRepository(ref.watch(appDatabaseProvider));
});

final repoFeaturesProvider =
    StreamProvider.family<Map<String, bool>, int>((ref, repoId) {
  return ref.watch(repoFeaturesRepositoryProvider).watchFor(repoId);
});