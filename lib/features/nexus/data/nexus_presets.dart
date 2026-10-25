class NexusPreset {
  const NexusPreset({
    required this.key,
    required this.label,
    required this.baseUrl,
    required this.models,
    required this.defaultModel,
    this.requiresKey = true,
  });
  final String key;
  final String label;
  final String baseUrl;
  final List<String> models;
  final String defaultModel;
  final bool requiresKey;
}

const nexusPresets = <NexusPreset>[
  NexusPreset(
    key: 'deepseek',
    label: 'DeepSeek',
    baseUrl: 'https://api.deepseek.com',
    models: ['deepseek-chat', 'deepseek-reasoner'],
    defaultModel: 'deepseek-chat',
  ),
  NexusPreset(
    key: 'qwen',
    label: 'Qwen (DashScope)',
    baseUrl: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
    models: ['qwen-max', 'qwen-plus', 'qwen3.7-plus'],
    defaultModel: 'qwen-plus',
  ),
  NexusPreset(
    key: 'minimax',
    label: 'MiniMax',
    baseUrl: 'https://api.minimax.io/v1',
    models: ['MiniMax-M3.1-Flash'],
    defaultModel: 'MiniMax-M3.1-Flash',
  ),
  NexusPreset(
    key: 'zai',
    label: 'Z.ai (GLM)',
    baseUrl: 'https://api.z.ai/api/paas/v4',
    models: ['glm-4.6', 'glm-5.3'],
    defaultModel: 'glm-4.6',
  ),
  NexusPreset(
    key: 'zai_coding',
    label: 'Z.ai Coding Plan',
    baseUrl: 'https://api.z.ai/api/coding/paas/v4',
    models: ['glm-4.6', 'glm-5.3'],
    defaultModel: 'glm-4.6',
  ),
  NexusPreset(
    key: 'custom',
    label: 'مخصص (OpenAI-compatible)',
    baseUrl: '',
    models: [],
    defaultModel: '',
    requiresKey: false,
  ),
];