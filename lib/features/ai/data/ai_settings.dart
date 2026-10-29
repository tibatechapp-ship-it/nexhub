import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiConfig {
  const AiConfig({
    required this.apiKey,
    required this.baseUrl,
    required this.model,
  });
  final String apiKey;
  final String baseUrl;
  final String model;

  bool get isConfigured =>
      baseUrl.isNotEmpty &&
      model.isNotEmpty &&
      (apiKey.isNotEmpty ||
          baseUrl.contains('localhost') ||
          baseUrl.contains('127.0.0.1'));

  AiConfig copyWith({String? apiKey, String? baseUrl, String? model}) =>
      AiConfig(
        apiKey: apiKey ?? this.apiKey,
        baseUrl: baseUrl ?? this.baseUrl,
        model: model ?? this.model,
      );
}

class AiConfigNotifier extends StateNotifier<AiConfig> {
  AiConfigNotifier()
      : super(const AiConfig(apiKey: '', baseUrl: '', model: '')) {
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = AiConfig(
      apiKey: p.getString('ai_key') ?? '',
      baseUrl: p.getString('ai_base') ?? '',
      model: p.getString('ai_model') ?? '',
    );
  }

  Future<void> save(AiConfig c) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('ai_key', c.apiKey);
    await p.setString('ai_base', c.baseUrl);
    await p.setString('ai_model', c.model);
    state = c;
  }
}

final aiConfigProvider =
    StateNotifierProvider<AiConfigNotifier, AiConfig>((ref) => AiConfigNotifier());