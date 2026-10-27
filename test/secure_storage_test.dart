import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:nexhub/features/github/data/github_settings.dart';

@GenerateMocks([FlutterSecureStorage])
import 'secure_storage_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('N2: GitHub token stored in secure storage', () {
    test('saveToken writes to secure storage', () async {
      final mock = MockFlutterSecureStorage();
      when(mock.write(key: 'github_token', value: 'secret123'))
          .thenAnswer((_) async {});

      final settings = GithubSettings(storage: mock);
      await settings.saveToken('secret123');

      verify(mock.write(key: 'github_token', value: 'secret123')).called(1);
    });

    test('getToken reads from secure storage', () async {
      final mock = MockFlutterSecureStorage();
      when(mock.read(key: 'github_token'))
          .thenAnswer((_) async => 'secret123');

      final settings = GithubSettings(storage: mock);
      expect(await settings.getToken(), equals('secret123'));
    });

    test('removeToken deletes from secure storage', () async {
      final mock = MockFlutterSecureStorage();
      when(mock.delete(key: 'github_token')).thenAnswer((_) async {});

      final settings = GithubSettings(storage: mock);
      await settings.removeToken();

      verify(mock.delete(key: 'github_token')).called(1);
    });
  });
}
