// lib/editor/canvas/canvas_view.dart
import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/node_builder.dart';
import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/document/document_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final GlobalKey<State<StatefulWidget>> _contentKey = GlobalKey();

  void _handlePointerDown(PointerDownEvent event) {
    final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final result = BoxHitTestResult();
    box.hitTest(result, position: box.globalToLocal(event.position));
    for (final entry in result.path) {
      final target = entry.target;
      if (target is RenderMetaData) {
        final id = target.metaData;
        if (id is String) {
          context.read<DocumentCubit>().select(id);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocBuilder<DocumentCubit, DocumentState>(
      buildWhen: (previous, current) =>
          previous.root != current.root ||
          previous.selectedId != current.selectedId,
      builder: (context, state) {
        Widget decorate(WidgetNode node, Widget built) {
          final tagged = MetaData(
            metaData: node.id,
            behavior: HitTestBehavior.translucent,
            child: built,
          );
          if (node.id != state.selectedId) return tagged;
          return DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: Border.all(color: colors.primary, width: 2),
            ),
            child: tagged,
          );
        }

        return ColoredBox(
          color: colors.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Listener(
                  onPointerDown: _handlePointerDown,
                  child: Container(
                    width: 360,
                    height: 640,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(blurRadius: 16, color: Colors.black26),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: KeyedSubtree(
                      key: _contentKey,
                      child: buildNode(state.root, decorate: decorate),
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
