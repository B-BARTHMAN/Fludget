import 'package:flutter/material.dart';

/// Prompts for a name. Returns the trimmed value, or null if cancelled or empty
Future<String?> promptName(
  BuildContext context, {
  required String title,
  String initial = '',
  String confirmLabel = 'OK',
}) async {
  final value = await showDialog<String>(
    context: context,
    builder: (context) =>
        _NameDialog(title: title, initial: initial, confirmLabel: confirmLabel),
  );
  return (value == null || value.isEmpty) ? null : value;
}

/// Owns its controller, so it lives exactly as long as the dialog — disposed on
/// unmount, never by hand.
class _NameDialog extends StatefulWidget {
  const _NameDialog({
    required this.title,
    required this.initial,
    required this.confirmLabel,
  });

  final String title;
  final String initial;
  final String confirmLabel;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
