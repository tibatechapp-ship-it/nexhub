import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/onboarding_provider.dart';

/// جولة أول تشغيل: 5 خطوات تروي هوية NexHub بذاتها —
/// «مساحة عمل مطوّر عربية تعمل بلا إنترنت».
///
/// نصوص الجولة ثوابت عربية مقصودة (المنتج عربي أولاً)؛ ربطها بملفات
/// l10n يأتي مع دليل Quickstart المصوّر في الأسبوع نفسه.

class _OnboardingStep {
  final IconData icon;
  final String title;
  final String body;

  const _OnboardingStep(this.icon, this.title, this.body);
}

const List<_OnboardingStep> _steps = [
  _OnboardingStep(
    Icons.workspaces_outlined,
    'أهلاً بك في NexHub',
    'مساحة عمل المطوّر العربية: مستودعاتك وكودك وأدواتك اليومية في تطبيق '
        'واحد — على جهازك، بلا حساب ولا سحابة ولا انتظار.',
  ),
  _OnboardingStep(
    Icons.folder_open_outlined,
    'افتح مجلدك وابدأ',
    'أنشئ مستودعاً محلياً من مجلد موجود أو مجلد جديد — «افتح المجلد '
        'وابدأ» بلا تسجيل ولا إعدادات.',
  ),
  _OnboardingStep(
    Icons.commit_outlined,
    'اعمل أول Commit بالعربية',
    'واجهة Git كاملة بالعربية: تغييراتك، تاريخك، فروعك — كل المصطلحات '
        'مفهومة من أول مرة.',
  ),
  _OnboardingStep(
    Icons.cloud_off_outlined,
    'بلا إنترنت… وبلا سحابة',
    'الكود لا يترك جهازك أبداً. اشتغل في الطائرة أو على شبكة ضعيفة — '
        'كل شيء يعمل offline أولاً.',
  ),
  _OnboardingStep(
    Icons.smart_toy_outlined,
    'وكيل AI وأدوات يومية',
    'مساعد ذكي، مقتطفات، سجل، مزامنة، وتدوين هندسي — اكتشفها من '
        'الشريط الجانبي، متى شئت.',
  ),
];

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingCompleteProvider.notifier).complete();
    if (mounted) {
      context.go('/workspace');
    }
  }

  void _next() {
    if (_index >= _steps.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _index == _steps.length - 1;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              key: const Key('onboarding_skip'),
              onPressed: _finish,
              child: const Text('تخطي'),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                key: const Key('onboarding_pageview'),
                controller: _controller,
                itemCount: _steps.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final step = _steps[i];
                  return Padding(
                    key: Key('onboarding_page_$i'),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(step.icon, size: 96, color: theme.colorScheme.primary),
                        const SizedBox(height: 24),
                        Text(
                          step.title,
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          step.body,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < _steps.length; i++)
                        Container(
                          key: Key('onboarding_dot_$i'),
                          width: i == _index ? 20 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: i == _index
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                  FilledButton(
                    key: isLast
                        ? const Key('onboarding_start')
                        : const Key('onboarding_next'),
                    onPressed: _next,
                    child: Text(isLast ? 'ابدأ الآن' : 'التالي'),
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
