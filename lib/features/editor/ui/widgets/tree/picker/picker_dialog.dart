import 'package:fludget/catalog/widgets/picker_node.dart';
import 'package:fludget/features/editor/ui/widgets/tree/picker/picker_tile.dart';
import 'package:flutter/material.dart';

/// Opens the drill-down picker and returns the chosen widget type, or null if
/// dismissed. [roots] is the top level — built-in categories plus `Custom`.
Future<String?> showWidgetPicker(BuildContext context, List<PickerNode> roots) {
  return showDialog<String>(
    context: context,
    builder: (_) => _PickerDialog(roots: roots),
  );
}

class _PickerDialog extends StatefulWidget {
  const _PickerDialog({required this.roots});

  final List<PickerNode> roots;

  @override
  State<_PickerDialog> createState() => _PickerDialogState();
}

class _PickerDialogState extends State<_PickerDialog> {
  /// Categories opened so far; empty means the root level.
  final _trail = <PickerNode>[];

  List<PickerNode> get _level =>
      _trail.isEmpty ? widget.roots : _trail.last.children;

  String get _title => _trail.isEmpty ? 'Add a widget' : _trail.last.label;

  void _open(PickerNode node) => node.isLeaf
      ? Navigator.of(context).pop(node.type)
      : setState(() => _trail.add(node));

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(
              title: _title,
              onBack: _trail.isEmpty ? null : () => setState(_trail.removeLast),
            ),
            const Divider(height: 1),
            Flexible(
              child: GridView.extent(
                padding: const EdgeInsets.all(16),
                maxCrossAxisExtent: 130,
                childAspectRatio: 0.9,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  for (final node in _level)
                    PickerTile(node: node, onTap: () => _open(node)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(onBack == null ? Icons.close : Icons.arrow_back),
            tooltip: onBack == null ? 'Close' : 'Back',
            onPressed: onBack ?? () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
