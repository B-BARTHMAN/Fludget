import 'package:fludget/catalog/widgets/picker_node.dart';
import 'package:flutter/material.dart';

/// One square in the picker grid: the [node]'s icon over its label, with a
/// chevron when it opens a sub-level.
class PickerTile extends StatelessWidget {
  const PickerTile({required this.node, required this.onTap, super.key});

  final PickerNode node;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colors.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(node.icon, size: 28, color: colors.primary),
            const SizedBox(height: 8),
            Text(
              node.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            if (!node.isLeaf)
              Icon(
                Icons.chevron_right,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
