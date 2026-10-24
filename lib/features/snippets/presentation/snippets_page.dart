import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';

class SnippetsPage extends StatelessWidget {
  const SnippetsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.navSnippets)),
      body: Center(child: Text(l.snippetsEmpty)),
    );
  }
}