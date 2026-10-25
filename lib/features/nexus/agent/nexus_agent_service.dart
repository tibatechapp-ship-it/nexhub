import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../shared/data/database.dart';
import '../../git/data/git_service.dart';
import 'nexus_tools.dart';

/// Callback for agent progress updates (tool calls, thinking, etc.)
typedef AgentProgressCallback = void Function(String status);

/// The Nexus Agent: an agentic loop that uses tools to answer questions.
class NexusAgentService {
  NexusAgentService({
    required this.provider,
    required this.repoPath,
    required this.git,
  });

  final NexusProvider provider;
  final String repoPath;
  final GitService git;

  List<NexusTool> get _tools => buildNexusTools(repoPath: repoPath, git: git);

  /// Run the agent loop. Returns the final text response.
  /// [onProgress] is called with status messages for the UI.
  Future<String> run({
    required String userMessage,
    required List<({String role, String content})> history,
    AgentProgressCallback? onProgress,
  }) async {
    onProgress?.call('🤔 يفكر...');

    final tools = _tools;
    final toolMap = {for (final t in tools) t.name: t};

    // Build OpenAI-format messages
    final messages = <Map<String, dynamic>>[
      {
        'role': 'system',
        'content': _systemPrompt(),
      },
      ...history.map((m) => {'role': m.role, 'content': m.content}),
      {'role': 'user', 'content': userMessage},
    ];

    // Agent loop: max 5 iterations to prevent infinite loops
    for (var iteration = 0; iteration < 5; iteration++) {
      final response = await _chat(messages, tools);
      final choice = response['choices']?[0];
      final message = choice?['message'] as Map<String, dynamic>?;
      if (message == null) {
        return '⚠️ استجابة فارغة من الـ AI.';
      }

      final toolCalls = message['tool_calls'] as List<dynamic>?;
      if (toolCalls == null || toolCalls.isEmpty) {
        // Final answer
        final content = message['content'] as String? ?? '';
        return content.trim();
      }

      // Execute tool calls
      messages.add(message);

      for (final tc in toolCalls) {
        final fn = tc['function'] as Map<String, dynamic>;
        final name = fn['name'] as String;
        final argsStr = fn['arguments'] as String? ?? '{}';
        Map<String, dynamic> args;
        try {
          args = jsonDecode(argsStr) as Map<String, dynamic>;
        } catch (_) {
          args = {};
        }

        onProgress?.call('🔧 ${_toolLabel(name)}...');

        final tool = toolMap[name];
        String result;
        if (tool == null) {
          result = 'Tool not found: $name';
        } else {
          try {
            result = await tool.execute(args);
          } catch (e) {
            result = 'Error executing $name: $e';
          }
        }

        messages.add({
          'role': 'tool',
          'tool_call_id': tc['id'],
          'content': result,
        });
      }

      onProgress?.call('🤔 يحلل النتائج...');
    }

    return '⚠️ تجاوز الحد الأقصى من التكرارات.';
  }

  Future<Map<String, dynamic>> _chat(
    List<Map<String, dynamic>> messages,
    List<NexusTool> tools,
  ) async {
    final uri = Uri.parse(
      '${provider.baseUrl.replaceAll(RegExp(r'/$'), '')}/chat/completions',
    );
    final body = jsonEncode({
      'model': provider.model,
      'messages': messages,
      'tools': tools.map((t) => t.toJson()).toList(),
      'tool_choice': 'auto',
      'temperature': provider.temperature,
      'max_tokens': provider.maxTokens,
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
        .timeout(const Duration(seconds: 60));

    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Nexus ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  String _systemPrompt() {
    return 'أنت Nexus Agent، مساعد برمجة ذكي يعمل داخل تطبيق Git. '
        'لديك أدوات للوصول إلى المستودع (commits, diffs, files). '
        'استخدم الأدوات عندما تحتاج معلومات من المستودع. '
        'أجب بالعربية. استخدم Markdown. '
        'كن موجزاً ومفيداً.';
  }

  String _toolLabel(String name) {
    switch (name) {
      case 'get_recent_commits':
        return 'جلب آخر Commits';
      case 'get_commit_diff':
        return 'قراءة Diff';
      case 'read_file':
        return 'قراءة ملف';
      case 'list_files':
        return 'سرد الملفات';
      default:
        return name;
    }
  }
}