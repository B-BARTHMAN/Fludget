import 'package:flutter/material.dart';

class PendingEditor extends StatelessWidget {
  const PendingEditor({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label editor — coming next',
        style: TextStyle(color: colors.onSurfaceVariant),
      ),
    );
  }
}
