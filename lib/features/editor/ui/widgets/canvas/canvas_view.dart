import 'package:fludget/catalog/engine/node_builder.dart';
import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/core/ui/tokens.dart';
import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/state/component_editor_state.dart';
import 'package:fludget/features/editor/ui/widgets/canvas/empty_canvas.dart';
import 'package:fludget/features/editor/ui/widgets/canvas/node_decoration.dart';
import 'package:fludget/features/editor/ui/widgets/canvas/node_hit_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The live preview. Renders the component's tree inside a device frame, draws
/// the selection outline, and routes taps to selection by hit-testing.
class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final GlobalKey<State<StatefulWidget>> _contentKey = GlobalKey();

  void _handleTap(PointerDownEvent event) {
    final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final id = nodeIdAt(box, event.position);
    if (id != null) context.read<ComponentEditorCubit>().select(id);
  }

  @override
  Widget build(BuildContext context) {
    final source = context.read<WidgetSource>();
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<ComponentEditorCubit, ComponentEditorState>(
      buildWhen: (p, c) => p.root != c.root || p.selectedId != c.selectedId,
      builder: (context, state) {
        final root = state.root;
        if (root == null) return const EmptyCanvas();

        final decorate = selectionDecorator(
          selectedId: state.selectedId,
          color: colors.primary,
        );
        return ColoredBox(
          color: colors.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(Insets.xl),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Listener(
                  onPointerDown: _handleTap,
                  child: Container(
                    width: DeviceFrame.width,
                    height: DeviceFrame.height,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(DeviceFrame.radius),
                      boxShadow: const [
                        BoxShadow(blurRadius: 16, color: Colors.black26),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: KeyedSubtree(
                      key: _contentKey,
                      child: buildNode(root, source, decorate: decorate),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
