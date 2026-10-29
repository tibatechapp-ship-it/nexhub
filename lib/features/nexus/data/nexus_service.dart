import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../shared/data/database.dart';

class NexusService {
  NexusService(this.provider);
  final NexusProvider provider;

  Future<String> complete({
    required String prefix,
    required String suffix,
    required String language,
    required String fileName,
  }) async {
    final system = _systemPrompt(language, fileName);
    final user = '''
السياق قبل المؤشر:
```

$prefix

```
السياق بعد المؤشر:
```

$suffix

```

أكمل الكود من موضع المؤشر. أعد فقط الأسطر الجديدة (بدون شرح، بدون Markdown fences، بدون تكرار البادئة).''';

    return _chat(system: system, user: user);
  }

  Future<String> explain({
    required String code,
    required String fileName,
  }) {
    return _chat(
      system: 'أنت مساعد برمجة عربي. اشرح الكود بإيجاز، مع الأخطاء '
          'المحتملة والتحسينات.',
      user: 'الملف: $fileName\n\n```\n$code\n```',
    );
  }

  Future<String> _chat({
    required String system,
    required String user,
  }) async {
    final uri = Uri.parse(
      '${provider.baseUrl.replaceAll(RegExp(r'/$'), '')}/chat/completions',
    );
    final body = jsonEncode({
      'model': provider.model,
      'messages': [
        {'role': 'system', 'content': system},
        {'role': 'user', 'content': user},
      ],
      'temperature': provider.temperature,
      'max_tokens': provider.maxTokens,
      'stream': false,
    });

    final r = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            if (provider.apiKey.isNotEmpty)
              'Authorization': 'Bearer ${provider.apiKey}',
          },
          body: body,
        )
        .timeout(const Duration(seconds: 45));

    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Nexus ${r.statusCode}: ${r.body}');
    }
    final data = jsonDecode(r.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('Nexus: استجابة فارغة');
    }
    final msg = choices.first['message'] as Map<String, dynamic>?;
    return (msg?['content'] as String?)?.trim() ?? '';
  }

  String _systemPrompt(String language, String fileName) {
    return 'أنت مساعد إكمال كود دقيق. اللغة: $language. الملف: $fileName. '
        'أعد فقط الكود المُكمل من موضع المؤشر — بدون شرح، بدون Markdown، '
        'بدون إعادة كتابة ما قبله. حافظ على نمط الكود والمسافات.';
  }
}