import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';

class SnippetsRepository {
  SnippetsRepository(this._db);
  final AppDatabase _db;

  Stream<List<Snippet>> watchAll() {
    final q = _db.select(_db.snippets)
      ..orderBy([
        (t) => OrderingTerm(
              expression: t.updatedAt,
              mode: OrderingMode.desc,
            ),
      ]);
    return q.watch();
  }

  Future<int> add({
    required String title,
    required String body,
    String language = 'plaintext',
    String tags = '',
  }) {
    return _db.into(_db.snippets).insert(
          SnippetsCompanion.insert(
            title: title,
            body: body,
            language: Value(language),
            tags: Value(tags),
          ),
        );
  }

  Future<void> update(
    int id, {
    required String title,
    required String body,
    required String language,
    required String tags,
  }) {
    return (_db.update(_db.snippets)..where((t) => t.id.equals(id))).write(
      SnippetsCompanion(
        title: Value(title),
        body: Value(body),
        language: Value(language),
        tags: Value(tags),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> remove(int id) =>
      (_db.delete(_db.snippets)..where((t) => t.id.equals(id))).go();
}

final snippetsRepositoryProvider = Provider<SnippetsRepository>((ref) {
  return SnippetsRepository(ref.watch(appDatabaseProvider));
});

final snippetsStreamProvider = StreamProvider<List<Snippet>>((ref) {
  return ref.watch(snippetsRepositoryProvider).watchAll();
});