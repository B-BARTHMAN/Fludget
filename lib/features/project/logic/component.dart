import 'package:fludget/catalog/model/widget_node.dart';
import 'package:flutter/material.dart';

/// A named widget tree — the unit a project is made of and the thing the
/// editor opens in a tab. [root] is null until the user picks the first widget.
@immutable
class Component {
  const Component({required this.id, required this.name, this.root});

  factory Component.fromJson(Map<String, dynamic> json) => Component(
    id: json['id'] as String,
    name: json['name'] as String,
    root: json['root'] == null
        ? null
        : WidgetNode.fromJson(json['root'] as Map<String, dynamic>),
  );

  final String id;
  final String name;
  final WidgetNode? root;

  Component copyWith({String? name, WidgetNode? root}) => Component(
    id: id,
    name: name ?? this.name,
    root: root ?? this.root,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (root != null) 'root': root!.toJson(),
  };
}
