import 'package:fludget/core/ui/tokens.dart';
import 'package:flutter/material.dart';

/// A left panel the user can resize by dragging its right edge. Self-contained:
/// it knows only a child and the width bounds, nothing about the workspace.
class ResizablePanel extends StatefulWidget {
  const ResizablePanel({
    required this.child,
    this.min = Sizes.panelMin,
    this.max = Sizes.panelMax,
    this.initial = Sizes.panelDefault,
    super.key,
  });

  final Widget child;
  final double min;
  final double max;
  final double initial;

  @override
  State<ResizablePanel> createState() => _ResizablePanelState();
}

class _ResizablePanelState extends State<ResizablePanel> {
  late double _width = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: _width, child: widget.child),
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) => setState(() {
              _width = (_width + details.delta.dx).clamp(
                widget.min,
                widget.max,
              );
            }),
            child: const SizedBox(width: 8, child: VerticalDivider(width: 8)),
          ),
        ),
      ],
    );
  }
}
