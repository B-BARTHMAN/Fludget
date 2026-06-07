// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WidgetNode _$WidgetNodeFromJson(Map<String, dynamic> json) => _WidgetNode(
  id: json['id'] as String,
  type: json['type'] as String,
  props: json['props'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  slots:
      (json['slots'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => WidgetNode.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const <String, List<WidgetNode>>{},
);

Map<String, dynamic> _$WidgetNodeToJson(_WidgetNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'props': instance.props,
      'slots': instance.slots,
    };
