import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleEditor extends StatefulWidget {
  const DoubleEditor({required this.value, required this.onChanged, super.key});

  final Object? value;
  final ValueChanged<double?> onChanged;

  @override
  State<DoubleEditor> createState() => _DoubleEditorState();
}

class _DoubleEditorState extends State<DoubleEditor> {
  late final _controller = TextEditingController(text: _text(widget.value));
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(DoubleEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final text = _text(widget.value);
    if (widget.value != oldWidget.value && text != _controller.text) {
      _controller.text = text;
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  String _text(Object? value) {
    if (value is! num) return '';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  double? _current() =>
      widget.value is num ? (widget.value! as num).toDouble() : null;

  void _onFocusChange() {
    if (_focusNode.hasFocus) return;
    final text = _controller.text.trim();
    final parsed = text.isEmpty ? null : double.tryParse(text);
    if (parsed != _current()) widget.onChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
      ],
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
      ),
      onSubmitted: (_) => _focusNode.unfocus(),
      onTapOutside: (_) => _focusNode.unfocus(),
    );
  }
}
