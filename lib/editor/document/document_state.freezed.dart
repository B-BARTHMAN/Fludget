// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentState {

 WidgetNode get root; String? get selectedId; List<WidgetNode> get past; List<WidgetNode> get future;
/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentStateCopyWith<DocumentState> get copyWith => _$DocumentStateCopyWithImpl<DocumentState>(this as DocumentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentState&&(identical(other.root, root) || other.root == root)&&(identical(other.selectedId, selectedId) || other.selectedId == selectedId)&&const DeepCollectionEquality().equals(other.past, past)&&const DeepCollectionEquality().equals(other.future, future));
}


@override
int get hashCode => Object.hash(runtimeType,root,selectedId,const DeepCollectionEquality().hash(past),const DeepCollectionEquality().hash(future));

@override
String toString() {
  return 'DocumentState(root: $root, selectedId: $selectedId, past: $past, future: $future)';
}


}

/// @nodoc
abstract mixin class $DocumentStateCopyWith<$Res>  {
  factory $DocumentStateCopyWith(DocumentState value, $Res Function(DocumentState) _then) = _$DocumentStateCopyWithImpl;
@useResult
$Res call({
 WidgetNode root, String? selectedId, List<WidgetNode> past, List<WidgetNode> future
});


$WidgetNodeCopyWith<$Res> get root;

}
/// @nodoc
class _$DocumentStateCopyWithImpl<$Res>
    implements $DocumentStateCopyWith<$Res> {
  _$DocumentStateCopyWithImpl(this._self, this._then);

  final DocumentState _self;
  final $Res Function(DocumentState) _then;

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? root = null,Object? selectedId = freezed,Object? past = null,Object? future = null,}) {
  return _then(_self.copyWith(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNode,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as List<WidgetNode>,future: null == future ? _self.future : future // ignore: cast_nullable_to_non_nullable
as List<WidgetNode>,
  ));
}
/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res> get root {
  
  return $WidgetNodeCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}
}


/// Adds pattern-matching-related methods to [DocumentState].
extension DocumentStatePatterns on DocumentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentState value)  $default,){
final _that = this;
switch (_that) {
case _DocumentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentState value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WidgetNode root,  String? selectedId,  List<WidgetNode> past,  List<WidgetNode> future)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentState() when $default != null:
return $default(_that.root,_that.selectedId,_that.past,_that.future);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WidgetNode root,  String? selectedId,  List<WidgetNode> past,  List<WidgetNode> future)  $default,) {final _that = this;
switch (_that) {
case _DocumentState():
return $default(_that.root,_that.selectedId,_that.past,_that.future);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WidgetNode root,  String? selectedId,  List<WidgetNode> past,  List<WidgetNode> future)?  $default,) {final _that = this;
switch (_that) {
case _DocumentState() when $default != null:
return $default(_that.root,_that.selectedId,_that.past,_that.future);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentState extends DocumentState {
  const _DocumentState({required this.root, this.selectedId, final  List<WidgetNode> past = const <WidgetNode>[], final  List<WidgetNode> future = const <WidgetNode>[]}): _past = past,_future = future,super._();
  

@override final  WidgetNode root;
@override final  String? selectedId;
 final  List<WidgetNode> _past;
@override@JsonKey() List<WidgetNode> get past {
  if (_past is EqualUnmodifiableListView) return _past;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_past);
}

 final  List<WidgetNode> _future;
@override@JsonKey() List<WidgetNode> get future {
  if (_future is EqualUnmodifiableListView) return _future;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_future);
}


/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentStateCopyWith<_DocumentState> get copyWith => __$DocumentStateCopyWithImpl<_DocumentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentState&&(identical(other.root, root) || other.root == root)&&(identical(other.selectedId, selectedId) || other.selectedId == selectedId)&&const DeepCollectionEquality().equals(other._past, _past)&&const DeepCollectionEquality().equals(other._future, _future));
}


@override
int get hashCode => Object.hash(runtimeType,root,selectedId,const DeepCollectionEquality().hash(_past),const DeepCollectionEquality().hash(_future));

@override
String toString() {
  return 'DocumentState(root: $root, selectedId: $selectedId, past: $past, future: $future)';
}


}

/// @nodoc
abstract mixin class _$DocumentStateCopyWith<$Res> implements $DocumentStateCopyWith<$Res> {
  factory _$DocumentStateCopyWith(_DocumentState value, $Res Function(_DocumentState) _then) = __$DocumentStateCopyWithImpl;
@override @useResult
$Res call({
 WidgetNode root, String? selectedId, List<WidgetNode> past, List<WidgetNode> future
});


@override $WidgetNodeCopyWith<$Res> get root;

}
/// @nodoc
class __$DocumentStateCopyWithImpl<$Res>
    implements _$DocumentStateCopyWith<$Res> {
  __$DocumentStateCopyWithImpl(this._self, this._then);

  final _DocumentState _self;
  final $Res Function(_DocumentState) _then;

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? root = null,Object? selectedId = freezed,Object? past = null,Object? future = null,}) {
  return _then(_DocumentState(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as WidgetNode,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,past: null == past ? _self._past : past // ignore: cast_nullable_to_non_nullable
as List<WidgetNode>,future: null == future ? _self._future : future // ignore: cast_nullable_to_non_nullable
as List<WidgetNode>,
  ));
}

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WidgetNodeCopyWith<$Res> get root {
  
  return $WidgetNodeCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}
}

// dart format on
