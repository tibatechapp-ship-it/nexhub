import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../shared/data/database.dart';
import '../../nexus/data/nexus_providers_repository.dart';

class NexusChatService {
  NexusChatService(this._provider);
  final NexusProvider _provider;

  Stream<String> streamReply({
    required List<({String role, String content})> history,
    required String systemPrompt,
  }) async* {
    final uri = Uri.parse(
      '${_provider.baseUrl.replaceAll(RegExp(r'/$'), '')}/chat/completions',
    );
    final body = jsonEncode({
      'model': _provider.model,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...history.map((m) => {'role': m.role, 'content': m.content}),
      ],
      'temperature': _provider.temperature,
      'max_tokens': _provider.maxTokens,
      'stream': true,
    });

    final request = http.Request('POST', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        if (_provider.apiKey.isNotEmpty)
          'Authorization': 'Bearer ${_provider.apiKey}',
      })
      ..body = body;

    final client = http.Client();
    try {
      final response = await client.send(request);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Nexus ${response.statusCode}');
      }
      final lines = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      await for (final line in lines) {
        if (!line.startsWith('data: ')) continue;
        final payload = line.substring(6).trim();
        if (payload == '[DONE]') break;
        try {
          final obj = jsonDecode(payload) as Map<String, dynamic>;
          final choices = obj['choices'] as List<dynamic>?;
          if (choices == null || choices.isEmpty) continue;
          final delta = choices.first['delta'] as Map<String, dynamic>?;
          final content = delta?['content'] as String?;
          if (content != null && content.isNotEmpty) {
            yield content;
          }
        } catch (_) {
          // skip malformed chunks
        }
      }
    } finally {
      client.close();
    }
  }

  String defaultSystemPrompt() {
    return 'أنت Nexus، مساعد برمجة عربي (مثل ChatGPT/Claude). '
        'أجب بالعربية (أو باللغة التي كتب بها المستخدم). '
        'استخدم Markdown (عناوين، قوائم، كتل كود مع ```). '
        'كن دقيقًا ومفيدًا.';
  }
}

final nexusChatServiceProvider = Provider<NexusChatService?>((ref) {
  final prov = ref.watch(nexusDefaultProvider).valueOrNull;
  if (prov == null || !prov.enabled) return null;
  return NexusChatService(prov);
});