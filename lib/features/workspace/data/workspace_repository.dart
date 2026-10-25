import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';

class WorkspaceRepository {
  WorkspaceRepository(this._db);
  final AppDatabase _db;

  Stream<List<Repo>> watchAll() {
    final q = _db.select(_db.repos)
      ..orderBy([
        (t) => OrderingTerm(
              expression: t.lastOpened,
              mode: OrderingMode.desc,
            ),
      ]);
    return q.watch();
  }

  Future<Repo?> byId(int id) =>
      (_db.select(_db.repos)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> add({required String name, required String path}) async {
    final existing = await (_db.select(_db.repos)
          ..where((t) => t.path.equals(path)))
        .getSingleOrNull();
    if (existing != null) {
      await touch(existing.id);
      return existing.id;
    }
    return _db.into(_db.repos).insert(
          ReposCompanion.insert(
            name: name,
            path: path,
            lastOpened: Value(DateTime.now()),
          ),
        );
  }

  Future<void> touch(int id) =>
      (_db.update(_db.repos)..where((t) => t.id.equals(id)))
          .write(ReposCompanion(lastOpened: Value(DateTime.now())));

  Future<void> remove(int id) =>
      (_db.delete(_db.repos)..where((t) => t.id.equals(id))).go();

  Future<({bool ok, String? error})> validateOrInit(
    String path, {
    bool create = false,
  }) async {
    final dir = Directory(path);
    if (!create) {
      if (!await dir.exists()) return (ok: false, error: 'invalidPath');
      final git = Directory('$path/.git');
      if (!await git.exists()) return (ok: false, error: 'notGitRepo');
      return (ok: true, error: null);
    }
    await dir.create(recursive: true);
    final r = await Process.run('git', ['init'], workingDirectory: path);
    if (r.exitCode != 0) {
      return (ok: false, error: (r.stderr as String).trim());
    }
    return (ok: true, error: null);
  }
}

final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  return WorkspaceRepository(ref.watch(appDatabaseProvider));
});

final workspacesStreamProvider = StreamProvider<List<Repo>>((ref) {
  return ref.watch(workspaceRepositoryProvider).watchAll();
});