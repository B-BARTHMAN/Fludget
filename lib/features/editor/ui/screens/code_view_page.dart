import 'package:fludget/catalog/engine/code_generator.dart';
import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/model/widget_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shows the generated Dart for a component's [root], with a copy button.
/// [className] must already be a valid Dart identifier — the caller sanitizes.
class CodeViewPage extends StatelessWidget {
  const CodeViewPage({
    required this.root,
    required this.className,
    required this.source,
    super.key,
  });

  final WidgetNode root;
  final String className;
  final WidgetSource source;

  @override
  Widget build(BuildContext context) {
    final code = generate(root, source, className: className);
    return Scaffold(
      appBar: AppBar(
        title: Text(className),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Copied')));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
