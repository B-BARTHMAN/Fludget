import 'package:fludget/catalog/code_generator.dart';
import 'package:fludget/catalog/model/widget_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeViewPage extends StatelessWidget {
  const CodeViewPage({
    required this.root,
    this.className = 'MyWidget',
    super.key,
  });

  final WidgetNode root;
  final String className;

  @override
  Widget build(BuildContext context) {
    final code = generate(root, className: className);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exported Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_outlined),
            tooltip: 'Copy',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code copied to clipboard')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: SelectableText(
            code,
            style: const TextStyle(fontFamily: 'monospace', height: 1.4),
          ),
        ),
      ),
    );
  }
}
