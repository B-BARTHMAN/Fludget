import 'package:fludget/core/ui/tokens.dart';
import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/state/component_editor_state.dart';
import 'package:fludget/features/project/state/project_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_state.dart';
import 'package:fludget/features/workspace/ui/tab_actions.dart' as tab_actions;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The strip of open tabs: reorderable, each showing its component's name and a
/// dirty dot, the active one highlighted, with a close button.
class WorkspaceTabBar extends StatelessWidget {
  const WorkspaceTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final workspace = context.read<WorkspaceCubit>();
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      buildWhen: (p, c) => p.tabs != c.tabs || p.activeIndex != c.activeIndex,
      builder: (context, state) => SizedBox(
        height: Sizes.tabBar,
        child: ReorderableListView(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          onReorder: workspace.reorderTab,
          children: [
            for (var i = 0; i < state.tabs.length; i++)
              ReorderableDragStartListener(
                key: ValueKey(state.tabs[i].componentId),
                index: i,
                child: _Tab(
                  tab: state.tabs[i],
                  selected: i == state.activeIndex,
                  index: i,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.tab, required this.selected, required this.index});

  final OpenTab tab;
  final bool selected;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final workspace = context.read<WorkspaceCubit>();
    final name = context.select<ProjectCubit, String>(
      (cubit) => cubit.state.project?.components[tab.componentId]?.name ?? '',
    );
    return InkWell(
      onTap: () => workspace.switchTo(index),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: Sizes.tabMinWidth,
          maxWidth: Sizes.tabMaxWidth,
        ),
        padding: const EdgeInsets.symmetric(horizontal: Insets.md),
        decoration: BoxDecoration(
          color: selected ? colors.surface : colors.surfaceContainerHighest,
          border: Border(
            bottom: BorderSide(
              color: selected ? colors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ComponentEditorCubit, ComponentEditorState>(
              bloc: tab.editor,
              buildWhen: (p, c) => p.isDirty != c.isDirty,
              builder: (context, s) => Icon(
                s.isDirty ? Icons.circle : Icons.circle_outlined,
                size: 8,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: Insets.sm),
            Flexible(child: Text(name, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: Insets.sm),
            InkWell(
              onTap: () => tab_actions.closeTab(context, index),
              child: Icon(
                Icons.close,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
