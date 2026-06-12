// features/workspace/ui/widgets/editor_shortcuts.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Registers the editor's shortcuts (undo / redo / save) on the hardware
/// keyboard, so they fire regardless of where focus sits — a focus-scoped
/// handler missed them whenever a tap moved focus onto an enclosing scope.
/// Ctrl (Windows/Linux) or Cmd (macOS).
class EditorShortcuts extends StatefulWidget {
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
  State<EditorShortcuts> createState() => _EditorShortcutsState();
}

class _EditorShortcutsState extends State<EditorShortcuts> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final keys = HardwareKeyboard.instance;
    if (!keys.isControlPressed && !keys.isMetaPressed) return false;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.keyZ:
        keys.isShiftPressed ? widget.onRedo() : widget.onUndo();
        return true;
      case LogicalKeyboardKey.keyY:
        widget.onRedo();
        return true;
      case LogicalKeyboardKey.keyS:
        widget.onSave();
        return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
