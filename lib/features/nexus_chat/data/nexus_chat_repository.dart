import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';

class NexusChatRepository {
  NexusChatRepository(this._db);
  final AppDatabase _db;

  Stream<List<NexusConversation>> watchConversations() =>
      (_db.select(_db.nexusConversations)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Stream<List<NexusMessage>> watchMessages(int convId) =>
      (_db.select(_db.nexusMessages)
            ..where((t) => t.convId.equals(convId))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .watch();

  Future<int> newConversation({String? title, String? repoPath}) async {
    return _db.into(_db.nexusConversations).insert(
          NexusConversationsCompanion.insert(
            title: title == null ? const Value.absent() : Value(title),
            repoPath: repoPath == null
                ? const Value.absent()
                : Value(repoPath),
          ),
        );
  }

  Future<void> addMessage({
    required int convId,
    required String role,
    required String content,
  }) async {
    await _db.into(_db.nexusMessages).insert(
          NexusMessagesCompanion.insert(
            convId: convId,
            role: role,
            content: content,
          ),
        );
    await (_db.update(_db.nexusConversations)
          ..where((t) => t.id.equals(convId)))
        .write(const NexusConversationsCompanion(
      updatedAt: Value.absent(),
    ));
  }

  Future<void> deleteConversation(int convId) async {
    await (_db.delete(_db.nexusMessages)
          ..where((t) => t.convId.equals(convId)))
        .go();
    await (_db.delete(_db.nexusConversations)
          ..where((t) => t.id.equals(convId)))
        .go();
  }

  Future<void> renameConversation(int convId, String title) async {
    await (_db.update(_db.nexusConversations)
          ..where((t) => t.id.equals(convId)))
        .write(NexusConversationsCompanion(
      title: Value(title),
      updatedAt: Value(DateTime.now()),
    ));
  }
}

final nexusChatRepositoryProvider = Provider<NexusChatRepository>((ref) {
  return NexusChatRepository(ref.watch(appDatabaseProvider));
});

final nexusConversationsProvider =
    StreamProvider<List<NexusConversation>>((ref) {
  return ref.watch(nexusChatRepositoryProvider).watchConversations();
});

final nexusMessagesProvider =
    StreamProvider.family<List<NexusMessage>, int>((ref, convId) {
  return ref.watch(nexusChatRepositoryProvider).watchMessages(convId);
});