import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/document/document_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef TabDescriptor = ({String name, DocumentCubit cubit});

class WorkspaceTabBar extends StatelessWidget {
  const WorkspaceTabBar({
    required this.tabs,
    required this.activeIndex,
    required this.onSelect,
    required this.onClose,
    this.onNew,
    super.key,
  });

  final List<TabDescriptor> tabs;
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final ValueChanged<int> onClose;
  final VoidCallback? onNew;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final selected = index == activeIndex;
                return InkWell(
                  onTap: () => onSelect(index),
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 96,
                      maxWidth: 200,
                    ),
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
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
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
                            onPressed: () => onClose(index),
                            tooltip: state.isDirty
                                ? 'Unsaved - close'
                                : 'Close',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (onNew != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onNew,
              tooltip: 'New Component',
            ),
        ],
      ),
    );
  }
}
