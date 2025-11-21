import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> showDeleteConfirmDialog(BuildContext context) async {
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text(
        'Do you really want to delete this expense?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(ctx).pop(false);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(ctx).pop(true);
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );

  return result ?? false;
}
