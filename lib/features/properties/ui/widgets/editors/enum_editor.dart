import 'package:flutter/material.dart';

class EnumEditor extends StatelessWidget {
  const EnumEditor({
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final Object? value;
  final List<Object> options;
  final ValueChanged<String> onChanged;

  String _name(Object option) =>
      option is Enum ? option.name : option.toString();

  @override
  Widget build(BuildContext context) {
    final names = [for (final o in options) _name(o)];
    final current = value?.toString();
    final selected = names.contains(current) ? current : null;
    return DropdownButton<String>(
      isExpanded: true,
      value: selected,
      items: [
        for (final name in names)
          DropdownMenuItem(value: name, child: Text(name)),
      ],
      onChanged: (name) {
        if (name != null) onChanged(name);
      },
    );
  }
}
