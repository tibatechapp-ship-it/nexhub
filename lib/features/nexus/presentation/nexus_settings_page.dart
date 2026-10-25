import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';
import 'nexus_provider_editor.dart';
import '../data/nexus_providers_repository.dart';

class NexusSettingsPage extends ConsumerWidget {
  const NexusSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = ref.watch(nexusProvidersProvider).valueOrNull ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Nexus AI')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final p in providers)
            Card(
              child: ListTile(
                title: Text(p.label),
                subtitle: Text('${p.baseUrl} · ${p.model}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (p.isDefault)
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                    Switch(
                      value: p.enabled,
                      onChanged: (v) async {
                        await ref
                            .read(nexusProvidersRepositoryProvider)
                            .upsert(
                              id: p.id,
                              name: p.name,
                              label: p.label,
                              baseUrl: p.baseUrl,
                              model: p.model,
                              apiKey: p.apiKey,
                              enabled: v,
                              isDefault: p.isDefault,
                              maxTokens: p.maxTokens,
                              temperature: p.temperature,
                            );
                      },
                    ),
                  ],
                ),
                onTap: () => _edit(context, ref, p),
              ),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('إضافة مزود'),
            onPressed: () => _edit(context, ref, null),
          ),
        ],
      ),
    );
  }

  Future<void> _edit(
      BuildContext context, WidgetRef ref, NexusProvider? existing) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => NexusProviderEditor(existing: existing),
    );
  }
}