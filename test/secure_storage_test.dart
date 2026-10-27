import 'package:flutter_test/flutter_test.dart';

import 'package:nexhub/features/github/data/github_settings.dart';

/// In-memory fake of TokenStorage for hermetic tests.
class _FakeTokenStorage implements TokenStorage {
  final Map<String, String> _store = {};

  @override
  Future<void> write({required String key, required String? value}) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }

  @override
  Future<String?> read({required String key}) async => _store[key];

  @override
  Future<void> delete({required String key}) async => _store.remove(key);
}

void main() {
  group('N2: GitHub token stored in secure storage', () {
    test('saveToken writes to storage', () async {
      final fake = _FakeTokenStorage();
      final settings = GithubSettings(storage: fake);
      await settings.saveToken('secret123');
      expect(await fake.read(key: 'github_token'), equals('secret123'));
    });

    test('getToken reads from storage', () async {
      final fake = _FakeTokenStorage();
      await fake.write(key: 'github_token', value: 'secret123');
      final settings = GithubSettings(storage: fake);
      expect(await settings.getToken(), equals('secret123'));
    });

    test('removeToken deletes from storage', () async {
      final fake = _FakeTokenStorage();
      await fake.write(key: 'github_token', value: 'secret123');
      final settings = GithubSettings(storage: fake);
      await settings.removeToken();
      expect(await fake.read(key: 'github_token'), isNull);
    });

    test('getToken returns null when no token stored', () async {
      final fake = _FakeTokenStorage();
      final settings = GithubSettings(storage: fake);
      expect(await settings.getToken(), isNull);
    });
  });
}
