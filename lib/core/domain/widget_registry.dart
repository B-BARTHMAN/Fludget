import 'package:fludget/core/models/child_rule.dart';
import 'package:fludget/core/models/property_spec.dart';
import 'package:fludget/core/models/widget_definition.dart';
import 'package:flutter/rendering.dart';

const Map<String, WidgetDefinition> widgetRegistry = {
  'Text': WidgetDefinition(
    type: 'Text',
    childRule: ChildRule.none,
    properties: [
      PropertySpec(
        name: 'data',
        type: PropertyType.string,
        defaultValue: 'Text',
      ),
      PropertySpec(name: 'style', type: PropertyType.textStyle),
    ],
  ),
  'Icon': WidgetDefinition(
    type: 'Icon',
    childRule: ChildRule.none,
    properties: [
      PropertySpec(
        name: 'icon',
        type: PropertyType.enumValue,
        defaultValue: 'star',
        options: ['star', 'favorite', 'home', 'settings', 'add'],
      ),
      PropertySpec(
        name: 'size',
        type: PropertyType.doubleValue,
        defaultValue: 24.0,
      ),
      PropertySpec(name: 'color', type: PropertyType.color),
    ],
  ),
  'Container': WidgetDefinition(
    type: 'Container',
    childRule: ChildRule.single,
    properties: [
      PropertySpec(name: 'width', type: PropertyType.doubleValue),
      PropertySpec(name: 'height', type: PropertyType.doubleValue),
      PropertySpec(name: 'color', type: PropertyType.color),
      PropertySpec(name: 'padding', type: PropertyType.edgeInsets),
      PropertySpec(name: 'alignment', type: PropertyType.alignment),
    ],
  ),
  'Padding': WidgetDefinition(
    type: 'Padding',
    childRule: ChildRule.single,
    properties: [
      PropertySpec(
        name: 'padding',
        type: PropertyType.edgeInsets,
        defaultValue: 8.0,
      ),
    ],
  ),
  'Center': WidgetDefinition(
    type: 'Center',
    childRule: ChildRule.single,
    properties: [],
  ),
  'SizedBox': WidgetDefinition(
    type: 'SizedBox',
    childRule: ChildRule.single,
    properties: [
      PropertySpec(name: 'width', type: PropertyType.doubleValue),
      PropertySpec(name: 'height', type: PropertyType.doubleValue),
    ],
  ),
  'Row': WidgetDefinition(
    type: 'Row',
    childRule: ChildRule.multiple,
    properties: [
      PropertySpec(
        name: 'mainAxisAlignment',
        type: PropertyType.enumValue,
        defaultValue: 'start',
        options: MainAxisAlignment.values,
      ),
      PropertySpec(
        name: 'crossAxisAlignment',
        type: PropertyType.enumValue,
        defaultValue: 'center',
        options: CrossAxisAlignment.values,
      ),
    ],
  ),
  'Column': WidgetDefinition(
    type: 'Column',
    childRule: ChildRule.multiple,
    properties: [
      PropertySpec(
        name: 'mainAxisAlignment',
        type: PropertyType.enumValue,
        defaultValue: 'start',
        options: MainAxisAlignment.values,
      ),
      PropertySpec(
        name: 'crossAxisAlignment',
        type: PropertyType.enumValue,
        defaultValue: 'center',
        options: CrossAxisAlignment.values,
      ),
    ],
  ),
};
