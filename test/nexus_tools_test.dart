import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:nexhub/features/nexus/agent/nexus_tools.dart';
import 'package:nexhub/features/git/data/git_service.dart';

void main() {
  late Directory tempRepo;
  late String repoPath;

  setUp(() async {
    tempRepo = await Directory.systemTemp.createTemp('nexhub_n1_test_');
    repoPath = tempRepo.path;
    await File('$repoPath/allowed.txt').writeAsString('hello');
    await Directory('$repoPath/sub').create();
    await File('$repoPath/sub/nested.txt').writeAsString('nested');
  });

  tearDown(() async {
    await tempRepo.delete(recursive: true);
  });

  group('N1: path traversal rejection (safePath)', () {
    test('rejects ../ traversal', () {
      expect(safePath(repoPath, '../etc/passwd'), isNull);
    });

    test('rejects absolute path', () {
      expect(safePath(repoPath, '/etc/passwd'), isNull);
    });

    test('rejects multiple traversal', () {
      expect(safePath(repoPath, '../../../../etc/passwd'), isNull);
    });

    test('rejects windows separator traversal', () {
      expect(safePath(repoPath, '..\\..\\etc\\passwd'), isNull);
    });

    test('rejects empty path', () {
      expect(safePath(repoPath, ''), isNull);
    });

    test('allows in-repo file', () {
      expect(safePath(repoPath, 'allowed.txt'), isNotNull);
    });

    test('allows nested in-repo file', () {
      expect(safePath(repoPath, 'sub/nested.txt'), isNotNull);
    });
  });

  group('N1: path traversal rejection (read_file tool)', () {
    test('read_file rejects ../ traversal', () async {
      final tools = buildNexusTools(repoPath: repoPath, git: GitService(repoPath));
      final readTool = tools.firstWhere((t) => t.name == 'read_file');
      final result = await readTool.execute({'file_path': '../etc/passwd'});
      expect(result, contains('Access denied'));
    });

    test('read_file rejects absolute path', () async {
      final tools = buildNexusTools(repoPath: repoPath, git: GitService(repoPath));
      final readTool = tools.firstWhere((t) => t.name == 'read_file');
      final result = await readTool.execute({'file_path': '/etc/passwd'});
      expect(result, contains('Access denied'));
    });

    test('read_file allows in-repo file', () async {
      final tools = buildNexusTools(repoPath: repoPath, git: GitService(repoPath));
      final readTool = tools.firstWhere((t) => t.name == 'read_file');
      final result = await readTool.execute({'file_path': 'allowed.txt'});
      expect(result, equals('hello'));
    });
  });

  group('N1: path traversal rejection (list_files tool)', () {
    test('list_files rejects ../ traversal', () async {
      final tools = buildNexusTools(repoPath: repoPath, git: GitService(repoPath));
      final listTool = tools.firstWhere((t) => t.name == 'list_files');
      final result = await listTool.execute({'dir_path': '../'});
      expect(result, contains('Access denied'));
    });

    test('list_files allows in-repo directory', () async {
      final tools = buildNexusTools(repoPath: repoPath, git: GitService(repoPath));
      final listTool = tools.firstWhere((t) => t.name == 'list_files');
      final result = await listTool.execute({'dir_path': 'sub'});
      expect(result, contains('nested.txt'));
    });
  });

  group('N1: path traversal rejection (apply_patch tool)', () {
    test('apply_patch rejects ../ traversal', () async {
      final tools = buildNexusTools(repoPath: repoPath, git: GitService(repoPath));
      final patchTool = tools.firstWhere((t) => t.name == 'apply_patch');
      final result = await patchTool.execute({
        'file_path': '../evil.txt',
        'new_content': 'pwned',
        'summary': 'test',
      });
      expect(result, contains('Access denied'));
    });

    test('apply_patch allows in-repo file', () async {
      final tools = buildNexusTools(repoPath: repoPath, git: GitService(repoPath));
      final patchTool = tools.firstWhere((t) => t.name == 'apply_patch');
      final result = await patchTool.execute({
        'file_path': 'new_file.txt',
        'new_content': 'safe content',
        'summary': 'test',
      });
      expect(result, contains('Created'));
      expect(File('$repoPath/new_file.txt').readAsStringSync(), 'safe content');
    });
  });
}
