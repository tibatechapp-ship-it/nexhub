import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/browser/presentation/browser_page.dart';
import '../../features/history/presentation/commits_page.dart';
import '../../features/history/presentation/history_page.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/snippets/presentation/snippets_page.dart';
import '../../features/workspace/presentation/workspace_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/workspace',
    routes: [
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
        ],
      ),
    ],
  );
});