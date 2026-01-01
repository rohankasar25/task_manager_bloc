import 'package:flutter/material.dart';

extension StringCasingExtension on String {
  String toSentenceCase() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext, false);
          },
          child: Text(cancelText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(dialogContext, true);
          },
          child: Text(confirmText),
        ),
      ],
    ),
  );

  return result ?? false;
}
