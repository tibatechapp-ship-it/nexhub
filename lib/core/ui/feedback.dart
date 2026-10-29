import 'package:flutter/material.dart';

/// Confirmation dialog for destructive actions.
///
/// UX audit: repo removal, journal/snippet deletion, merges and merge-aborts
/// previously ran instantly with no confirmation.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'تأكيد',
  bool destructive = true,
}) async {
  final scheme = Theme.of(context).colorScheme;
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                )
              : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return res ?? false;
}

/// SnackBar with an optional recovery action.
///
/// UX audit: ~22 snackbars carried a bare message with no retry/settings path.
void showAppSnackBar(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(label: actionLabel, onPressed: onAction)
          : null,
    ),
  );
}
