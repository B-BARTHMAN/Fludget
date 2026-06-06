import 'package:fludget/features/workspace/cubit/workspace_cubit.dart';
import 'package:fludget/features/workspace/cubit/workspace_state.dart';
import 'package:fludget/features/workspace/ui/widgets/document_area.dart';
import 'package:fludget/features/workspace/ui/widgets/empty_workspace.dart';
import 'package:fludget/features/workspace/ui/widgets/workspace_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        final workspace = context.read<WorkspaceCubit>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Fludget'),
            actions: [
              IconButton(
                onPressed: workspace.saveActive,
                icon: const Icon(Icons.save_outlined),
                tooltip: 'Save',
              ),
            ],
          ),
          body: Column(
            children: [
              WorkspaceTabBar(
                tabs: [for (final t in state.tabs) t.name],
                activeIndex: state.activeIndex,
                onSelect: workspace.switchTo,
                onClose: workspace.closeTab,
                onNew: workspace.newDocument,
              ),
              const Divider(height: 1),
              Expanded(
                child: state.activeDocument == null
                    ? const EmptyWorkspace()
                    : BlocProvider.value(
                        key: ValueKey(state.activeTab!.name),
                        value: state.activeDocument!,
                        child: const DocumentArea(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
