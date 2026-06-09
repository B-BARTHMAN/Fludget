import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/document/document_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef TabDescriptor = ({
  String componentId,
  String name,
  DocumentCubit cubit,
});

class WorkspaceTabBar extends StatelessWidget {
  const WorkspaceTabBar({
    required this.tabs,
    required this.activeIndex,
    required this.onSelect,
    required this.onClose,
    required this.onReorder,
    this.onNew,
    super.key,
  });

  final List<TabDescriptor> tabs;
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final ValueChanged<int> onClose;
  final void Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback? onNew;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              buildDefaultDragHandles: false,
              onReorder: onReorder,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                return ReorderableDragStartListener(
                  key: ValueKey(tab.componentId),
                  index: index,
                  child: _TabItem(
                    tab: tab,
                    selected: index == activeIndex,
                    onTap: () => onSelect(index),
                    onClose: () => onClose(index),
                  ),
                );
              },
            ),
          ),
          if (onNew != null)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'New component',
              onPressed: onNew,
            ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.selected,
    required this.onTap,
    required this.onClose,
  });

  final TabDescriptor tab;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 96, maxWidth: 200),
        padding: const EdgeInsets.only(left: 16, right: 8),
        decoration: BoxDecoration(
          color: selected ? colors.surfaceContainerHighest : null,
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: selected ? colors.primary : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                tab.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 6),
            BlocBuilder<DocumentCubit, DocumentState>(
              bloc: tab.cubit,
              buildWhen: (p, c) => p.isDirty != c.isDirty,
              builder: (context, state) => IconButton(
                icon: Icon(
                  state.isDirty ? Icons.circle : Icons.close,
                  size: state.isDirty ? 8 : 16,
                  color: state.isDirty ? colors.primary : null,
                ),
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                tooltip: state.isDirty ? 'Unsaved — close' : 'Close',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
