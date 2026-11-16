import 'package:flutter/material.dart';

// Adds reusable SnackBar functions directly to BuildContext.
extension ContextExtensions on BuildContext {
  // Displays a customizable success or error notification.
  void showSnackBar(
    String message, {
    bool isError = false,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = 16,
  }) {
    final theme = Theme.of(this);
    final resolvedColor = backgroundColor ??
        (isError ? theme.colorScheme.error : theme.colorScheme.primary);

    // Replaces the current SnackBar before displaying the new one.
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: resolvedColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // Displays an error notification.
  void showErrorSnackBar(String message, {double bottomMargin = 16}) {
    showSnackBar(message, isError: true, bottomMargin: bottomMargin);
  }

  // Displays a success notification.
  void showSuccessSnackBar(String message, {double bottomMargin = 16}) {
    showSnackBar(message, backgroundColor: Colors.green, bottomMargin: bottomMargin);
  }
}