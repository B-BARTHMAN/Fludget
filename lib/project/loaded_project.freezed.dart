// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loaded_project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoadedProject {

 String get name; Map<String, Component> get components; Map<String, String> get folderOf; Set<String> get folders;
/// Create a copy of LoadedProject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadedProjectCopyWith<LoadedProject> get copyWith => _$LoadedProjectCopyWithImpl<LoadedProject>(this as LoadedProject, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadedProject&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.components, components)&&const DeepCollectionEquality().equals(other.folderOf, folderOf)&&const DeepCollectionEquality().equals(other.folders, folders));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(components),const DeepCollectionEquality().hash(folderOf),const DeepCollectionEquality().hash(folders));

@override
String toString() {
  return 'LoadedProject(name: $name, components: $components, folderOf: $folderOf, folders: $folders)';
}


}

/// @nodoc
abstract mixin class $LoadedProjectCopyWith<$Res>  {
  factory $LoadedProjectCopyWith(LoadedProject value, $Res Function(LoadedProject) _then) = _$LoadedProjectCopyWithImpl;
@useResult
$Res call({
 String name, Map<String, Component> components, Map<String, String> folderOf, Set<String> folders
});




}
/// @nodoc
class _$LoadedProjectCopyWithImpl<$Res>
    implements $LoadedProjectCopyWith<$Res> {
  _$LoadedProjectCopyWithImpl(this._self, this._then);

  final LoadedProject _self;
  final $Res Function(LoadedProject) _then;

/// Create a copy of LoadedProject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? components = null,Object? folderOf = null,Object? folders = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as Map<String, Component>,folderOf: null == folderOf ? _self.folderOf : folderOf // ignore: cast_nullable_to_non_nullable
as Map<String, String>,folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LoadedProject].
extension LoadedProjectPatterns on LoadedProject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoadedProject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadedProject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoadedProject value)  $default,){
final _that = this;
switch (_that) {
case _LoadedProject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoadedProject value)?  $default,){
final _that = this;
switch (_that) {
case _LoadedProject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Map<String, Component> components,  Map<String, String> folderOf,  Set<String> folders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadedProject() when $default != null:
return $default(_that.name,_that.components,_that.folderOf,_that.folders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Map<String, Component> components,  Map<String, String> folderOf,  Set<String> folders)  $default,) {final _that = this;
switch (_that) {
case _LoadedProject():
return $default(_that.name,_that.components,_that.folderOf,_that.folders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Map<String, Component> components,  Map<String, String> folderOf,  Set<String> folders)?  $default,) {final _that = this;
switch (_that) {
case _LoadedProject() when $default != null:
return $default(_that.name,_that.components,_that.folderOf,_that.folders);case _:
  return null;

}
}

}

/// @nodoc


class _LoadedProject extends LoadedProject {
  const _LoadedProject({required this.name, final  Map<String, Component> components = const <String, Component>{}, final  Map<String, String> folderOf = const <String, String>{}, final  Set<String> folders = const <String>{}}): _components = components,_folderOf = folderOf,_folders = folders,super._();
  

@override final  String name;
 final  Map<String, Component> _components;
@override@JsonKey() Map<String, Component> get components {
  if (_components is EqualUnmodifiableMapView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_components);
}

 final  Map<String, String> _folderOf;
@override@JsonKey() Map<String, String> get folderOf {
  if (_folderOf is EqualUnmodifiableMapView) return _folderOf;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_folderOf);
}

 final  Set<String> _folders;
@override@JsonKey() Set<String> get folders {
  if (_folders is EqualUnmodifiableSetView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_folders);
}


/// Create a copy of LoadedProject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedProjectCopyWith<_LoadedProject> get copyWith => __$LoadedProjectCopyWithImpl<_LoadedProject>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadedProject&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._components, _components)&&const DeepCollectionEquality().equals(other._folderOf, _folderOf)&&const DeepCollectionEquality().equals(other._folders, _folders));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_components),const DeepCollectionEquality().hash(_folderOf),const DeepCollectionEquality().hash(_folders));

@override
String toString() {
  return 'LoadedProject(name: $name, components: $components, folderOf: $folderOf, folders: $folders)';
}


}

/// @nodoc
abstract mixin class _$LoadedProjectCopyWith<$Res> implements $LoadedProjectCopyWith<$Res> {
  factory _$LoadedProjectCopyWith(_LoadedProject value, $Res Function(_LoadedProject) _then) = __$LoadedProjectCopyWithImpl;
@override @useResult
$Res call({
 String name, Map<String, Component> components, Map<String, String> folderOf, Set<String> folders
});




}
/// @nodoc
class __$LoadedProjectCopyWithImpl<$Res>
    implements _$LoadedProjectCopyWith<$Res> {
  __$LoadedProjectCopyWithImpl(this._self, this._then);

  final _LoadedProject _self;
  final $Res Function(_LoadedProject) _then;

/// Create a copy of LoadedProject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? components = null,Object? folderOf = null,Object? folders = null,}) {
  return _then(_LoadedProject(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as Map<String, Component>,folderOf: null == folderOf ? _self._folderOf : folderOf // ignore: cast_nullable_to_non_nullable
as Map<String, String>,folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
