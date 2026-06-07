enum SlotArity { single, many }

/// Read children out of a resolved slot map. Works for both the built-widget
/// map (build) and the code-string map (toCode).
extension ChildAccess<T> on Map<String, List<T>> {
  T? one(String slot) {
    final list = this[slot];
    return (list == null || list.isEmpty) ? null : list.first;
  }

  List<T> many(String slot) => this[slot] ?? const [];
}
