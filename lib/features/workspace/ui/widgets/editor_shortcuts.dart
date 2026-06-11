import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps [child] with the editor's keyboard shortcuts (undo / redo / save),
/// each bound for both Ctrl (Windows/Linux) and Cmd (macOS) without writing the
/// pair out by hand.
class EditorShortcuts extends StatelessWidget {
  const EditorShortcuts({
    required this.child,
    required this.onUndo,
    required this.onRedo,
    required this.onSave,
    super.key,
  });

  final Widget child;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        ..._bind(LogicalKeyboardKey.keyZ, onUndo),
        ..._bind(LogicalKeyboardKey.keyZ, onRedo, shift: true),
        ..._bind(LogicalKeyboardKey.keyY, onRedo),
        ..._bind(LogicalKeyboardKey.keyS, onSave),
      },
      child: Focus(autofocus: true, child: child),
    );
  }

  /// Both the Ctrl and Cmd variants of [key] (+ optional [shift]) -> [action].
  Map<ShortcutActivator, VoidCallback> _bind(
    LogicalKeyboardKey key,
    VoidCallback action, {
    bool shift = false,
  }) => {
    SingleActivator(key, control: true, shift: shift): action,
    SingleActivator(key, meta: true, shift: shift): action,
  };
}
