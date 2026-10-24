import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.navHistory)),
      body: Center(child: Text(l.historyEmpty)),
    );
  }
}