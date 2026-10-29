import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';

class NexusProvidersRepository {
  NexusProvidersRepository(this._db);
  final AppDatabase _db;

  Stream<List<NexusProvider>> watchAll() {
    final q = _db.select(_db.nexusProviders)
      ..orderBy([(t) => OrderingTerm(expression: t.id)]);
    return q.watch();
  }

  Future<List<NexusProvider>> getAll() =>
      (_db.select(_db.nexusProviders)
            ..orderBy([(t) => OrderingTerm(expression: t.id)]))
          .get();

  Future<NexusProvider?> getDefault() async {
    final rows = await (_db.select(_db.nexusProviders)
          ..where((t) => t.enabled.equals(true) & t.isDefault.equals(true)))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<int> upsert({
    int? id,
    required String name,
    required String label,
    required String baseUrl,
    required String model,
    String apiKey = '',
    bool enabled = false,
    bool isDefault = false,
    int maxTokens = 2048,
    double temperature = 0.2,
  }) async {
    if (isDefault) {
      await (_db.update(_db.nexusProviders))
          .write(const NexusProvidersCompanion(isDefault: Value(false)));
    }
    return _db.into(_db.nexusProviders).insertOnConflictUpdate(
          NexusProvidersCompanion.insert(
            id: id == null ? const Value.absent() : Value(id),
            name: name,
            label: label,
            baseUrl: baseUrl,
            model: model,
            apiKey: Value(apiKey),
            enabled: Value(enabled),
            isDefault: Value(isDefault),
            maxTokens: Value(maxTokens),
            temperature: Value(temperature),
          ),
        );
  }
}

final nexusProvidersRepositoryProvider =
    Provider<NexusProvidersRepository>((ref) {
  return NexusProvidersRepository(ref.watch(appDatabaseProvider));
});

final nexusProvidersProvider = StreamProvider<List<NexusProvider>>((ref) {
  return ref.watch(nexusProvidersRepositoryProvider).watchAll();
});

final nexusDefaultProvider = FutureProvider<NexusProvider?>((ref) async {
  ref.watch(nexusProvidersProvider);
  return ref.watch(nexusProvidersRepositoryProvider).getDefault();
});