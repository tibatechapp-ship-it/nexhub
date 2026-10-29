import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../data/ai_service.dart';
import '../data/ai_settings.dart';

class ExplainSheet extends ConsumerStatefulWidget {
  const ExplainSheet({
    required this.code,
    required this.fileName,
    super.key,
  });
  final String code;
  final String fileName;

  static Future<void> show(
    BuildContext context, {
    required String code,
    required String fileName,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ExplainSheet(code: code, fileName: fileName),
    );
  }

  @override
  ConsumerState<ExplainSheet> createState() => _ExplainSheetState();
}

class _ExplainSheetState extends ConsumerState<ExplainSheet> {
  String? _result;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    final cfg = ref.read(aiConfigProvider);
    if (!cfg.isConfigured) {
      setState(() => _error = 'اضبط إعدادات AI من صفحة الإعدادات.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final service = AiService(cfg);
      final result = await service.complete(
        system: 'أنت مساعد برمجة عربي. اشرح الكود التالي بالعربية الفصحى '
            'بعبارات موجزة، مقسماً إلى: الهدف، المنطق الأساسي، أي ملاحظات.',
        user: 'الملف: ${widget.fileName}\n\n```\n${widget.code}\n```',
      );
      if (mounted) setState(() => _result = result);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (_, scroll) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.smart_toy_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'اشرح: ${widget.fileName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (_result != null)
                    IconButton(
                      tooltip: 'نسخ النتيجة',
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _result!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم النسخ')),
                        );
                      },
                    ),
                  IconButton(
                    tooltip: 'إعادة التوليد',
                    icon: const Icon(Icons.refresh),
                    onPressed: _loading ? null : _run,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              _error!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Markdown(
                          data: _result ?? '',
                          padding: const EdgeInsets.all(16),
                          selectable: true,
                        ),
            ),
          ],
        );
      },
    );
  }
}