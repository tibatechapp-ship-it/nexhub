// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ReposTable extends Repos with TableInfo<$ReposTable, Repo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReposTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _lastOpenedMeta =
      const VerificationMeta('lastOpened');
  @override
  late final GeneratedColumn<DateTime> lastOpened = GeneratedColumn<DateTime>(
      'last_opened', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, path, lastOpened, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repos';
  @override
  VerificationContext validateIntegrity(Insertable<Repo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('last_opened')) {
      context.handle(
          _lastOpenedMeta,
          lastOpened.isAcceptableOrUnknown(
              data['last_opened']!, _lastOpenedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Repo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Repo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      lastOpened: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_opened']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReposTable createAlias(String alias) {
    return $ReposTable(attachedDatabase, alias);
  }
}

class Repo extends DataClass implements Insertable<Repo> {
  final int id;
  final String name;
  final String path;
  final DateTime? lastOpened;
  final DateTime createdAt;
  const Repo(
      {required this.id,
      required this.name,
      required this.path,
      this.lastOpened,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || lastOpened != null) {
      map['last_opened'] = Variable<DateTime>(lastOpened);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReposCompanion toCompanion(bool nullToAbsent) {
    return ReposCompanion(
      id: Value(id),
      name: Value(name),
      path: Value(path),
      lastOpened: lastOpened == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpened),
      createdAt: Value(createdAt),
    );
  }

  factory Repo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Repo(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      path: serializer.fromJson<String>(json['path']),
      lastOpened: serializer.fromJson<DateTime?>(json['lastOpened']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'path': serializer.toJson<String>(path),
      'lastOpened': serializer.toJson<DateTime?>(lastOpened),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Repo copyWith(
          {int? id,
          String? name,
          String? path,
          Value<DateTime?> lastOpened = const Value.absent(),
          DateTime? createdAt}) =>
      Repo(
        id: id ?? this.id,
        name: name ?? this.name,
        path: path ?? this.path,
        lastOpened: lastOpened.present ? lastOpened.value : this.lastOpened,
        createdAt: createdAt ?? this.createdAt,
      );
  Repo copyWithCompanion(ReposCompanion data) {
    return Repo(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      path: data.path.present ? data.path.value : this.path,
      lastOpened:
          data.lastOpened.present ? data.lastOpened.value : this.lastOpened,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Repo(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('lastOpened: $lastOpened, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, path, lastOpened, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Repo &&
          other.id == this.id &&
          other.name == this.name &&
          other.path == this.path &&
          other.lastOpened == this.lastOpened &&
          other.createdAt == this.createdAt);
}

class ReposCompanion extends UpdateCompanion<Repo> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> path;
  final Value<DateTime?> lastOpened;
  final Value<DateTime> createdAt;
  const ReposCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.path = const Value.absent(),
    this.lastOpened = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReposCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String path,
    this.lastOpened = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        path = Value(path);
  static Insertable<Repo> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? path,
    Expression<DateTime>? lastOpened,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (path != null) 'path': path,
      if (lastOpened != null) 'last_opened': lastOpened,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReposCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? path,
      Value<DateTime?>? lastOpened,
      Value<DateTime>? createdAt}) {
    return ReposCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      lastOpened: lastOpened ?? this.lastOpened,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (lastOpened.present) {
      map['last_opened'] = Variable<DateTime>(lastOpened.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReposCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('lastOpened: $lastOpened, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnippetsTable extends Snippets with TableInfo<$SnippetsTable, Snippet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('plaintext'));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, language, tags, updatedAt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippets';
  @override
  VerificationContext validateIntegrity(Insertable<Snippet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Snippet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snippet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SnippetsTable createAlias(String alias) {
    return $SnippetsTable(attachedDatabase, alias);
  }
}

class Snippet extends DataClass implements Insertable<Snippet> {
  final int id;
  final String title;
  final String body;
  final String language;
  final String tags;
  final DateTime updatedAt;
  final DateTime createdAt;
  const Snippet(
      {required this.id,
      required this.title,
      required this.body,
      required this.language,
      required this.tags,
      required this.updatedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['language'] = Variable<String>(language);
    map['tags'] = Variable<String>(tags);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SnippetsCompanion toCompanion(bool nullToAbsent) {
    return SnippetsCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      language: Value(language),
      tags: Value(tags),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory Snippet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snippet(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      language: serializer.fromJson<String>(json['language']),
      tags: serializer.fromJson<String>(json['tags']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'language': serializer.toJson<String>(language),
      'tags': serializer.toJson<String>(tags),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Snippet copyWith(
          {int? id,
          String? title,
          String? body,
          String? language,
          String? tags,
          DateTime? updatedAt,
          DateTime? createdAt}) =>
      Snippet(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        language: language ?? this.language,
        tags: tags ?? this.tags,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  Snippet copyWithCompanion(SnippetsCompanion data) {
    return Snippet(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      language: data.language.present ? data.language.value : this.language,
      tags: data.tags.present ? data.tags.value : this.tags,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snippet(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('language: $language, ')
          ..write('tags: $tags, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, body, language, tags, updatedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snippet &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.language == this.language &&
          other.tags == this.tags &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class SnippetsCompanion extends UpdateCompanion<Snippet> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> language;
  final Value<String> tags;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  const SnippetsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.language = const Value.absent(),
    this.tags = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SnippetsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String body,
    this.language = const Value.absent(),
    this.tags = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : title = Value(title),
        body = Value(body);
  static Insertable<Snippet> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? language,
    Expression<String>? tags,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (language != null) 'language': language,
      if (tags != null) 'tags': tags,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SnippetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String>? language,
      Value<String>? tags,
      Value<DateTime>? updatedAt,
      Value<DateTime>? createdAt}) {
    return SnippetsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      language: language ?? this.language,
      tags: tags ?? this.tags,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('language: $language, ')
          ..write('tags: $tags, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _repoPathMeta =
      const VerificationMeta('repoPath');
  @override
  late final GeneratedColumn<String> repoPath = GeneratedColumn<String>(
      'repo_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commitHashMeta =
      const VerificationMeta('commitHash');
  @override
  late final GeneratedColumn<String> commitHash = GeneratedColumn<String>(
      'commit_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, repoPath, commitHash, title, body, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('repo_path')) {
      context.handle(_repoPathMeta,
          repoPath.isAcceptableOrUnknown(data['repo_path']!, _repoPathMeta));
    } else if (isInserting) {
      context.missing(_repoPathMeta);
    }
    if (data.containsKey('commit_hash')) {
      context.handle(
          _commitHashMeta,
          commitHash.isAcceptableOrUnknown(
              data['commit_hash']!, _commitHashMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      repoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repo_path'])!,
      commitHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}commit_hash']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final String repoPath;
  final String? commitHash;
  final String title;
  final String body;
  final DateTime createdAt;
  const JournalEntry(
      {required this.id,
      required this.repoPath,
      this.commitHash,
      required this.title,
      required this.body,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['repo_path'] = Variable<String>(repoPath);
    if (!nullToAbsent || commitHash != null) {
      map['commit_hash'] = Variable<String>(commitHash);
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      repoPath: Value(repoPath),
      commitHash: commitHash == null && nullToAbsent
          ? const Value.absent()
          : Value(commitHash),
      title: Value(title),
      body: Value(body),
      createdAt: Value(createdAt),
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      repoPath: serializer.fromJson<String>(json['repoPath']),
      commitHash: serializer.fromJson<String?>(json['commitHash']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'repoPath': serializer.toJson<String>(repoPath),
      'commitHash': serializer.toJson<String?>(commitHash),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  JournalEntry copyWith(
          {int? id,
          String? repoPath,
          Value<String?> commitHash = const Value.absent(),
          String? title,
          String? body,
          DateTime? createdAt}) =>
      JournalEntry(
        id: id ?? this.id,
        repoPath: repoPath ?? this.repoPath,
        commitHash: commitHash.present ? commitHash.value : this.commitHash,
        title: title ?? this.title,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
      );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      repoPath: data.repoPath.present ? data.repoPath.value : this.repoPath,
      commitHash:
          data.commitHash.present ? data.commitHash.value : this.commitHash,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('repoPath: $repoPath, ')
          ..write('commitHash: $commitHash, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, repoPath, commitHash, title, body, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.repoPath == this.repoPath &&
          other.commitHash == this.commitHash &&
          other.title == this.title &&
          other.body == this.body &&
          other.createdAt == this.createdAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String> repoPath;
  final Value<String?> commitHash;
  final Value<String> title;
  final Value<String> body;
  final Value<DateTime> createdAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.repoPath = const Value.absent(),
    this.commitHash = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String repoPath,
    this.commitHash = const Value.absent(),
    required String title,
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : repoPath = Value(repoPath),
        title = Value(title);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? repoPath,
    Expression<String>? commitHash,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repoPath != null) 'repo_path': repoPath,
      if (commitHash != null) 'commit_hash': commitHash,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  JournalEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? repoPath,
      Value<String?>? commitHash,
      Value<String>? title,
      Value<String>? body,
      Value<DateTime>? createdAt}) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      repoPath: repoPath ?? this.repoPath,
      commitHash: commitHash ?? this.commitHash,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (repoPath.present) {
      map['repo_path'] = Variable<String>(repoPath.value);
    }
    if (commitHash.present) {
      map['commit_hash'] = Variable<String>(commitHash.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('repoPath: $repoPath, ')
          ..write('commitHash: $commitHash, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RepoFeaturesTable extends RepoFeatures
    with TableInfo<$RepoFeaturesTable, RepoFeature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepoFeaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _repoIdMeta = const VerificationMeta('repoId');
  @override
  late final GeneratedColumn<int> repoId = GeneratedColumn<int>(
      'repo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _featureMeta =
      const VerificationMeta('feature');
  @override
  late final GeneratedColumn<String> feature = GeneratedColumn<String>(
      'feature', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [repoId, feature, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repo_features';
  @override
  VerificationContext validateIntegrity(Insertable<RepoFeature> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('repo_id')) {
      context.handle(_repoIdMeta,
          repoId.isAcceptableOrUnknown(data['repo_id']!, _repoIdMeta));
    } else if (isInserting) {
      context.missing(_repoIdMeta);
    }
    if (data.containsKey('feature')) {
      context.handle(_featureMeta,
          feature.isAcceptableOrUnknown(data['feature']!, _featureMeta));
    } else if (isInserting) {
      context.missing(_featureMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {repoId, feature};
  @override
  RepoFeature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepoFeature(
      repoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repo_id'])!,
      feature: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}feature'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
    );
  }

  @override
  $RepoFeaturesTable createAlias(String alias) {
    return $RepoFeaturesTable(attachedDatabase, alias);
  }
}

class RepoFeature extends DataClass implements Insertable<RepoFeature> {
  final int repoId;
  final String feature;
  final bool enabled;
  const RepoFeature(
      {required this.repoId, required this.feature, required this.enabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['repo_id'] = Variable<int>(repoId);
    map['feature'] = Variable<String>(feature);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  RepoFeaturesCompanion toCompanion(bool nullToAbsent) {
    return RepoFeaturesCompanion(
      repoId: Value(repoId),
      feature: Value(feature),
      enabled: Value(enabled),
    );
  }

  factory RepoFeature.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepoFeature(
      repoId: serializer.fromJson<int>(json['repoId']),
      feature: serializer.fromJson<String>(json['feature']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'repoId': serializer.toJson<int>(repoId),
      'feature': serializer.toJson<String>(feature),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  RepoFeature copyWith({int? repoId, String? feature, bool? enabled}) =>
      RepoFeature(
        repoId: repoId ?? this.repoId,
        feature: feature ?? this.feature,
        enabled: enabled ?? this.enabled,
      );
  RepoFeature copyWithCompanion(RepoFeaturesCompanion data) {
    return RepoFeature(
      repoId: data.repoId.present ? data.repoId.value : this.repoId,
      feature: data.feature.present ? data.feature.value : this.feature,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepoFeature(')
          ..write('repoId: $repoId, ')
          ..write('feature: $feature, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(repoId, feature, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepoFeature &&
          other.repoId == this.repoId &&
          other.feature == this.feature &&
          other.enabled == this.enabled);
}

class RepoFeaturesCompanion extends UpdateCompanion<RepoFeature> {
  final Value<int> repoId;
  final Value<String> feature;
  final Value<bool> enabled;
  final Value<int> rowid;
  const RepoFeaturesCompanion({
    this.repoId = const Value.absent(),
    this.feature = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepoFeaturesCompanion.insert({
    required int repoId,
    required String feature,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : repoId = Value(repoId),
        feature = Value(feature);
  static Insertable<RepoFeature> custom({
    Expression<int>? repoId,
    Expression<String>? feature,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (repoId != null) 'repo_id': repoId,
      if (feature != null) 'feature': feature,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepoFeaturesCompanion copyWith(
      {Value<int>? repoId,
      Value<String>? feature,
      Value<bool>? enabled,
      Value<int>? rowid}) {
    return RepoFeaturesCompanion(
      repoId: repoId ?? this.repoId,
      feature: feature ?? this.feature,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (repoId.present) {
      map['repo_id'] = Variable<int>(repoId.value);
    }
    if (feature.present) {
      map['feature'] = Variable<String>(feature.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepoFeaturesCompanion(')
          ..write('repoId: $repoId, ')
          ..write('feature: $feature, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NexusProvidersTable extends NexusProviders
    with TableInfo<$NexusProvidersTable, NexusProvider> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NexusProvidersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseUrlMeta =
      const VerificationMeta('baseUrl');
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
      'base_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  @override
  late final GeneratedColumn<String> apiKey = GeneratedColumn<String>(
      'api_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _maxTokensMeta =
      const VerificationMeta('maxTokens');
  @override
  late final GeneratedColumn<int> maxTokens = GeneratedColumn<int>(
      'max_tokens', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2048));
  static const VerificationMeta _temperatureMeta =
      const VerificationMeta('temperature');
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
      'temperature', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.2));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        label,
        baseUrl,
        apiKey,
        model,
        enabled,
        isDefault,
        maxTokens,
        temperature,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nexus_providers';
  @override
  VerificationContext validateIntegrity(Insertable<NexusProvider> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(_baseUrlMeta,
          baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta));
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('api_key')) {
      context.handle(_apiKeyMeta,
          apiKey.isAcceptableOrUnknown(data['api_key']!, _apiKeyMeta));
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('max_tokens')) {
      context.handle(_maxTokensMeta,
          maxTokens.isAcceptableOrUnknown(data['max_tokens']!, _maxTokensMeta));
    }
    if (data.containsKey('temperature')) {
      context.handle(
          _temperatureMeta,
          temperature.isAcceptableOrUnknown(
              data['temperature']!, _temperatureMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NexusProvider map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NexusProvider(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      baseUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_url'])!,
      apiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_key'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      maxTokens: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_tokens'])!,
      temperature: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temperature'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NexusProvidersTable createAlias(String alias) {
    return $NexusProvidersTable(attachedDatabase, alias);
  }
}

class NexusProvider extends DataClass implements Insertable<NexusProvider> {
  final int id;
  final String name;
  final String label;
  final String baseUrl;
  final String apiKey;
  final String model;
  final bool enabled;
  final bool isDefault;
  final int maxTokens;
  final double temperature;
  final DateTime updatedAt;
  const NexusProvider(
      {required this.id,
      required this.name,
      required this.label,
      required this.baseUrl,
      required this.apiKey,
      required this.model,
      required this.enabled,
      required this.isDefault,
      required this.maxTokens,
      required this.temperature,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['label'] = Variable<String>(label);
    map['base_url'] = Variable<String>(baseUrl);
    map['api_key'] = Variable<String>(apiKey);
    map['model'] = Variable<String>(model);
    map['enabled'] = Variable<bool>(enabled);
    map['is_default'] = Variable<bool>(isDefault);
    map['max_tokens'] = Variable<int>(maxTokens);
    map['temperature'] = Variable<double>(temperature);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NexusProvidersCompanion toCompanion(bool nullToAbsent) {
    return NexusProvidersCompanion(
      id: Value(id),
      name: Value(name),
      label: Value(label),
      baseUrl: Value(baseUrl),
      apiKey: Value(apiKey),
      model: Value(model),
      enabled: Value(enabled),
      isDefault: Value(isDefault),
      maxTokens: Value(maxTokens),
      temperature: Value(temperature),
      updatedAt: Value(updatedAt),
    );
  }

  factory NexusProvider.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NexusProvider(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      label: serializer.fromJson<String>(json['label']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      apiKey: serializer.fromJson<String>(json['apiKey']),
      model: serializer.fromJson<String>(json['model']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      maxTokens: serializer.fromJson<int>(json['maxTokens']),
      temperature: serializer.fromJson<double>(json['temperature']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'label': serializer.toJson<String>(label),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'apiKey': serializer.toJson<String>(apiKey),
      'model': serializer.toJson<String>(model),
      'enabled': serializer.toJson<bool>(enabled),
      'isDefault': serializer.toJson<bool>(isDefault),
      'maxTokens': serializer.toJson<int>(maxTokens),
      'temperature': serializer.toJson<double>(temperature),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NexusProvider copyWith(
          {int? id,
          String? name,
          String? label,
          String? baseUrl,
          String? apiKey,
          String? model,
          bool? enabled,
          bool? isDefault,
          int? maxTokens,
          double? temperature,
          DateTime? updatedAt}) =>
      NexusProvider(
        id: id ?? this.id,
        name: name ?? this.name,
        label: label ?? this.label,
        baseUrl: baseUrl ?? this.baseUrl,
        apiKey: apiKey ?? this.apiKey,
        model: model ?? this.model,
        enabled: enabled ?? this.enabled,
        isDefault: isDefault ?? this.isDefault,
        maxTokens: maxTokens ?? this.maxTokens,
        temperature: temperature ?? this.temperature,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NexusProvider copyWithCompanion(NexusProvidersCompanion data) {
    return NexusProvider(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      label: data.label.present ? data.label.value : this.label,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      apiKey: data.apiKey.present ? data.apiKey.value : this.apiKey,
      model: data.model.present ? data.model.value : this.model,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      maxTokens: data.maxTokens.present ? data.maxTokens.value : this.maxTokens,
      temperature:
          data.temperature.present ? data.temperature.value : this.temperature,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NexusProvider(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('label: $label, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('apiKey: $apiKey, ')
          ..write('model: $model, ')
          ..write('enabled: $enabled, ')
          ..write('isDefault: $isDefault, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('temperature: $temperature, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, label, baseUrl, apiKey, model,
      enabled, isDefault, maxTokens, temperature, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NexusProvider &&
          other.id == this.id &&
          other.name == this.name &&
          other.label == this.label &&
          other.baseUrl == this.baseUrl &&
          other.apiKey == this.apiKey &&
          other.model == this.model &&
          other.enabled == this.enabled &&
          other.isDefault == this.isDefault &&
          other.maxTokens == this.maxTokens &&
          other.temperature == this.temperature &&
          other.updatedAt == this.updatedAt);
}

class NexusProvidersCompanion extends UpdateCompanion<NexusProvider> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> label;
  final Value<String> baseUrl;
  final Value<String> apiKey;
  final Value<String> model;
  final Value<bool> enabled;
  final Value<bool> isDefault;
  final Value<int> maxTokens;
  final Value<double> temperature;
  final Value<DateTime> updatedAt;
  const NexusProvidersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.label = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.model = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.maxTokens = const Value.absent(),
    this.temperature = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NexusProvidersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String label,
    required String baseUrl,
    this.apiKey = const Value.absent(),
    required String model,
    this.enabled = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.maxTokens = const Value.absent(),
    this.temperature = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        label = Value(label),
        baseUrl = Value(baseUrl),
        model = Value(model);
  static Insertable<NexusProvider> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? label,
    Expression<String>? baseUrl,
    Expression<String>? apiKey,
    Expression<String>? model,
    Expression<bool>? enabled,
    Expression<bool>? isDefault,
    Expression<int>? maxTokens,
    Expression<double>? temperature,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (label != null) 'label': label,
      if (baseUrl != null) 'base_url': baseUrl,
      if (apiKey != null) 'api_key': apiKey,
      if (model != null) 'model': model,
      if (enabled != null) 'enabled': enabled,
      if (isDefault != null) 'is_default': isDefault,
      if (maxTokens != null) 'max_tokens': maxTokens,
      if (temperature != null) 'temperature': temperature,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NexusProvidersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? label,
      Value<String>? baseUrl,
      Value<String>? apiKey,
      Value<String>? model,
      Value<bool>? enabled,
      Value<bool>? isDefault,
      Value<int>? maxTokens,
      Value<double>? temperature,
      Value<DateTime>? updatedAt}) {
    return NexusProvidersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      model: model ?? this.model,
      enabled: enabled ?? this.enabled,
      isDefault: isDefault ?? this.isDefault,
      maxTokens: maxTokens ?? this.maxTokens,
      temperature: temperature ?? this.temperature,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (maxTokens.present) {
      map['max_tokens'] = Variable<int>(maxTokens.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NexusProvidersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('label: $label, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('apiKey: $apiKey, ')
          ..write('model: $model, ')
          ..write('enabled: $enabled, ')
          ..write('isDefault: $isDefault, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('temperature: $temperature, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NexusConversationsTable extends NexusConversations
    with TableInfo<$NexusConversationsTable, NexusConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NexusConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('محادثة جديدة'));
  static const VerificationMeta _repoPathMeta =
      const VerificationMeta('repoPath');
  @override
  late final GeneratedColumn<String> repoPath = GeneratedColumn<String>(
      'repo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, repoPath, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nexus_conversations';
  @override
  VerificationContext validateIntegrity(Insertable<NexusConversation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('repo_path')) {
      context.handle(_repoPathMeta,
          repoPath.isAcceptableOrUnknown(data['repo_path']!, _repoPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NexusConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NexusConversation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      repoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repo_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NexusConversationsTable createAlias(String alias) {
    return $NexusConversationsTable(attachedDatabase, alias);
  }
}

class NexusConversation extends DataClass
    implements Insertable<NexusConversation> {
  final int id;
  final String title;
  final String? repoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NexusConversation(
      {required this.id,
      required this.title,
      this.repoPath,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || repoPath != null) {
      map['repo_path'] = Variable<String>(repoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NexusConversationsCompanion toCompanion(bool nullToAbsent) {
    return NexusConversationsCompanion(
      id: Value(id),
      title: Value(title),
      repoPath: repoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(repoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NexusConversation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NexusConversation(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      repoPath: serializer.fromJson<String?>(json['repoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'repoPath': serializer.toJson<String?>(repoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NexusConversation copyWith(
          {int? id,
          String? title,
          Value<String?> repoPath = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      NexusConversation(
        id: id ?? this.id,
        title: title ?? this.title,
        repoPath: repoPath.present ? repoPath.value : this.repoPath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NexusConversation copyWithCompanion(NexusConversationsCompanion data) {
    return NexusConversation(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      repoPath: data.repoPath.present ? data.repoPath.value : this.repoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NexusConversation(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('repoPath: $repoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, repoPath, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NexusConversation &&
          other.id == this.id &&
          other.title == this.title &&
          other.repoPath == this.repoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NexusConversationsCompanion extends UpdateCompanion<NexusConversation> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> repoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const NexusConversationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.repoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NexusConversationsCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.repoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<NexusConversation> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? repoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (repoPath != null) 'repo_path': repoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NexusConversationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? repoPath,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return NexusConversationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      repoPath: repoPath ?? this.repoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (repoPath.present) {
      map['repo_path'] = Variable<String>(repoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NexusConversationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('repoPath: $repoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NexusMessagesTable extends NexusMessages
    with TableInfo<$NexusMessagesTable, NexusMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NexusMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _convIdMeta = const VerificationMeta('convId');
  @override
  late final GeneratedColumn<int> convId = GeneratedColumn<int>(
      'conv_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, convId, role, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nexus_messages';
  @override
  VerificationContext validateIntegrity(Insertable<NexusMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('conv_id')) {
      context.handle(_convIdMeta,
          convId.isAcceptableOrUnknown(data['conv_id']!, _convIdMeta));
    } else if (isInserting) {
      context.missing(_convIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NexusMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NexusMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      convId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}conv_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $NexusMessagesTable createAlias(String alias) {
    return $NexusMessagesTable(attachedDatabase, alias);
  }
}

class NexusMessage extends DataClass implements Insertable<NexusMessage> {
  final int id;
  final int convId;
  final String role;
  final String content;
  final DateTime createdAt;
  const NexusMessage(
      {required this.id,
      required this.convId,
      required this.role,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['conv_id'] = Variable<int>(convId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NexusMessagesCompanion toCompanion(bool nullToAbsent) {
    return NexusMessagesCompanion(
      id: Value(id),
      convId: Value(convId),
      role: Value(role),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory NexusMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NexusMessage(
      id: serializer.fromJson<int>(json['id']),
      convId: serializer.fromJson<int>(json['convId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'convId': serializer.toJson<int>(convId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NexusMessage copyWith(
          {int? id,
          int? convId,
          String? role,
          String? content,
          DateTime? createdAt}) =>
      NexusMessage(
        id: id ?? this.id,
        convId: convId ?? this.convId,
        role: role ?? this.role,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  NexusMessage copyWithCompanion(NexusMessagesCompanion data) {
    return NexusMessage(
      id: data.id.present ? data.id.value : this.id,
      convId: data.convId.present ? data.convId.value : this.convId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NexusMessage(')
          ..write('id: $id, ')
          ..write('convId: $convId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, convId, role, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NexusMessage &&
          other.id == this.id &&
          other.convId == this.convId &&
          other.role == this.role &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class NexusMessagesCompanion extends UpdateCompanion<NexusMessage> {
  final Value<int> id;
  final Value<int> convId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> createdAt;
  const NexusMessagesCompanion({
    this.id = const Value.absent(),
    this.convId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NexusMessagesCompanion.insert({
    this.id = const Value.absent(),
    required int convId,
    required String role,
    required String content,
    this.createdAt = const Value.absent(),
  })  : convId = Value(convId),
        role = Value(role),
        content = Value(content);
  static Insertable<NexusMessage> custom({
    Expression<int>? id,
    Expression<int>? convId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (convId != null) 'conv_id': convId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NexusMessagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? convId,
      Value<String>? role,
      Value<String>? content,
      Value<DateTime>? createdAt}) {
    return NexusMessagesCompanion(
      id: id ?? this.id,
      convId: convId ?? this.convId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (convId.present) {
      map['conv_id'] = Variable<int>(convId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NexusMessagesCompanion(')
          ..write('id: $id, ')
          ..write('convId: $convId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AgentMemoriesTable extends AgentMemories
    with TableInfo<$AgentMemoriesTable, AgentMemory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgentMemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, key, value, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agent_memories';
  @override
  VerificationContext validateIntegrity(Insertable<AgentMemory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AgentMemory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgentMemory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AgentMemoriesTable createAlias(String alias) {
    return $AgentMemoriesTable(attachedDatabase, alias);
  }
}

class AgentMemory extends DataClass implements Insertable<AgentMemory> {
  final int id;
  final String key;
  final String value;
  final DateTime createdAt;
  const AgentMemory(
      {required this.id,
      required this.key,
      required this.value,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AgentMemoriesCompanion toCompanion(bool nullToAbsent) {
    return AgentMemoriesCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      createdAt: Value(createdAt),
    );
  }

  factory AgentMemory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgentMemory(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AgentMemory copyWith(
          {int? id, String? key, String? value, DateTime? createdAt}) =>
      AgentMemory(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
        createdAt: createdAt ?? this.createdAt,
      );
  AgentMemory copyWithCompanion(AgentMemoriesCompanion data) {
    return AgentMemory(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgentMemory(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgentMemory &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.createdAt == this.createdAt);
}

class AgentMemoriesCompanion extends UpdateCompanion<AgentMemory> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> createdAt;
  const AgentMemoriesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AgentMemoriesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
    this.createdAt = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AgentMemory> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AgentMemoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? key,
      Value<String>? value,
      Value<DateTime>? createdAt}) {
    return AgentMemoriesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgentMemoriesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReposTable repos = $ReposTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $SnippetsTable snippets = $SnippetsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $RepoFeaturesTable repoFeatures = $RepoFeaturesTable(this);
  late final $NexusProvidersTable nexusProviders = $NexusProvidersTable(this);
  late final $NexusConversationsTable nexusConversations =
      $NexusConversationsTable(this);
  late final $NexusMessagesTable nexusMessages = $NexusMessagesTable(this);
  late final $AgentMemoriesTable agentMemories = $AgentMemoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        repos,
        settings,
        snippets,
        journalEntries,
        repoFeatures,
        nexusProviders,
        nexusConversations,
        nexusMessages,
        agentMemories
      ];
}

typedef $$ReposTableCreateCompanionBuilder = ReposCompanion Function({
  Value<int> id,
  required String name,
  required String path,
  Value<DateTime?> lastOpened,
  Value<DateTime> createdAt,
});
typedef $$ReposTableUpdateCompanionBuilder = ReposCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> path,
  Value<DateTime?> lastOpened,
  Value<DateTime> createdAt,
});

class $$ReposTableFilterComposer extends Composer<_$AppDatabase, $ReposTable> {
  $$ReposTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastOpened => $composableBuilder(
      column: $table.lastOpened, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ReposTableOrderingComposer
    extends Composer<_$AppDatabase, $ReposTable> {
  $$ReposTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastOpened => $composableBuilder(
      column: $table.lastOpened, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ReposTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReposTable> {
  $$ReposTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpened => $composableBuilder(
      column: $table.lastOpened, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReposTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReposTable,
    Repo,
    $$ReposTableFilterComposer,
    $$ReposTableOrderingComposer,
    $$ReposTableAnnotationComposer,
    $$ReposTableCreateCompanionBuilder,
    $$ReposTableUpdateCompanionBuilder,
    (Repo, BaseReferences<_$AppDatabase, $ReposTable, Repo>),
    Repo,
    PrefetchHooks Function()> {
  $$ReposTableTableManager(_$AppDatabase db, $ReposTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReposTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReposTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReposTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<DateTime?> lastOpened = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ReposCompanion(
            id: id,
            name: name,
            path: path,
            lastOpened: lastOpened,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String path,
            Value<DateTime?> lastOpened = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ReposCompanion.insert(
            id: id,
            name: name,
            path: path,
            lastOpened: lastOpened,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReposTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReposTable,
    Repo,
    $$ReposTableFilterComposer,
    $$ReposTableOrderingComposer,
    $$ReposTableAnnotationComposer,
    $$ReposTableCreateCompanionBuilder,
    $$ReposTableUpdateCompanionBuilder,
    (Repo, BaseReferences<_$AppDatabase, $ReposTable, Repo>),
    Repo,
    PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;
typedef $$SnippetsTableCreateCompanionBuilder = SnippetsCompanion Function({
  Value<int> id,
  required String title,
  required String body,
  Value<String> language,
  Value<String> tags,
  Value<DateTime> updatedAt,
  Value<DateTime> createdAt,
});
typedef $$SnippetsTableUpdateCompanionBuilder = SnippetsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> body,
  Value<String> language,
  Value<String> tags,
  Value<DateTime> updatedAt,
  Value<DateTime> createdAt,
});

class $$SnippetsTableFilterComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SnippetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SnippetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SnippetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SnippetsTable,
    Snippet,
    $$SnippetsTableFilterComposer,
    $$SnippetsTableOrderingComposer,
    $$SnippetsTableAnnotationComposer,
    $$SnippetsTableCreateCompanionBuilder,
    $$SnippetsTableUpdateCompanionBuilder,
    (Snippet, BaseReferences<_$AppDatabase, $SnippetsTable, Snippet>),
    Snippet,
    PrefetchHooks Function()> {
  $$SnippetsTableTableManager(_$AppDatabase db, $SnippetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnippetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnippetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnippetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnippetsCompanion(
            id: id,
            title: title,
            body: body,
            language: language,
            tags: tags,
            updatedAt: updatedAt,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String body,
            Value<String> language = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SnippetsCompanion.insert(
            id: id,
            title: title,
            body: body,
            language: language,
            tags: tags,
            updatedAt: updatedAt,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SnippetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SnippetsTable,
    Snippet,
    $$SnippetsTableFilterComposer,
    $$SnippetsTableOrderingComposer,
    $$SnippetsTableAnnotationComposer,
    $$SnippetsTableCreateCompanionBuilder,
    $$SnippetsTableUpdateCompanionBuilder,
    (Snippet, BaseReferences<_$AppDatabase, $SnippetsTable, Snippet>),
    Snippet,
    PrefetchHooks Function()>;
typedef $$JournalEntriesTableCreateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  required String repoPath,
  Value<String?> commitHash,
  required String title,
  Value<String> body,
  Value<DateTime> createdAt,
});
typedef $$JournalEntriesTableUpdateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  Value<String> repoPath,
  Value<String?> commitHash,
  Value<String> title,
  Value<String> body,
  Value<DateTime> createdAt,
});

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repoPath => $composableBuilder(
      column: $table.repoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commitHash => $composableBuilder(
      column: $table.commitHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repoPath => $composableBuilder(
      column: $table.repoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commitHash => $composableBuilder(
      column: $table.commitHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get repoPath =>
      $composableBuilder(column: $table.repoPath, builder: (column) => column);

  GeneratedColumn<String> get commitHash => $composableBuilder(
      column: $table.commitHash, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$JournalEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (
      JournalEntry,
      BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>
    ),
    JournalEntry,
    PrefetchHooks Function()> {
  $$JournalEntriesTableTableManager(
      _$AppDatabase db, $JournalEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> repoPath = const Value.absent(),
            Value<String?> commitHash = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              JournalEntriesCompanion(
            id: id,
            repoPath: repoPath,
            commitHash: commitHash,
            title: title,
            body: body,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String repoPath,
            Value<String?> commitHash = const Value.absent(),
            required String title,
            Value<String> body = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              JournalEntriesCompanion.insert(
            id: id,
            repoPath: repoPath,
            commitHash: commitHash,
            title: title,
            body: body,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JournalEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (
      JournalEntry,
      BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>
    ),
    JournalEntry,
    PrefetchHooks Function()>;
typedef $$RepoFeaturesTableCreateCompanionBuilder = RepoFeaturesCompanion
    Function({
  required int repoId,
  required String feature,
  Value<bool> enabled,
  Value<int> rowid,
});
typedef $$RepoFeaturesTableUpdateCompanionBuilder = RepoFeaturesCompanion
    Function({
  Value<int> repoId,
  Value<String> feature,
  Value<bool> enabled,
  Value<int> rowid,
});

class $$RepoFeaturesTableFilterComposer
    extends Composer<_$AppDatabase, $RepoFeaturesTable> {
  $$RepoFeaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get repoId => $composableBuilder(
      column: $table.repoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get feature => $composableBuilder(
      column: $table.feature, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));
}

class $$RepoFeaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $RepoFeaturesTable> {
  $$RepoFeaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get repoId => $composableBuilder(
      column: $table.repoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get feature => $composableBuilder(
      column: $table.feature, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));
}

class $$RepoFeaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepoFeaturesTable> {
  $$RepoFeaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get repoId =>
      $composableBuilder(column: $table.repoId, builder: (column) => column);

  GeneratedColumn<String> get feature =>
      $composableBuilder(column: $table.feature, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$RepoFeaturesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RepoFeaturesTable,
    RepoFeature,
    $$RepoFeaturesTableFilterComposer,
    $$RepoFeaturesTableOrderingComposer,
    $$RepoFeaturesTableAnnotationComposer,
    $$RepoFeaturesTableCreateCompanionBuilder,
    $$RepoFeaturesTableUpdateCompanionBuilder,
    (
      RepoFeature,
      BaseReferences<_$AppDatabase, $RepoFeaturesTable, RepoFeature>
    ),
    RepoFeature,
    PrefetchHooks Function()> {
  $$RepoFeaturesTableTableManager(_$AppDatabase db, $RepoFeaturesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepoFeaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepoFeaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepoFeaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> repoId = const Value.absent(),
            Value<String> feature = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RepoFeaturesCompanion(
            repoId: repoId,
            feature: feature,
            enabled: enabled,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int repoId,
            required String feature,
            Value<bool> enabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RepoFeaturesCompanion.insert(
            repoId: repoId,
            feature: feature,
            enabled: enabled,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RepoFeaturesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RepoFeaturesTable,
    RepoFeature,
    $$RepoFeaturesTableFilterComposer,
    $$RepoFeaturesTableOrderingComposer,
    $$RepoFeaturesTableAnnotationComposer,
    $$RepoFeaturesTableCreateCompanionBuilder,
    $$RepoFeaturesTableUpdateCompanionBuilder,
    (
      RepoFeature,
      BaseReferences<_$AppDatabase, $RepoFeaturesTable, RepoFeature>
    ),
    RepoFeature,
    PrefetchHooks Function()>;
typedef $$NexusProvidersTableCreateCompanionBuilder = NexusProvidersCompanion
    Function({
  Value<int> id,
  required String name,
  required String label,
  required String baseUrl,
  Value<String> apiKey,
  required String model,
  Value<bool> enabled,
  Value<bool> isDefault,
  Value<int> maxTokens,
  Value<double> temperature,
  Value<DateTime> updatedAt,
});
typedef $$NexusProvidersTableUpdateCompanionBuilder = NexusProvidersCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> label,
  Value<String> baseUrl,
  Value<String> apiKey,
  Value<String> model,
  Value<bool> enabled,
  Value<bool> isDefault,
  Value<int> maxTokens,
  Value<double> temperature,
  Value<DateTime> updatedAt,
});

class $$NexusProvidersTableFilterComposer
    extends Composer<_$AppDatabase, $NexusProvidersTable> {
  $$NexusProvidersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxTokens => $composableBuilder(
      column: $table.maxTokens, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get temperature => $composableBuilder(
      column: $table.temperature, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$NexusProvidersTableOrderingComposer
    extends Composer<_$AppDatabase, $NexusProvidersTable> {
  $$NexusProvidersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxTokens => $composableBuilder(
      column: $table.maxTokens, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get temperature => $composableBuilder(
      column: $table.temperature, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NexusProvidersTableAnnotationComposer
    extends Composer<_$AppDatabase, $NexusProvidersTable> {
  $$NexusProvidersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get apiKey =>
      $composableBuilder(column: $table.apiKey, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get maxTokens =>
      $composableBuilder(column: $table.maxTokens, builder: (column) => column);

  GeneratedColumn<double> get temperature => $composableBuilder(
      column: $table.temperature, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NexusProvidersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NexusProvidersTable,
    NexusProvider,
    $$NexusProvidersTableFilterComposer,
    $$NexusProvidersTableOrderingComposer,
    $$NexusProvidersTableAnnotationComposer,
    $$NexusProvidersTableCreateCompanionBuilder,
    $$NexusProvidersTableUpdateCompanionBuilder,
    (
      NexusProvider,
      BaseReferences<_$AppDatabase, $NexusProvidersTable, NexusProvider>
    ),
    NexusProvider,
    PrefetchHooks Function()> {
  $$NexusProvidersTableTableManager(
      _$AppDatabase db, $NexusProvidersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NexusProvidersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NexusProvidersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NexusProvidersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String> baseUrl = const Value.absent(),
            Value<String> apiKey = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int> maxTokens = const Value.absent(),
            Value<double> temperature = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              NexusProvidersCompanion(
            id: id,
            name: name,
            label: label,
            baseUrl: baseUrl,
            apiKey: apiKey,
            model: model,
            enabled: enabled,
            isDefault: isDefault,
            maxTokens: maxTokens,
            temperature: temperature,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String label,
            required String baseUrl,
            Value<String> apiKey = const Value.absent(),
            required String model,
            Value<bool> enabled = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int> maxTokens = const Value.absent(),
            Value<double> temperature = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              NexusProvidersCompanion.insert(
            id: id,
            name: name,
            label: label,
            baseUrl: baseUrl,
            apiKey: apiKey,
            model: model,
            enabled: enabled,
            isDefault: isDefault,
            maxTokens: maxTokens,
            temperature: temperature,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NexusProvidersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NexusProvidersTable,
    NexusProvider,
    $$NexusProvidersTableFilterComposer,
    $$NexusProvidersTableOrderingComposer,
    $$NexusProvidersTableAnnotationComposer,
    $$NexusProvidersTableCreateCompanionBuilder,
    $$NexusProvidersTableUpdateCompanionBuilder,
    (
      NexusProvider,
      BaseReferences<_$AppDatabase, $NexusProvidersTable, NexusProvider>
    ),
    NexusProvider,
    PrefetchHooks Function()>;
typedef $$NexusConversationsTableCreateCompanionBuilder
    = NexusConversationsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> repoPath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$NexusConversationsTableUpdateCompanionBuilder
    = NexusConversationsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> repoPath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$NexusConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $NexusConversationsTable> {
  $$NexusConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repoPath => $composableBuilder(
      column: $table.repoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$NexusConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NexusConversationsTable> {
  $$NexusConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repoPath => $composableBuilder(
      column: $table.repoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NexusConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NexusConversationsTable> {
  $$NexusConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get repoPath =>
      $composableBuilder(column: $table.repoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NexusConversationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NexusConversationsTable,
    NexusConversation,
    $$NexusConversationsTableFilterComposer,
    $$NexusConversationsTableOrderingComposer,
    $$NexusConversationsTableAnnotationComposer,
    $$NexusConversationsTableCreateCompanionBuilder,
    $$NexusConversationsTableUpdateCompanionBuilder,
    (
      NexusConversation,
      BaseReferences<_$AppDatabase, $NexusConversationsTable, NexusConversation>
    ),
    NexusConversation,
    PrefetchHooks Function()> {
  $$NexusConversationsTableTableManager(
      _$AppDatabase db, $NexusConversationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NexusConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NexusConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NexusConversationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> repoPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              NexusConversationsCompanion(
            id: id,
            title: title,
            repoPath: repoPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> repoPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              NexusConversationsCompanion.insert(
            id: id,
            title: title,
            repoPath: repoPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NexusConversationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NexusConversationsTable,
    NexusConversation,
    $$NexusConversationsTableFilterComposer,
    $$NexusConversationsTableOrderingComposer,
    $$NexusConversationsTableAnnotationComposer,
    $$NexusConversationsTableCreateCompanionBuilder,
    $$NexusConversationsTableUpdateCompanionBuilder,
    (
      NexusConversation,
      BaseReferences<_$AppDatabase, $NexusConversationsTable, NexusConversation>
    ),
    NexusConversation,
    PrefetchHooks Function()>;
typedef $$NexusMessagesTableCreateCompanionBuilder = NexusMessagesCompanion
    Function({
  Value<int> id,
  required int convId,
  required String role,
  required String content,
  Value<DateTime> createdAt,
});
typedef $$NexusMessagesTableUpdateCompanionBuilder = NexusMessagesCompanion
    Function({
  Value<int> id,
  Value<int> convId,
  Value<String> role,
  Value<String> content,
  Value<DateTime> createdAt,
});

class $$NexusMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $NexusMessagesTable> {
  $$NexusMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get convId => $composableBuilder(
      column: $table.convId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$NexusMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $NexusMessagesTable> {
  $$NexusMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get convId => $composableBuilder(
      column: $table.convId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$NexusMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NexusMessagesTable> {
  $$NexusMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get convId =>
      $composableBuilder(column: $table.convId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NexusMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NexusMessagesTable,
    NexusMessage,
    $$NexusMessagesTableFilterComposer,
    $$NexusMessagesTableOrderingComposer,
    $$NexusMessagesTableAnnotationComposer,
    $$NexusMessagesTableCreateCompanionBuilder,
    $$NexusMessagesTableUpdateCompanionBuilder,
    (
      NexusMessage,
      BaseReferences<_$AppDatabase, $NexusMessagesTable, NexusMessage>
    ),
    NexusMessage,
    PrefetchHooks Function()> {
  $$NexusMessagesTableTableManager(_$AppDatabase db, $NexusMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NexusMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NexusMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NexusMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> convId = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              NexusMessagesCompanion(
            id: id,
            convId: convId,
            role: role,
            content: content,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int convId,
            required String role,
            required String content,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              NexusMessagesCompanion.insert(
            id: id,
            convId: convId,
            role: role,
            content: content,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NexusMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NexusMessagesTable,
    NexusMessage,
    $$NexusMessagesTableFilterComposer,
    $$NexusMessagesTableOrderingComposer,
    $$NexusMessagesTableAnnotationComposer,
    $$NexusMessagesTableCreateCompanionBuilder,
    $$NexusMessagesTableUpdateCompanionBuilder,
    (
      NexusMessage,
      BaseReferences<_$AppDatabase, $NexusMessagesTable, NexusMessage>
    ),
    NexusMessage,
    PrefetchHooks Function()>;
typedef $$AgentMemoriesTableCreateCompanionBuilder = AgentMemoriesCompanion
    Function({
  Value<int> id,
  required String key,
  required String value,
  Value<DateTime> createdAt,
});
typedef $$AgentMemoriesTableUpdateCompanionBuilder = AgentMemoriesCompanion
    Function({
  Value<int> id,
  Value<String> key,
  Value<String> value,
  Value<DateTime> createdAt,
});

class $$AgentMemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $AgentMemoriesTable> {
  $$AgentMemoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AgentMemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AgentMemoriesTable> {
  $$AgentMemoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AgentMemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AgentMemoriesTable> {
  $$AgentMemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AgentMemoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AgentMemoriesTable,
    AgentMemory,
    $$AgentMemoriesTableFilterComposer,
    $$AgentMemoriesTableOrderingComposer,
    $$AgentMemoriesTableAnnotationComposer,
    $$AgentMemoriesTableCreateCompanionBuilder,
    $$AgentMemoriesTableUpdateCompanionBuilder,
    (
      AgentMemory,
      BaseReferences<_$AppDatabase, $AgentMemoriesTable, AgentMemory>
    ),
    AgentMemory,
    PrefetchHooks Function()> {
  $$AgentMemoriesTableTableManager(_$AppDatabase db, $AgentMemoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgentMemoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgentMemoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgentMemoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AgentMemoriesCompanion(
            id: id,
            key: key,
            value: value,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            required String value,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AgentMemoriesCompanion.insert(
            id: id,
            key: key,
            value: value,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AgentMemoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AgentMemoriesTable,
    AgentMemory,
    $$AgentMemoriesTableFilterComposer,
    $$AgentMemoriesTableOrderingComposer,
    $$AgentMemoriesTableAnnotationComposer,
    $$AgentMemoriesTableCreateCompanionBuilder,
    $$AgentMemoriesTableUpdateCompanionBuilder,
    (
      AgentMemory,
      BaseReferences<_$AppDatabase, $AgentMemoriesTable, AgentMemory>
    ),
    AgentMemory,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReposTableTableManager get repos =>
      $$ReposTableTableManager(_db, _db.repos);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db, _db.snippets);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$RepoFeaturesTableTableManager get repoFeatures =>
      $$RepoFeaturesTableTableManager(_db, _db.repoFeatures);
  $$NexusProvidersTableTableManager get nexusProviders =>
      $$NexusProvidersTableTableManager(_db, _db.nexusProviders);
  $$NexusConversationsTableTableManager get nexusConversations =>
      $$NexusConversationsTableTableManager(_db, _db.nexusConversations);
  $$NexusMessagesTableTableManager get nexusMessages =>
      $$NexusMessagesTableTableManager(_db, _db.nexusMessages);
  $$AgentMemoriesTableTableManager get agentMemories =>
      $$AgentMemoriesTableTableManager(_db, _db.agentMemories);
}
