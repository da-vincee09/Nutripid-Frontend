import 'package:flutter/material.dart';

// Displays a reusable confirmation dialog and returns the user's choice.
Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Remove',
  String cancelLabel = 'Cancel',
  bool isDestructive = true,
}) {
   // Gets the current app theme for styling the dialog.
  final theme = Theme.of(context);

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        // Closes the dialog and returns false when canceled.
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),

        // Closes the dialog and returns true when confirmed.
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: isDestructive ? theme.colorScheme.error : null,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}