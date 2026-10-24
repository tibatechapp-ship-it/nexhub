import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ai_settings.dart';

class AiService {
  AiService(this.config);
  final AiConfig config;

  Future<String> complete({
    required String system,
    required String user,
  }) async {
    final uri = Uri.parse(
        '${config.baseUrl.replaceAll(RegExp(r'/$'), '')}/chat/completions');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (config.apiKey.isNotEmpty) 'Authorization': 'Bearer ${config.apiKey}',
    };
    final body = jsonEncode({
      'model': config.model,
      'messages': [
        {'role': 'system', 'content': system},
        {'role': 'user', 'content': user},
      ],
      'temperature': 0.3,
    });

    final r = await http
        .post(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: 60));
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('AI ${r.statusCode}: ${r.body}');
    }
    final data = jsonDecode(r.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('AI: empty response');
    }
    final msg = choices.first['message'] as Map<String, dynamic>?;
    return (msg?['content'] as String?)?.trim() ?? '';
  }
}