import 'package:fludget/catalog/widgets/category.dart';

/// Top-level categories, declared once so a category name lives in a single
/// place and can't drift across defs. Nest by declaring an explicit path, e.g.
/// `static const buttons = Category(['Material', 'Buttons']);`
abstract final class Categories {
  static const layout = Category(['Layout']);
  static const display = Category(['Display']);
  static const input = Category(['Input']);
}
