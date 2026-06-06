import 'package:fludget/core/domain/widget_registry.dart';
import 'package:fludget/features/document/cubit/document_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddChildButton extends StatelessWidget {
  const AddChildButton({required this.parentId, super.key});

  final String parentId;

  @override
  Widget build(BuildContext context) {
    final document = context.read<DocumentCubit>();
    return PopupMenuButton<String>(
      icon: const Icon(Icons.add, size: 16),
      tooltip: 'Add child',
      onSelected: (type) => document.addChild(parentId, type),
      itemBuilder: (context) => [
        for (final type in widgetRegistry.keys)
          PopupMenuItem(value: type, child: Text(type)),
      ],
    );
  }
}
