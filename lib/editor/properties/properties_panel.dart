import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/registry.dart';
import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/document/document_state.dart';
import 'package:fludget/editor/properties/property_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      buildWhen: (previous, current) =>
          previous.root != current.root ||
          previous.selectedId != current.selectedId,
      builder: (context, state) {
        final node = state.selectedNode;
        if (node == null) {
          return const Center(child: Text('Select a widget to edit'));
        }

        final props =
            widgetRegistry[node.type]?.props ?? const <Prop<dynamic>>[];

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                node.type,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (props.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('No editable properties.'),
              )
            else
              for (final prop in props) PropertyField(node: node, prop: prop),
          ],
        );
      },
    );
  }
}
