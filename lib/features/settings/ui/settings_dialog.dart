import 'package:fludget/features/settings/state/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Opens the settings dialog. Edits apply on save.
Future<void> showSettingsDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => const SettingsDialog(),
);

/// The settings sheet — currently just the simulated device frame's size.
class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late final TextEditingController _width;
  late final TextEditingController _height;

  @override
  void initState() {
    super.initState();
    final device = context.read<SettingsCubit>().state;
    _width = TextEditingController(text: _format(device.deviceWidth));
    _height = TextEditingController(text: _format(device.deviceHeight));
  }

  @override
  void dispose() {
    _width.dispose();
    _height.dispose();
    super.dispose();
  }

  void _save() {
    final settings = context.read<SettingsCubit>();
    final w = double.tryParse(_width.text.trim());
    final h = double.tryParse(_height.text.trim());
    if (w != null && w > 0) settings.setDeviceWidth(w);
    if (h != null && h > 0) settings.setDeviceHeight(h);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DeviceField(label: 'Device width', controller: _width),
          const SizedBox(height: 16),
          _DeviceField(label: 'Device height', controller: _height),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}

String _format(double value) =>
    value == value.roundToDouble() ? '${value.toInt()}' : '$value';

class _DeviceField extends StatelessWidget {
  const _DeviceField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            suffixText: 'px',
          ),
        ),
      ],
    );
  }
}
