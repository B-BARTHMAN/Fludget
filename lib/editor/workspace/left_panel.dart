import 'package:fludget/editor/files/files_panel.dart';
import 'package:fludget/editor/widget_tree/widget_tree_panel.dart';
import 'package:fludget/editor/workspace/workspace_cubit.dart';
import 'package:fludget/editor/workspace/workspace_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The left region: a segmented switch between the project's Files explorer and
/// the active component's Outline (widget tree).
class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key});

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

enum _Tab { files, outline }

class _LeftPanelState extends State<LeftPanel> {
  _Tab _tab = _Tab.files;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<_Tab>(
              segments: const [
                ButtonSegment(
                  value: _Tab.files,
                  label: Text('Files'),
                  icon: Icon(Icons.folder_outlined),
                ),
                ButtonSegment(
                  value: _Tab.outline,
                  label: Text('Outline'),
                  icon: Icon(Icons.account_tree_outlined),
                ),
              ],
              selected: {_tab},
              onSelectionChanged: (selection) =>
                  setState(() => _tab = selection.first),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _tab == _Tab.files ? const FilesPanel() : const _Outline(),
          ),
        ],
      ),
    );
  }
}

class _Outline extends StatelessWidget {
  const _Outline();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      buildWhen: (previous, current) =>
          previous.activeDocument != current.activeDocument,
      builder: (context, state) {
        final document = state.activeDocument;
        if (document == null) {
          final colors = Theme.of(context).colorScheme;
          return Center(
            child: Text(
              'No component open',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          );
        }
        return BlocProvider.value(
          value: document,
          child: const WidgetTreePanel(),
        );
      },
    );
  }
}
