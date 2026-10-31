
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/browser/presentation/browser_page.dart';
import '../../features/history/presentation/commits_page.dart';
import '../../features/history/presentation/history_page.dart';
import '../../features/nexus/presentation/nexus_settings_page.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/onboarding/data/onboarding_provider.dart';
import '../../features/onboarding/presentation/onboarding_flow.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/snippets/presentation/snippets_page.dart';
import '../../features/workspace/presentation/workspace_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/workspace',
    // جولة أول تشغيل: من لا يملك علم الإتمام يُرسل إلى /onboarding
    // أولاً (أسبوع 1 من خارطة المنتَجة — الهوية والسرد).
    redirect: (_, state) => onboardingRedirectFor(state.uri.path),
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingFlow(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            HomeShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/workspace',
            builder: (_, __) => const WorkspacePage(),
          ),
          GoRoute(
            path: '/browser/:id',
            builder: (_, state) => BrowserPage(
              workspaceId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/commits/:path',
            builder: (_, state) => CommitsPage(
              repoPath: Uri.decodeComponent(state.pathParameters['path']!),
            ),
          ),
          GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
          GoRoute(path: '/snippets', builder: (_, __) => const SnippetsPage()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
          GoRoute(path: '/nexus', builder: (_, __) => const NexusSettingsPage()),
        ],
      ),
    ],
  );
});