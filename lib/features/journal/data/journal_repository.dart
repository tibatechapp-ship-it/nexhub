import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';

class JournalRepository {
  JournalRepository(this._db);
  final AppDatabase _db;

  Stream<List<JournalEntry>> watchForRepo(String repoPath) {
    final q = _db.select(_db.journalEntries)
      ..where((t) => t.repoPath.equals(repoPath))
      ..orderBy([
        (t) => OrderingTerm(
              expression: t.createdAt,
              mode: OrderingMode.desc,
            ),
      ]);
    return q.watch();
  }

  Stream<List<JournalEntry>> watchForCommit(String repoPath, String hash) {
    final q = _db.select(_db.journalEntries)
      ..where(
        (t) => t.repoPath.equals(repoPath) & t.commitHash.equals(hash),
      )
      ..orderBy([
        (t) => OrderingTerm(
              expression: t.createdAt,
              mode: OrderingMode.desc,
            ),
      ]);
    return q.watch();
  }

  Future<int> add({
    required String repoPath,
    String? commitHash,
    required String title,
    required String body,
  }) {
    return _db.into(_db.journalEntries).insert(
          JournalEntriesCompanion.insert(
            repoPath: repoPath,
            commitHash: Value(commitHash),
            title: title,
            body: Value(body),
          ),
        );
  }

  Future<void> remove(int id) =>
      (_db.delete(_db.journalEntries)..where((t) => t.id.equals(id))).go();
}

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(ref.watch(appDatabaseProvider));
});