// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'component.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Component {

 String get id; String get name; WidgetNode? get root;
/// Create a copy of Component
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComponentCopyWith<Component> get copyWith => _$ComponentCopyWithImpl<Component>(this as Component, _$identity);

  /// Serializes this Component to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Component&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,root);

@override
String toString() {
  return 'Component(id: $id, name: $name, root: $root)';
}


}

/// @nodoc
abstract mixin class $ComponentCopyWith<$Res>  {
  factory $ComponentCopyWith(Component value, $Res Function(Component) _then) = _$ComponentCopyWithImpl;
@useResult
$Res call({
 String id, String name, WidgetNode? root
});


$WidgetNodeCopyWith<$Res>? get root;

}
/// @nodoc
class _$ComponentCopyWithImpl<$Res>
    implements $ComponentCopyWith<$Res> {
  _$ComponentCopyWithImpl(this._self, this._then);

  final Component _self;
  final $Res Function(Component) _then;

/// Create a copy of Component
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? root = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: freezed == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNode?,
  ));
}
/// Create a copy of Component
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res>? get root {
    if (_self.root == null) {
    return null;
  }

  return $WidgetNodeCopyWith<$Res>(_self.root!, (value) {
    return _then(_self.copyWith(root: value));
  });
}
}


/// Adds pattern-matching-related methods to [Component].
extension ComponentPatterns on Component {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Component value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Component() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Component value)  $default,){
final _that = this;
switch (_that) {
case _Component():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Component value)?  $default,){
final _that = this;
switch (_that) {
case _Component() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  WidgetNode? root)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Component() when $default != null:
return $default(_that.id,_that.name,_that.root);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  WidgetNode? root)  $default,) {final _that = this;
switch (_that) {
case _Component():
return $default(_that.id,_that.name,_that.root);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  WidgetNode? root)?  $default,) {final _that = this;
switch (_that) {
case _Component() when $default != null:
return $default(_that.id,_that.name,_that.root);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Component implements Component {
  const _Component({required this.id, required this.name, this.root});
  factory _Component.fromJson(Map<String, dynamic> json) => _$ComponentFromJson(json);

@override final  String id;
@override final  String name;
@override final  WidgetNode? root;

/// Create a copy of Component
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComponentCopyWith<_Component> get copyWith => __$ComponentCopyWithImpl<_Component>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComponentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Component&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.root, root) || other.root == root));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,root);

@override
String toString() {
  return 'Component(id: $id, name: $name, root: $root)';
}


}

/// @nodoc
abstract mixin class _$ComponentCopyWith<$Res> implements $ComponentCopyWith<$Res> {
  factory _$ComponentCopyWith(_Component value, $Res Function(_Component) _then) = __$ComponentCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, WidgetNode? root
});


@override $WidgetNodeCopyWith<$Res>? get root;

}
/// @nodoc
class __$ComponentCopyWithImpl<$Res>
    implements _$ComponentCopyWith<$Res> {
  __$ComponentCopyWithImpl(this._self, this._then);

  final _Component _self;
  final $Res Function(_Component) _then;

/// Create a copy of Component
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? root = freezed,}) {
  return _then(_Component(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,root: freezed == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNode?,
  ));
}

/// Create a copy of Component
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res>? get root {
    if (_self.root == null) {
    return null;
  }

  return $WidgetNodeCopyWith<$Res>(_self.root!, (value) {
    return _then(_self.copyWith(root: value));
  });
}
}

// dart format on
