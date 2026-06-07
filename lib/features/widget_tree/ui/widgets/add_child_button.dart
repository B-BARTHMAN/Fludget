import 'package:fludget/core/domain/widget_registry.dart';
import 'package:fludget/features/document/cubit/document_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddChildButton extends StatelessWidget {
  const AddChildButton({required this.parentId, required this.slot, super.key});

  final String parentId;
  final String slot;

  @override
  Widget build(BuildContext context) {
    final document = context.read<DocumentCubit>();
    return PopupMenuButton<String>(
      icon: const Icon(Icons.add, size: 16),
      tooltip: 'Add to $slot',
      onSelected: (type) => document.addChild(parentId, slot, type),
      itemBuilder: (context) => [
        for (final type in widgetRegistry.keys)
          PopupMenuItem(value: type, child: Text(type)),
      ],
    );
  }
}
