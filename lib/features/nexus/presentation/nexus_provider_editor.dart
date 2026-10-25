import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';
import '../data/nexus_presets.dart';
import '../data/nexus_providers_repository.dart';

class NexusProviderEditor extends ConsumerStatefulWidget {
  const NexusProviderEditor({super.key, this.existing});
  final NexusProvider? existing;

  @override
  ConsumerState<NexusProviderEditor> createState() =>
      _NexusProviderEditorState();
}

class _NexusProviderEditorState extends ConsumerState<NexusProviderEditor> {
  String _presetKey = 'deepseek';
  late final TextEditingController _name;
  late final TextEditingController _label;
  late final TextEditingController _baseUrl;
  late final TextEditingController _apiKey;
  late final TextEditingController _model;
  bool _enabled = true;
  bool _isDefault = false;
  int _maxTokens = 2048;
  double _temperature = 0.2;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _label = TextEditingController(text: e?.label ?? '');
    _baseUrl = TextEditingController(text: e?.baseUrl ?? '');
    _apiKey = TextEditingController(text: e?.apiKey ?? '');
    _model = TextEditingController(text: e?.model ?? '');
    _enabled = e?.enabled ?? true;
    _isDefault = e?.isDefault ?? false;
    _maxTokens = e?.maxTokens ?? 2048;
    _temperature = e?.temperature ?? 0.2;
    if (e != null) {
      _presetKey = 'custom';
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _label.dispose();
    _baseUrl.dispose();
    _apiKey.dispose();
    _model.dispose();
    super.dispose();
  }

  void _applyPreset(String key) {
    final p = nexusPresets.firstWhere((x) => x.key == key);
    setState(() {
      _presetKey = key;
      if (key != 'custom') {
        _label.text = p.label;
        _name.text = p.key;
        _baseUrl.text = p.baseUrl;
        _model.text = p.defaultModel;
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(nexusProvidersRepositoryProvider).upsert(
            id: widget.existing?.id,
            name: _name.text.trim(),
            label: _label.text.trim(),
            baseUrl: _baseUrl.text.trim(),
            model: _model.text.trim(),
            apiKey: _apiKey.text.trim(),
            enabled: _enabled,
            isDefault: _isDefault,
            maxTokens: _maxTokens,
            temperature: _temperature,
          );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preset = nexusPresets.firstWhere((p) => p.key == _presetKey);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existing == null ? 'مزود جديد' : 'تعديل مزود',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _presetKey,
              decoration: const InputDecoration(labelText: 'النوع'),
              items: [
                for (final p in nexusPresets)
                  DropdownMenuItem(value: p.key, child: Text(p.label)),
              ],
              onChanged: (v) => _applyPreset(v!),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'المعرّف (name)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _label,
              decoration: const InputDecoration(labelText: 'الاسم (label)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _baseUrl,
              decoration: const InputDecoration(labelText: 'Base URL'),
            ),
            const SizedBox(height: 8),
            if (preset.requiresKey || _presetKey == 'custom')
              TextField(
                controller: _apiKey,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'API Key'),
              ),
            const SizedBox(height: 8),
            if (_presetKey == 'custom' || preset.models.isEmpty)
              TextField(
                controller: _model,
                decoration: const InputDecoration(labelText: 'Model'),
              )
            else
              DropdownButtonFormField<String>(
                value: preset.models.contains(_model.text)
                    ? _model.text
                    : preset.defaultModel,
                decoration: const InputDecoration(labelText: 'Model'),
                items: [
                  for (final m in preset.models)
                    DropdownMenuItem(value: m, child: Text(m)),
                ],
                onChanged: (v) => setState(() => _model.text = v!),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('مُفعَّل'),
                const Spacer(),
                Switch(
                  value: _enabled,
                  onChanged: (v) => setState(() => _enabled = v),
                ),
              ],
            ),
            Row(
              children: [
                const Text('افتراضي'),
                const Spacer(),
                Switch(
                  value: _isDefault,
                  onChanged: (v) => setState(() => _isDefault = v),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('max_tokens: $_maxTokens'),
            Slider(
              value: _maxTokens.toDouble(),
              min: 256,
              max: 8192,
              divisions: 31,
              onChanged: (v) => setState(() => _maxTokens = v.round()),
            ),
            Text('temperature: ${_temperature.toStringAsFixed(2)}'),
            Slider(
              value: _temperature,
              min: 0,
              max: 1,
              divisions: 20,
              onChanged: (v) => setState(() => _temperature = v),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}