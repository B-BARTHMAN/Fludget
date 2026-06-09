import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/widget_tree/widget_type_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddChildButton extends StatelessWidget {
  const AddChildButton({required this.parentId, required this.slot, super.key});

  final String parentId;
  final String slot;

  @override
  Widget build(BuildContext context) {
    final document = context.read<DocumentCubit>();
    return WidgetTypeMenu(
      tooltip: 'Add to $slot',
      icon: const Icon(Icons.add, size: 16),
      onSelected: (type) => document.addChild(parentId, slot, type),
    );
  }
}
