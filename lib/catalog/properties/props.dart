import 'package:fludget/catalog/properties/codecs/double_codec.dart';
import 'package:fludget/catalog/properties/prop.dart';

/// Shared props that recur across many widgets. Declared once here and reused
/// in defs, so a common prop — its name, codec, and default — lives in a single
/// place. Seeded with the double-based props; extend it as you add codecs, e.g.
/// `static const color = Prop<Color?>('color', ColorCodec(), fallback: null);`
abstract final class Props {
  static const width = Prop<double?>('width', DoubleCodec(), fallback: null);
  static const height = Prop<double?>('height', DoubleCodec(), fallback: null);
}
