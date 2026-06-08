import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/document/document_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UndoRedoButtons extends StatelessWidget {
  const UndoRedoButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final document = context.read<DocumentCubit>();
    return BlocBuilder<DocumentCubit, DocumentState>(
      buildWhen: (previous, current) =>
          previous.canUndo != current.canUndo ||
          previous.canRedo != current.canRedo,
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: 'Undo',
              onPressed: state.canUndo ? document.undo : null,
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              tooltip: 'Redo',
              onPressed: state.canRedo ? document.redo : null,
            ),
          ],
        );
      },
    );
  }
}
