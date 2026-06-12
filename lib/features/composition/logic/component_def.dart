import 'package:fludget/catalog/engine/node_builder.dart';
import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:fludget/catalog/widgets/categories.dart';
import 'package:fludget/core/util/identifiers.dart';
import 'package:fludget/features/project/logic/component.dart';
import 'package:flutter/material.dart';

/// Synthesizes a [WidgetDef] for a project [component] so it can be placed like
/// any built-in. No props or slots (a composed instance is opaque for now): the
/// preview renders the component's own tree undecorated — so it selects as one
/// unit — and codegen emits a reference to its generated class.
WidgetDef componentDef(Component component, WidgetSource source) {
  final root = component.root;
  return WidgetDef(
    type: component.id,
    label: component.name,
    category: Categories.custom,
    icon: Icons.dashboard_customize_outlined,
    build: (node, children) =>
        root == null ? const SizedBox.shrink() : buildNode(root, source),
    toCode: (node, code) => '${pascalCase(component.name)}()',
  );
}
