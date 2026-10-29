import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Repos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get path => text().unique()();
  DateTimeColumn get lastOpened => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

class Snippets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get language => text().withDefault(const Constant('plaintext'))();
  TextColumn get tags => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get repoPath => text()();
  TextColumn get commitHash => text().nullable()();
  TextColumn get title => text()();
  TextColumn get body => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class RepoFeatures extends Table {
  IntColumn get repoId => integer()();
  TextColumn get feature => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {repoId, feature};
}

class NexusProviders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get label => text()();
  TextColumn get baseUrl => text()();
  TextColumn get apiKey => text().withDefault(const Constant(''))();
  TextColumn get model => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get maxTokens => integer().withDefault(const Constant(2048))();
  RealColumn get temperature => real().withDefault(const Constant(0.2))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class NexusConversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant('محادثة جديدة'))();
  TextColumn get repoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class NexusMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get convId => integer()();
  TextColumn get role => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class AgentMemories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    Repos, Settings, Snippets, JournalEntries, RepoFeatures,
    NexusProviders, NexusConversations, NexusMessages, AgentMemories,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(snippets);
            await m.createTable(journalEntries);
          }
          if (from < 3) {
            await m.createTable(repoFeatures);
          }
          if (from < 5) {
            await m.createTable(nexusProviders);
          }
          if (from < 6) {
            await m.createTable(nexusConversations);
            await m.createTable(nexusMessages);
          }
          if (from < 7) {
            await m.createTable(agentMemories);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'nexhub.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});