import 'dart:ui';

import 'package:fludget/core/ui/dialogs/save_changes_dialog.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Intercepts a desktop window-close request: if any open tab has unsaved
/// changes, asks whether to save, discard, or cancel before the app exits.
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
    final workspace = context.read<WorkspaceCubit>();
    if (!workspace.state.anyDirty) return AppExitResponse.exit;

    final choice = await askSaveChanges(context);
    switch (choice) {
      case SaveChoice.save:
        await workspace.saveAll();
        return AppExitResponse.exit;
      case SaveChoice.discard:
        return AppExitResponse.exit;
      case SaveChoice.cancel:
        return AppExitResponse.cancel;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
