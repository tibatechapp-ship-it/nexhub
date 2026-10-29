import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../git/data/git_service.dart';
import '../../../shared/data/database.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../nexus/data/nexus_providers_repository.dart';
import '../data/nexus_chat_repository.dart';
import '../../nexus/agent/nexus_agent_service.dart';
import '../data/nexus_chat_service.dart';

class NexusChatSheet extends ConsumerStatefulWidget {
  const NexusChatSheet({super.key, this.repoPath, this.initialContext, this.initialMessage});
  final String? repoPath;
  final String? initialContext;
  final String? initialMessage;

  @override
  ConsumerState<NexusChatSheet> createState() => _NexusChatSheetState();
}

class _NexusChatSheetState extends ConsumerState<NexusChatSheet> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  int? _convId;
  bool _streaming = false;
  String _streamBuf = '';
  String _progress = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.initialMessage!;
        _send();
      });
    }
  }

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
    _progress = '';
    setState(() {});

    final provider = ref.read(nexusDefaultProvider).valueOrNull;
    if (provider == null || !provider.enabled) {
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

    // Agent mode when repoPath is available
    if (widget.repoPath != null) {
      final git = GitService(widget.repoPath!);
      final db = ref.read(appDatabaseProvider);
      final agent = NexusAgentService(
        provider: provider,
        repoPath: widget.repoPath!,
        git: git,
        db: db,
      );
      try {
        final result = await agent.run(
          userMessage: text,
          history: history,
          onProgress: (status) {
            if (mounted) setState(() => _progress = status);
          },
        );
        _streamBuf = result;
      } catch (e) {
        _streamBuf = '⚠️ خطأ: $e';
      }
    } else {
      // Chat mode: simple streaming
      final service = NexusChatService(provider);
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
    }

    if (_streamBuf.isNotEmpty) {
      await repo.addMessage(
        convId: _convId!,
        role: 'assistant',
        content: _streamBuf.trim(),
      );
    }
    _streaming = false;
    _progress = '';
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
              child: Row(
                children: [
                  const Text('Nexus Agent',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    tooltip: 'محادثة جديدة',
                    onPressed: () async {
                      final repo = ref.read(nexusChatRepositoryProvider);
                      _convId = await repo.newConversation(
                          repoPath: widget.repoPath);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scroll,
                padding: const EdgeInsets.all(12),
                children: [
                  for (final m in msgs) _MessageBubble(m: m),
                  if (_streaming && _progress.isNotEmpty && _streamBuf.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(_progress),
                        ],
                      ),
                    ),
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
                ],
              ),
            ),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 7,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) {
                  const actions = [
                    'اشرح آخر Commit',
                    'راجع الكود',
                    'اقترح تحسينات',
                    'لخص التغييرات',
                    'ابحث في الملفات',
                    'تذكر هذا',
                    'إنشاء Issue',
                  ];
                  return ActionChip(
                    label: Text(actions[i],
                        style: const TextStyle(fontSize: 12)),
                    onPressed: () {
                      _controller.text = actions[i];
                      _send();
                    },
                  );
                },
              ),
            ),
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
                        hintText: 'اسأل Nexus Agent...',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'إرسال',
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
        child: MarkdownBody(
          data: m.content,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(fontSize: 14, height: 1.5),
            code: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}