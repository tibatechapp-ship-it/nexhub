import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ai/data/ai_settings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final ai = ref.watch(aiConfigProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.navSettings)),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              ai.isConfigured ? Icons.check_circle : Icons.error_outline,
              color: ai.isConfigured ? Colors.green : Colors.orange,
            ),
            title: const Text('إعدادات AI'),
            subtitle: Text(
              ai.isConfigured
                  ? '${ai.model} @ ${ai.baseUrl}'
                  : 'غير مهيأ — اضبط المفتاح والرابط',
            ),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => _editAi(context, ref, ai),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('حول'),
            subtitle: Text('NexHub 0.1.0'),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'NexHub منصة git محلية. لا بياناتك ولا مستودعاتك تُرسل لأي مكان '
              'إلا إذا فعّلت AI وأرسلت كوداً يدوياً.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editAi(
    BuildContext context,
    WidgetRef ref,
    AiConfig current,
  ) async {
    final keyCtrl = TextEditingController(text: current.apiKey);
    final baseCtrl = TextEditingController(text: current.baseUrl);
    final modelCtrl = TextEditingController(text: current.model);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعدادات AI'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: baseCtrl,
                decoration: const InputDecoration(
                  labelText: 'Base URL (مثل https://api.openai.com/v1)',
                  border: OutlineInputBorder(),
                ),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: modelCtrl,
                decoration: const InputDecoration(
                  labelText: 'Model (مثل gpt-4o-mini أو llama3)',
                  border: OutlineInputBorder(),
                ),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: keyCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'API Key (اتركه فارغاً للنموذج المحلي)',
                  border: OutlineInputBorder(),
                ),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (saved != true) return;
    await ref.read(aiConfigProvider.notifier).save(
          current.copyWith(
            apiKey: keyCtrl.text.trim(),
            baseUrl: baseCtrl.text.trim(),
            model: modelCtrl.text.trim(),
          ),
        );
  }
}