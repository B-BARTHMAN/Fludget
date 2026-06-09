import 'dart:ui';

import 'package:fludget/app/router.dart';
import 'package:fludget/editor/workspace/workspace_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum _ExitAction { save, discard, cancel }

/// Intercepts an app/window close while any open component has unsaved changes.
/// Desktop-focused: relies on [WidgetsBindingObserver.didRequestAppExit], which
/// fires on a window-manager close request. Mobile OS suspension isn't
/// cancelable and isn't handled here.
class AppExitGuard extends StatefulWidget {
  const AppExitGuard({required this.child, super.key});

  final Widget child;

  @override
  State<AppExitGuard> createState() => _AppExitGuardState();
}

class _AppExitGuardState extends State<AppExitGuard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    if (!mounted) return AppExitResponse.exit;
    final workspace = context.read<WorkspaceCubit>();
    final state = workspace.state;
    if (!state.anyDirty) return AppExitResponse.exit;

    final navContext = rootNavigatorKey.currentContext;
    if (navContext == null) {
      return AppExitResponse.exit; // can't ask — don't trap
    }

    final dirty = state.tabs.where((t) => t.cubit.state.isDirty).length;
    final action = await showDialog<_ExitAction>(
      context: navContext,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: Text(
          dirty == 1
              ? 'Unsaved changes in 1 component'
              : 'Unsaved changes in $dirty components',
        ),
        content: const Text('Save your changes before quitting?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _ExitAction.cancel),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _ExitAction.discard),
            child: const Text('Discard & Quit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, _ExitAction.save),
            child: const Text('Save All & Quit'),
          ),
        ],
      ),
    );

    switch (action) {
      case _ExitAction.save:
        await workspace.saveAll();
        return AppExitResponse.exit;
      case _ExitAction.discard:
        return AppExitResponse.exit;
      case _ExitAction.cancel:
      case null:
        return AppExitResponse.cancel;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
