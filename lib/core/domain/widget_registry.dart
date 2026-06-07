import 'package:fludget/core/domain/widget_def.dart';
import 'package:fludget/core/domain/widgets/center.dart';
import 'package:fludget/core/domain/widgets/column.dart';
import 'package:fludget/core/domain/widgets/container.dart';
import 'package:fludget/core/domain/widgets/icon.dart';
import 'package:fludget/core/domain/widgets/icon_button.dart';
import 'package:fludget/core/domain/widgets/padding.dart';
import 'package:fludget/core/domain/widgets/row.dart';
import 'package:fludget/core/domain/widgets/sized_box.dart';
import 'package:fludget/core/domain/widgets/text.dart';

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
