import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/node_builder.dart';
import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/document/document_state.dart';
import 'package:fludget/editor/widget_tree/widget_type_menu.dart';
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
        final root = state.root;
        if (root == null) return const _EmptyCanvas();

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
                      child: buildNode(root, decorate: decorate),
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

class _EmptyCanvas extends StatelessWidget {
  const _EmptyCanvas();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_to_photos_outlined,
              size: 48,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'This component is empty',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Pick the first widget to start building.',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            WidgetTypeMenu(
              onSelected: (type) => context.read<DocumentCubit>().setRoot(type),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 18, color: colors.onPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'Add a widget',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
