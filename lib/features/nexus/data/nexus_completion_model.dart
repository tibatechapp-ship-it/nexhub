import 'package:code_forge/code_forge.dart';

import '../../../shared/data/database.dart';

Models buildNexusCompletionModel(NexusProvider provider) {
  return CustomModel(
    url: '${provider.baseUrl.replaceAll(RegExp(r'/$'), '')}/chat/completions',
    customHeaders: {
      'Content-Type': 'application/json',
      if (provider.apiKey.isNotEmpty)
        'Authorization': 'Bearer ${provider.apiKey}',
    },
    requestBuilder: (code, instruction) {
      return {
        'model': provider.model,
        'temperature': provider.temperature,
        'max_tokens': provider.maxTokens.clamp(64, 1024),
        'messages': [
          {'role': 'system', 'content': instruction},
          {'role': 'user', 'content': code},
        ],
      };
    },
    customParser: (response) {
      final choices = response['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) return '';
      final msg = choices.first['message'] as Map<String, dynamic>?;
      return (msg?['content'] as String?) ?? '';
    },
  );
}