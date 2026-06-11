import 'package:flutter/material.dart';

/// Editor for a nullable `double` prop — the example every editor follows.
///
/// Editor contract: take the current raw [value], render an input control
/// (no label — the properties panel supplies that), and report each edit as a
/// JSON-safe value via [onChanged]. Here that's a `double`, or `null` when
/// cleared. Invalid input is ignored so the last good value sticks.
class DoubleEditor extends StatefulWidget {
  const DoubleEditor({required this.value, required this.onChanged, super.key});

  final Object? value;
  final ValueChanged<Object?> onChanged;

  @override
  State<DoubleEditor> createState() => _DoubleEditorState();
}

class _DoubleEditorState extends State<DoubleEditor> {
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.value),
  );

  @override
  void didUpdateWidget(DoubleEditor old) {
    super.didUpdateWidget(old);
    // Resync when the value changes from elsewhere (undo, reselection).
    if (_format(widget.value) != _controller.text) {
      _controller.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      widget.onChanged(null);
    } else {
      final parsed = double.tryParse(text);
      if (parsed != null) widget.onChanged(parsed);
    }
  }

  static String _format(Object? value) =>
      value is num ? '${value.toDouble()}' : '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
      ),
      onChanged: _submit,
    );
  }
}
