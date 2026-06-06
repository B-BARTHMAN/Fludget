import 'package:fludget/core/models/property_spec.dart';
import 'package:fludget/core/models/widget_node.dart';
import 'package:fludget/features/document/cubit/document_cubit.dart';
import 'package:fludget/features/properties/ui/widgets/editors/bool_editor.dart';
import 'package:fludget/features/properties/ui/widgets/editors/double_editor.dart';
import 'package:fludget/features/properties/ui/widgets/editors/enum_editor.dart';
import 'package:fludget/features/properties/ui/widgets/editors/string_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyField extends StatelessWidget {
  const PropertyField({required this.node, required this.spec, super.key});

  final WidgetNode node;
  final PropertySpec spec;

  @override
  Widget build(BuildContext context) {
    final document = context.read<DocumentCubit>();
    final value = node.props[spec.name] ?? spec.defaultValue;

    void commit(Object? newValue) =>
        document.updateProps(node.id, {spec.name: newValue});

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spec.name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          _editor(value, commit),
        ],
      ),
    );
  }

  Widget _editor(Object? value, ValueChanged<Object?> onChanged) {
    final key = ValueKey('${node.id}:${spec.name}');
    switch (spec.type) {
      case PropertyType.string:
        return StringEditor(key: key, value: value, onChanged: onChanged);
      case PropertyType.doubleValue:
        return DoubleEditor(key: key, value: value, onChanged: onChanged);
      case PropertyType.boolean:
        return BoolEditor(value: value, onChanged: onChanged);
      case PropertyType.enumValue:
        return EnumEditor(
          value: value,
          options: spec.options ?? const [],
          onChanged: onChanged,
        );
      case PropertyType.color:
      case PropertyType.edgeInsets:
      case PropertyType.alignment:
      case PropertyType.textStyle:
        return _Pending(type: spec.type);
    }
  }
}

class _Pending extends StatelessWidget {
  const _Pending({required this.type});

  final PropertyType type;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${type.name} editor — coming next',
        style: TextStyle(color: colors.onSurfaceVariant),
      ),
    );
  }
}
