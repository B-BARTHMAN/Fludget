// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WidgetNode {

 String get id; String get type; Map<String, dynamic> get props; List<WidgetNode> get children;
/// Create a copy of WidgetNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<WidgetNode> get copyWith => _$WidgetNodeCopyWithImpl<WidgetNode>(this as WidgetNode, _$identity);

  /// Serializes this WidgetNode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WidgetNode&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.props, props)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,const DeepCollectionEquality().hash(props),const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'WidgetNode(id: $id, type: $type, props: $props, children: $children)';
}


}

/// @nodoc
abstract mixin class $WidgetNodeCopyWith<$Res>  {
  factory $WidgetNodeCopyWith(WidgetNode value, $Res Function(WidgetNode) _then) = _$WidgetNodeCopyWithImpl;
@useResult
$Res call({
 String id, String type, Map<String, dynamic> props, List<WidgetNode> children
});




}
/// @nodoc
class _$WidgetNodeCopyWithImpl<$Res>
    implements $WidgetNodeCopyWith<$Res> {
  _$WidgetNodeCopyWithImpl(this._self, this._then);

  final WidgetNode _self;
  final $Res Function(WidgetNode) _then;

/// Create a copy of WidgetNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? props = null,Object? children = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,props: null == props ? _self.props : props // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<WidgetNode>,
  ));
}

}


/// Adds pattern-matching-related methods to [WidgetNode].
extension WidgetNodePatterns on WidgetNode {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WidgetNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WidgetNode() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WidgetNode value)  $default,){
final _that = this;
switch (_that) {
case _WidgetNode():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WidgetNode value)?  $default,){
final _that = this;
switch (_that) {
case _WidgetNode() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  Map<String, dynamic> props,  List<WidgetNode> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WidgetNode() when $default != null:
return $default(_that.id,_that.type,_that.props,_that.children);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  Map<String, dynamic> props,  List<WidgetNode> children)  $default,) {final _that = this;
switch (_that) {
case _WidgetNode():
return $default(_that.id,_that.type,_that.props,_that.children);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  Map<String, dynamic> props,  List<WidgetNode> children)?  $default,) {final _that = this;
switch (_that) {
case _WidgetNode() when $default != null:
return $default(_that.id,_that.type,_that.props,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WidgetNode implements WidgetNode {
  const _WidgetNode({required this.id, required this.type, final  Map<String, dynamic> props = const <String, dynamic>{}, final  List<WidgetNode> children = const <WidgetNode>[]}): _props = props,_children = children;
  factory _WidgetNode.fromJson(Map<String, dynamic> json) => _$WidgetNodeFromJson(json);

@override final  String id;
@override final  String type;
 final  Map<String, dynamic> _props;
@override@JsonKey() Map<String, dynamic> get props {
  if (_props is EqualUnmodifiableMapView) return _props;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_props);
}

 final  List<WidgetNode> _children;
@override@JsonKey() List<WidgetNode> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of WidgetNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WidgetNodeCopyWith<_WidgetNode> get copyWith => __$WidgetNodeCopyWithImpl<_WidgetNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WidgetNodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WidgetNode&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._props, _props)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,const DeepCollectionEquality().hash(_props),const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'WidgetNode(id: $id, type: $type, props: $props, children: $children)';
}


}

/// @nodoc
abstract mixin class _$WidgetNodeCopyWith<$Res> implements $WidgetNodeCopyWith<$Res> {
  factory _$WidgetNodeCopyWith(_WidgetNode value, $Res Function(_WidgetNode) _then) = __$WidgetNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, Map<String, dynamic> props, List<WidgetNode> children
});




}
/// @nodoc
class __$WidgetNodeCopyWithImpl<$Res>
    implements _$WidgetNodeCopyWith<$Res> {
  __$WidgetNodeCopyWithImpl(this._self, this._then);

  final _WidgetNode _self;
  final $Res Function(_WidgetNode) _then;

/// Create a copy of WidgetNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? props = null,Object? children = null,}) {
  return _then(_WidgetNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,props: null == props ? _self._props : props // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<WidgetNode>,
  ));
}


}

// dart format on
