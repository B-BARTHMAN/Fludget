import 'package:fludget/core/domain/widget_registry.dart';
import 'package:fludget/core/models/property_spec.dart';
import 'package:fludget/features/document/cubit/document_cubit.dart';
import 'package:fludget/features/document/cubit/document_state.dart';
import 'package:fludget/features/properties/ui/widgets/property_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

        final specs =
            widgetRegistry[node.type]?.properties ?? const <PropertySpec>[];

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
            if (specs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('No editable properties.'),
              )
            else
              for (final spec in specs) PropertyField(node: node, spec: spec),
          ],
        );
      },
    );
  }
}
