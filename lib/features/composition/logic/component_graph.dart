/// The component dependency graph: which components reference which. Pure — it
/// knows only ids. Used to reject cycles in the picker and to order generated
/// classes.
class ComponentGraph {
  ComponentGraph(this._deps);

  /// Direct references, by component id.
  final Map<String, Set<String>> _deps;

  /// Whether [from] references [target] directly or transitively.
  bool dependsOn(String from, String target) {
    final seen = <String>{};
    bool visit(String id) {
      for (final dep in _deps[id] ?? const <String>{}) {
        if (dep == target || (seen.add(dep) && visit(dep))) return true;
      }
      return false;
    }

    return visit(from);
  }

  /// Every component reachable from [root] (including it), dependencies first —
  /// a valid order to emit generated classes in.
  List<String> resolutionOrder(String root) {
    final order = <String>[];
    final seen = <String>{};
    void visit(String id) {
      if (!seen.add(id)) return;
      _deps[id] ?? const <String>{}.forEach(visit);
      order.add(id);
    }

    visit(root);
    return order;
  }
}
