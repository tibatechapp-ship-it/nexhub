import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:nexhub/features/git/data/git_service.dart';

void main() {
  late Directory tmp;
  late GitService git;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('nexhub_git_test_');
    // init a repo with one commit
    await Process.run('git', ['init'], workingDirectory: tmp.path);
    await Process.run('git', ['config', 'user.email', 't@t.com'],
        workingDirectory: tmp.path);
    await Process.run('git', ['config', 'user.name', 't'],
        workingDirectory: tmp.path);
    File('${tmp.path}/a.txt').writeAsStringSync('hello');
    await Process.run('git', ['add', '.'], workingDirectory: tmp.path);
    await Process.run('git', ['commit', '-m', 'first'],
        workingDirectory: tmp.path);
    git = GitService(tmp.path);
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  test('isRepo returns true for git repo', () async {
    expect(await git.isRepo(), isTrue);
  });

  test('currentBranch returns a branch name', () async {
    final b = await git.currentBranch();
    expect(b, isNotNull);
    expect(b, isNotEmpty);
  });

  test('log returns commits', () async {
    final commits = await git.log(limit: 5);
    expect(commits, isNotEmpty);
    expect(commits.first.subject, 'first');
  });

  test('commitDiff returns diff for a commit', () async {
    final commits = await git.log(limit: 1);
    final diff = await git.commitDiff(commits.first.hash);
    expect(diff, contains('a.txt'));
  });

  test('log with limit respects limit', () async {
    // add second commit
    File('${tmp.path}/b.txt').writeAsStringSync('world');
    await Process.run('git', ['add', '.'], workingDirectory: tmp.path);
    await Process.run('git', ['commit', '-m', 'second'],
        workingDirectory: tmp.path);
    final commits = await git.log(limit: 1);
    expect(commits.length, 1);
  });
}
