import 'package:fludget/editor/workspace/workspace_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyWorkspace extends StatelessWidget {
  const EmptyWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton.icon(
        onPressed: () => context.read<WorkspaceCubit>().newDocument(),
        icon: const Icon(Icons.add),
        label: const Text('New Document'),
      ),
    );
  }
}
