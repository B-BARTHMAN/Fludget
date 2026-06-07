import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/document/document_state.dart';
import 'package:fludget/editor/widget_tree/widget_tree_node.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetTreePanel extends StatelessWidget {
  const WidgetTreePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      buildWhen: (previous, current) =>
          previous.root != current.root ||
          previous.selectedId != current.selectedId,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: WidgetTreeNode(
            node: state.root,
            selectedId: state.selectedId,
            depth: 0,
          ),
        );
      },
    );
  }
}
