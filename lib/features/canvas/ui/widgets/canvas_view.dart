import 'package:fludget/features/canvas/logic/node_builder.dart';
import 'package:fludget/features/document/cubit/document_cubit.dart';
import 'package:fludget/features/document/cubit/document_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanvasView extends StatelessWidget {
  const CanvasView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocBuilder<DocumentCubit, DocumentState>(
      buildWhen: (previous, current) => previous.root != current.root,
      builder: (context, state) {
        return ColoredBox(
          color: colors.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
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
                  child: buildNode(state.root),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
