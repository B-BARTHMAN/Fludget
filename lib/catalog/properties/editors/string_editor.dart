import 'package:flutter/material.dart';

class StringEditor extends StatefulWidget {
  const StringEditor({required this.value, required this.onChanged, super.key});

  final Object? value;
  final ValueChanged<String> onChanged;

  @override
  State<StringEditor> createState() => _StringEditorState();
}

class _StringEditorState extends State<StringEditor> {
  late final _controller = TextEditingController(text: _text(widget.value));
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(StringEditor oldWidget) {
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

  String _text(Object? value) => value is String ? value : '';

  void _onFocusChange() {
    if (_focusNode.hasFocus) return;
    final text = _controller.text;
    if (text != _text(widget.value)) widget.onChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
      ),
      onSubmitted: (_) => _focusNode.unfocus(),
      onTapOutside: (_) => _focusNode.unfocus(),
    );
  }
}
