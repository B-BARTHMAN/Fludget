// features/workspace/ui/widgets/canvas_area.dart
import 'package:fludget/features/editor/ui/widgets/canvas/canvas_view.dart';
import 'package:fludget/features/workspace/ui/widgets/workspace_tab_bar.dart';
import 'package:flutter/material.dart';

/// The center column: the open-tab strip above the live canvas.
class CanvasArea extends StatelessWidget {
  const CanvasArea({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      WorkspaceTabBar(),
      Divider(height: 1),
      Expanded(child: CanvasView()),
    ],
  );
}
