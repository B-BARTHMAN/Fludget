import 'package:fludget/catalog/widget_def.dart';
import 'package:fludget/catalog/widgets/display/icon.dart';
import 'package:fludget/catalog/widgets/display/text.dart';
import 'package:fludget/catalog/widgets/input/icon_button.dart';
import 'package:fludget/catalog/widgets/layout/center.dart';
import 'package:fludget/catalog/widgets/layout/column.dart';
import 'package:fludget/catalog/widgets/layout/container.dart';
import 'package:fludget/catalog/widgets/layout/padding.dart';
import 'package:fludget/catalog/widgets/layout/row.dart';
import 'package:fludget/catalog/widgets/layout/sized_box.dart';

/// To support a new widget: create its def file, then add one import above and
/// one entry below. That is the only change outside the def file itself.
final List<WidgetDef> _definitions = [
  textDef,
  iconDef,
  containerDef,
  paddingDef,
  centerDef,
  sizedBoxDef,
  rowDef,
  columnDef,
  iconButtonDef,
];

final Map<String, WidgetDef> widgetRegistry = {
  for (final def in _definitions) def.type: def,
};
