import 'package:flutter/material.dart';

class BoolEditor extends StatelessWidget {
  const BoolEditor({required this.value, required this.onChanged, super.key});

  final Object? value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Switch(value: value == true, onChanged: onChanged),
    );
  }
}
