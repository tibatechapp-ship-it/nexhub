import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../ai/data/ai_settings.dart';

/// أيقونة سهم متوافقة مع الاتجاه الحالي — بدل chevron_left الثابت
/// الذي كان يفترض RTL دائماً (تدقيق UX §5.2).
Widget directionAwareChevron(BuildContext context) => Icon(
      Directionality.of(context) == TextDirection.rtl
          ? Icons.chevron_left
          : Icons.chevron_right,
    );

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
              // UX audit: ألوان حالة من الثيم بدل Colors.green/orange الصلبة
              // (الأخضر الصلب ≈ 2.1:1 على السطح الفاتح — §5.2).
              color: ai.isConfigured
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
            ),
            title: const Text('إعدادات AI'),
            subtitle: Text(
              ai.isConfigured
                  ? '${ai.model} @ ${ai.baseUrl}'
                  : 'غير مهيأ — اضبط المفتاح والرابط',
            ),
            trailing: directionAwareChevron(context),
            onTap: () => _editAi(context, ref, ai),
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('Nexus AI (مزودات)'),
            subtitle: const Text('DeepSeek, Qwen, MiniMax, Z.ai, مخصص'),
            trailing: directionAwareChevron(context),
            onTap: () => context.push('/nexus'),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.language),
            subtitle: Text(l.languageDesc),
            trailing: directionAwareChevron(context),
            onTap: () => _pickLanguage(context, ref),
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

  /// UX audit (المرحلة 3): مبدّل لغة يحفظ الاختيار عبر appLocaleProvider.
  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final current = ref.read(appLocaleProvider).code;
    final chosen = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.language),
        children: [
          RadioGroup<String>(
            groupValue: current,
            onChanged: (v) => Navigator.pop(ctx, v),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'ar',
                  title: Text(l.langArabic),
                ),
                RadioListTile<String>(
                  value: 'en',
                  title: Text(l.langEnglish),
                ),
                RadioListTile<String>(
                  value: 'system',
                  title: Text(l.langSystem),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (chosen == null || chosen == current) return;
    await ref.read(appLocaleProvider.notifier).setLocale(chosen);
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
