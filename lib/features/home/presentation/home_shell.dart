import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  static const _items = [
    (path: '/workspace', icon: Icons.folder_outlined, selected: Icons.folder),
    (path: '/history', icon: Icons.history_outlined, selected: Icons.history),
    (path: '/snippets', icon: Icons.notes_outlined, selected: Icons.notes),
    (path: '/settings', icon: Icons.settings_outlined, selected: Icons.settings),
  ];

  int get _index {
    final i = _items.indexWhere((e) => location.startsWith(e.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final labels = [l.navWorkspace, l.navHistory, l.navSnippets, l.navSettings];
    final wide = MediaQuery.sizeOf(context).width >= 800;

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => context.go(_items[i].path),
              destinations: [
                for (var i = 0; i < _items.length; i++)
                  NavigationRailDestination(
                    icon: Icon(_items[i].icon),
                    selectedIcon: Icon(_items[i].selected),
                    label: Text(labels[i]),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => context.go(_items[i].path),
        destinations: [
          for (var i = 0; i < _items.length; i++)
            NavigationDestination(
              icon: Icon(_items[i].icon),
              selectedIcon: Icon(_items[i].selected),
              label: labels[i],
            ),
        ],
      ),
    );
  }
}