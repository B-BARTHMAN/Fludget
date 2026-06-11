import 'package:flutter/material.dart';

/// Where a widget sits in the categorized add-widget menu — a path of segments
/// so subcategories come for free: `Category(['Layout'])`, or
/// `Category(['Material', 'Buttons'])`. The picker tree is built by grouping
/// widgets on this path.
@immutable
class Category {
  const Category(this.path);

  final List<String> path;

  @override
  bool operator ==(Object other) {
    if (other is! Category || other.path.length != path.length) return false;
    for (var i = 0; i < path.length; i++) {
      if (other.path[i] != path[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(path);
}
