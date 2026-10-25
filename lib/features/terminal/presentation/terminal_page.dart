import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({required this.repoPath, this.title, super.key});
  final String repoPath;
  final String? title;

  static Future<void> open(BuildContext context, String repoPath) {
    return Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => TerminalPage(repoPath: repoPath),
    ));
  }

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  final _terminal = Terminal(maxLines: 10000);
  Process? _proc;
  final _output = StringBuffer();

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final shell = Platform.isWindows
        ? 'powershell.exe'
        : (Platform.environment['SHELL'] ?? '/bin/bash');
    _proc = await Process.start(
      shell,
      [],
      workingDirectory: widget.repoPath,
      runInShell: false,
    );
    _proc!.stdout.transform(utf8.decoder).listen((d) {
      _terminal.write(d);
    });
    _proc!.stderr.transform(utf8.decoder).listen((d) {
      _terminal.write(d);
    });
    _terminal.onOutput = (d) => _proc?.stdin.write(d);
    _proc!.exitCode.then((_) {
      if (mounted) _terminal.write('\n[process exited]\n');
    });
  }

  @override
  void dispose() {
    _proc?.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Terminal'),
        actions: [
          IconButton(
            tooltip: 'مسح',
            icon: const Icon(Icons.clear_all),
            onPressed: () => _terminal.eraseDisplay(),
          ),
          IconButton(
            tooltip: 'مقاطعة',
            icon: const Icon(Icons.stop_circle_outlined),
            onPressed: () => _proc?.stdin.write('\x03'),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: TerminalView(
          _terminal,
          autofocus: true,
          backgroundOpacity: 0,
          textStyle: const TerminalStyle(fontSize: 13),
        ),
      ),
    );
  }
}