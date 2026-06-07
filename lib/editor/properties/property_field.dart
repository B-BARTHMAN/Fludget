import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/editor/document/document_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyField extends StatelessWidget {
  const PropertyField({required this.node, required this.prop, super.key});

  final WidgetNode node;
  final Prop<dynamic> prop;

  @override
  Widget build(BuildContext context) {
    final document = context.read<DocumentCubit>();
    final value = node.props[prop.name] ?? prop.defaultJson;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prop.label ?? prop.name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          KeyedSubtree(
            key: ValueKey('${node.id}:${prop.name}'),
            child: prop.codec.editor(
              value,
              (v) => document.updateProps(node.id, {prop.name: v}),
            ),
          ),
        ],
      ),
    );
  }
}
