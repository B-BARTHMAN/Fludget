import 'package:flutter/material.dart';

class EmptyWorkspace extends StatelessWidget {
  const EmptyWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        'No component open',
        style: TextStyle(color: colors.onSurfaceVariant),
      ),
    );
  }
}
