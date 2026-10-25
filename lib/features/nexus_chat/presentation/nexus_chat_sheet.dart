import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';
import '../data/nexus_chat_repository.dart';
import '../data/nexus_chat_service.dart';

class NexusChatSheet extends ConsumerStatefulWidget {
  const NexusChatSheet({super.key, this.repoPath, this.initialContext});
  final String? repoPath;
  final String? initialContext;

  @override
  ConsumerState<NexusChatSheet> createState() => _NexusChatSheetState();
}

class _NexusChatSheetState extends ConsumerState<NexusChatSheet> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  int? _convId;
  bool _streaming = false;
  String _streamBuf = '';

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _ensureConv() async {
    if (_convId != null) return;
    final repo = ref.read(nexusChatRepositoryProvider);
    _convId = await repo.newConversation(
      title: widget.initialContext != null
          ? 'سياق: ${widget.initialContext!.split('/').last}'
          : null,
      repoPath: widget.repoPath,
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _streaming) return;
    await _ensureConv();
    final repo = ref.read(nexusChatRepositoryProvider);
    await repo.addMessage(convId: _convId!, role: 'user', content: text);
    _controller.clear();
    _streaming = true;
    _streamBuf = '';
    setState(() {});

    final service = ref.read(nexusChatServiceProvider);
    if (service == null) {
      await repo.addMessage(
        convId: _convId!,
        role: 'assistant',
        content: '⚠️ لا يوجد Nexus Provider مُفعَّل. افتح الإعدادات.',
      );
      _streaming = false;
      setState(() {});
      return;
    }

    final msgs = ref.read(nexusMessagesProvider(_convId!)).valueOrNull ?? [];
    final history = msgs
        .map((m) => (role: m.role, content: m.content))
        .toList();

    String systemPrompt = service.defaultSystemPrompt();
    if (widget.initialContext != null) {
      systemPrompt +=
          '\n\nالسياق (ملف ${widget.initialContext}): '
          'أجب بمراعاة هذا الملف.';
    }

    try {
      await for (final chunk in service.streamReply(
        history: history,
        systemPrompt: systemPrompt,
      )) {
        _streamBuf += chunk;
        if (mounted) setState(() {});
        _scrollToBottom();
      }
    } catch (e) {
      _streamBuf += '\n\n⚠️ خطأ: $e';
    }

    if (_streamBuf.isNotEmpty) {
      await repo.addMessage(
        convId: _convId!,
        role: 'assistant',
        content: _streamBuf.trim(),
      );
    }
    _streaming = false;
    _streamBuf = '';
    if (mounted) setState(() {});
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final msgs = _convId == null
        ? <NexusMessage>[]
        : (ref.watch(nexusMessagesProvider(_convId!)).valueOrNull ?? []);

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.92,
        child: Column(
          children: [
            _Header(
              title: 'Nexus Chat',
              onNew: () async {
                final repo = ref.read(nexusChatRepositoryProvider);
                _convId = await repo.newConversation(repoPath: widget.repoPath);
                setState(() {});
              },
            ),
            Expanded(
              child: ListView(
                controller: _scroll,
                padding: const EdgeInsets.all(12),
                children: [
                  for (final m in msgs) _MessageBubble(m: m),
                  if (_streaming && _streamBuf.isNotEmpty)
                    _MessageBubble(
                      m: NexusMessage(
                        id: -1,
                        convId: _convId ?? 0,
                        role: 'assistant',
                        content: _streamBuf,
                        createdAt: DateTime.now(),
                      ),
                      isStreaming: true,
                    ),
                  if (_streaming && _streamBuf.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('يفكر...'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            _QuickActions(onTap: (q) {
              _controller.text = q;
              _send();
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        hintText: 'اسأل Nexus...',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _streaming ? null : _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onNew});
  final String title;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
      child: Row(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: 'محادثة جديدة',
            onPressed: onNew,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.m, this.isStreaming = false});
  final NexusMessage m;
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    final isUser = m.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SelectableText(
          m.content,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onTap});
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    const actions = [
      'شرح هذا الكود',
      'اكتب اختبارات',
      'اقترح تحسينات',
      'اشرح آخر commit',
      'أصلح الخطأ',
    ];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) => ActionChip(
          label: Text(actions[i], style: const TextStyle(fontSize: 12)),
          onPressed: () => onTap(actions[i]),
        ),
      ),
    );
  }
}