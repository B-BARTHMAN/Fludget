// features/workspace/ui/widgets/explorer_panel.dart
import 'package:fludget/features/editor/ui/widgets/tree/widget_tree.dart';
import 'package:fludget/features/project/ui/files_panel.dart';
import 'package:flutter/material.dart';

/// The combined left panel: a tab switch between the project's files and the
/// open component's widget tree. One implementation, used inline when wide and
/// inside a drawer when narrow.
class ExplorerPanel extends StatelessWidget {
  const ExplorerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Files'),
              Tab(text: 'Widgets'),
            ],
          ),
          Expanded(child: TabBarView(children: [FilesPanel(), WidgetTree()])),
        ],
      ),
    );
  }
}
