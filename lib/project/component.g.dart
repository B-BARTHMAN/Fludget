// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Component _$ComponentFromJson(Map<String, dynamic> json) => _Component(
  id: json['id'] as String,
  name: json['name'] as String,
  root: WidgetNode.fromJson(json['root'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ComponentToJson(_Component instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'root': instance.root,
    };
