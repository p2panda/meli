// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_generated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OperationValue {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool field0) boolean,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(String field0) relation,
    required TResult Function(List<String> field0) relationList,
    required TResult Function(String field0) pinnedRelation,
    required TResult Function(List<String> field0) pinnedRelationList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool field0)? boolean,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(String field0)? relation,
    TResult? Function(List<String> field0)? relationList,
    TResult? Function(String field0)? pinnedRelation,
    TResult? Function(List<String> field0)? pinnedRelationList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool field0)? boolean,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(String field0)? relation,
    TResult Function(List<String> field0)? relationList,
    TResult Function(String field0)? pinnedRelation,
    TResult Function(List<String> field0)? pinnedRelationList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OperationValue_Boolean value) boolean,
    required TResult Function(OperationValue_Integer value) integer,
    required TResult Function(OperationValue_Float value) float,
    required TResult Function(OperationValue_String value) string,
    required TResult Function(OperationValue_Relation value) relation,
    required TResult Function(OperationValue_RelationList value) relationList,
    required TResult Function(OperationValue_PinnedRelation value)
        pinnedRelation,
    required TResult Function(OperationValue_PinnedRelationList value)
        pinnedRelationList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OperationValue_Boolean value)? boolean,
    TResult? Function(OperationValue_Integer value)? integer,
    TResult? Function(OperationValue_Float value)? float,
    TResult? Function(OperationValue_String value)? string,
    TResult? Function(OperationValue_Relation value)? relation,
    TResult? Function(OperationValue_RelationList value)? relationList,
    TResult? Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult? Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OperationValue_Boolean value)? boolean,
    TResult Function(OperationValue_Integer value)? integer,
    TResult Function(OperationValue_Float value)? float,
    TResult Function(OperationValue_String value)? string,
    TResult Function(OperationValue_Relation value)? relation,
    TResult Function(OperationValue_RelationList value)? relationList,
    TResult Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperationValueCopyWith<$Res> {
  factory $OperationValueCopyWith(
          OperationValue value, $Res Function(OperationValue) then) =
      _$OperationValueCopyWithImpl<$Res, OperationValue>;
}

/// @nodoc
class _$OperationValueCopyWithImpl<$Res, $Val extends OperationValue>
    implements $OperationValueCopyWith<$Res> {
  _$OperationValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$OperationValue_BooleanCopyWith<$Res> {
  factory _$$OperationValue_BooleanCopyWith(_$OperationValue_Boolean value,
          $Res Function(_$OperationValue_Boolean) then) =
      __$$OperationValue_BooleanCopyWithImpl<$Res>;
  @useResult
  $Res call({bool field0});
}

/// @nodoc
class __$$OperationValue_BooleanCopyWithImpl<$Res>
    extends _$OperationValueCopyWithImpl<$Res, _$OperationValue_Boolean>
    implements _$$OperationValue_BooleanCopyWith<$Res> {
  __$$OperationValue_BooleanCopyWithImpl(_$OperationValue_Boolean _value,
      $Res Function(_$OperationValue_Boolean) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$OperationValue_Boolean(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$OperationValue_Boolean implements OperationValue_Boolean {
  const _$OperationValue_Boolean(this.field0);

  @override
  final bool field0;

  @override
  String toString() {
    return 'OperationValue.boolean(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationValue_Boolean &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationValue_BooleanCopyWith<_$OperationValue_Boolean> get copyWith =>
      __$$OperationValue_BooleanCopyWithImpl<_$OperationValue_Boolean>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool field0) boolean,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(String field0) relation,
    required TResult Function(List<String> field0) relationList,
    required TResult Function(String field0) pinnedRelation,
    required TResult Function(List<String> field0) pinnedRelationList,
  }) {
    return boolean(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool field0)? boolean,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(String field0)? relation,
    TResult? Function(List<String> field0)? relationList,
    TResult? Function(String field0)? pinnedRelation,
    TResult? Function(List<String> field0)? pinnedRelationList,
  }) {
    return boolean?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool field0)? boolean,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(String field0)? relation,
    TResult Function(List<String> field0)? relationList,
    TResult Function(String field0)? pinnedRelation,
    TResult Function(List<String> field0)? pinnedRelationList,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OperationValue_Boolean value) boolean,
    required TResult Function(OperationValue_Integer value) integer,
    required TResult Function(OperationValue_Float value) float,
    required TResult Function(OperationValue_String value) string,
    required TResult Function(OperationValue_Relation value) relation,
    required TResult Function(OperationValue_RelationList value) relationList,
    required TResult Function(OperationValue_PinnedRelation value)
        pinnedRelation,
    required TResult Function(OperationValue_PinnedRelationList value)
        pinnedRelationList,
  }) {
    return boolean(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OperationValue_Boolean value)? boolean,
    TResult? Function(OperationValue_Integer value)? integer,
    TResult? Function(OperationValue_Float value)? float,
    TResult? Function(OperationValue_String value)? string,
    TResult? Function(OperationValue_Relation value)? relation,
    TResult? Function(OperationValue_RelationList value)? relationList,
    TResult? Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult? Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
  }) {
    return boolean?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OperationValue_Boolean value)? boolean,
    TResult Function(OperationValue_Integer value)? integer,
    TResult Function(OperationValue_Float value)? float,
    TResult Function(OperationValue_String value)? string,
    TResult Function(OperationValue_Relation value)? relation,
    TResult Function(OperationValue_RelationList value)? relationList,
    TResult Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(this);
    }
    return orElse();
  }
}

abstract class OperationValue_Boolean implements OperationValue {
  const factory OperationValue_Boolean(final bool field0) =
      _$OperationValue_Boolean;

  @override
  bool get field0;
  @JsonKey(ignore: true)
  _$$OperationValue_BooleanCopyWith<_$OperationValue_Boolean> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OperationValue_IntegerCopyWith<$Res> {
  factory _$$OperationValue_IntegerCopyWith(_$OperationValue_Integer value,
          $Res Function(_$OperationValue_Integer) then) =
      __$$OperationValue_IntegerCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$OperationValue_IntegerCopyWithImpl<$Res>
    extends _$OperationValueCopyWithImpl<$Res, _$OperationValue_Integer>
    implements _$$OperationValue_IntegerCopyWith<$Res> {
  __$$OperationValue_IntegerCopyWithImpl(_$OperationValue_Integer _value,
      $Res Function(_$OperationValue_Integer) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$OperationValue_Integer(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$OperationValue_Integer implements OperationValue_Integer {
  const _$OperationValue_Integer(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'OperationValue.integer(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationValue_Integer &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationValue_IntegerCopyWith<_$OperationValue_Integer> get copyWith =>
      __$$OperationValue_IntegerCopyWithImpl<_$OperationValue_Integer>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool field0) boolean,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(String field0) relation,
    required TResult Function(List<String> field0) relationList,
    required TResult Function(String field0) pinnedRelation,
    required TResult Function(List<String> field0) pinnedRelationList,
  }) {
    return integer(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool field0)? boolean,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(String field0)? relation,
    TResult? Function(List<String> field0)? relationList,
    TResult? Function(String field0)? pinnedRelation,
    TResult? Function(List<String> field0)? pinnedRelationList,
  }) {
    return integer?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool field0)? boolean,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(String field0)? relation,
    TResult Function(List<String> field0)? relationList,
    TResult Function(String field0)? pinnedRelation,
    TResult Function(List<String> field0)? pinnedRelationList,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OperationValue_Boolean value) boolean,
    required TResult Function(OperationValue_Integer value) integer,
    required TResult Function(OperationValue_Float value) float,
    required TResult Function(OperationValue_String value) string,
    required TResult Function(OperationValue_Relation value) relation,
    required TResult Function(OperationValue_RelationList value) relationList,
    required TResult Function(OperationValue_PinnedRelation value)
        pinnedRelation,
    required TResult Function(OperationValue_PinnedRelationList value)
        pinnedRelationList,
  }) {
    return integer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OperationValue_Boolean value)? boolean,
    TResult? Function(OperationValue_Integer value)? integer,
    TResult? Function(OperationValue_Float value)? float,
    TResult? Function(OperationValue_String value)? string,
    TResult? Function(OperationValue_Relation value)? relation,
    TResult? Function(OperationValue_RelationList value)? relationList,
    TResult? Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult? Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
  }) {
    return integer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OperationValue_Boolean value)? boolean,
    TResult Function(OperationValue_Integer value)? integer,
    TResult Function(OperationValue_Float value)? float,
    TResult Function(OperationValue_String value)? string,
    TResult Function(OperationValue_Relation value)? relation,
    TResult Function(OperationValue_RelationList value)? relationList,
    TResult Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(this);
    }
    return orElse();
  }
}

abstract class OperationValue_Integer implements OperationValue {
  const factory OperationValue_Integer(final int field0) =
      _$OperationValue_Integer;

  @override
  int get field0;
  @JsonKey(ignore: true)
  _$$OperationValue_IntegerCopyWith<_$OperationValue_Integer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OperationValue_FloatCopyWith<$Res> {
  factory _$$OperationValue_FloatCopyWith(_$OperationValue_Float value,
          $Res Function(_$OperationValue_Float) then) =
      __$$OperationValue_FloatCopyWithImpl<$Res>;
  @useResult
  $Res call({double field0});
}

/// @nodoc
class __$$OperationValue_FloatCopyWithImpl<$Res>
    extends _$OperationValueCopyWithImpl<$Res, _$OperationValue_Float>
    implements _$$OperationValue_FloatCopyWith<$Res> {
  __$$OperationValue_FloatCopyWithImpl(_$OperationValue_Float _value,
      $Res Function(_$OperationValue_Float) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$OperationValue_Float(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$OperationValue_Float implements OperationValue_Float {
  const _$OperationValue_Float(this.field0);

  @override
  final double field0;

  @override
  String toString() {
    return 'OperationValue.float(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationValue_Float &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationValue_FloatCopyWith<_$OperationValue_Float> get copyWith =>
      __$$OperationValue_FloatCopyWithImpl<_$OperationValue_Float>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool field0) boolean,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(String field0) relation,
    required TResult Function(List<String> field0) relationList,
    required TResult Function(String field0) pinnedRelation,
    required TResult Function(List<String> field0) pinnedRelationList,
  }) {
    return float(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool field0)? boolean,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(String field0)? relation,
    TResult? Function(List<String> field0)? relationList,
    TResult? Function(String field0)? pinnedRelation,
    TResult? Function(List<String> field0)? pinnedRelationList,
  }) {
    return float?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool field0)? boolean,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(String field0)? relation,
    TResult Function(List<String> field0)? relationList,
    TResult Function(String field0)? pinnedRelation,
    TResult Function(List<String> field0)? pinnedRelationList,
    required TResult orElse(),
  }) {
    if (float != null) {
      return float(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OperationValue_Boolean value) boolean,
    required TResult Function(OperationValue_Integer value) integer,
    required TResult Function(OperationValue_Float value) float,
    required TResult Function(OperationValue_String value) string,
    required TResult Function(OperationValue_Relation value) relation,
    required TResult Function(OperationValue_RelationList value) relationList,
    required TResult Function(OperationValue_PinnedRelation value)
        pinnedRelation,
    required TResult Function(OperationValue_PinnedRelationList value)
        pinnedRelationList,
  }) {
    return float(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OperationValue_Boolean value)? boolean,
    TResult? Function(OperationValue_Integer value)? integer,
    TResult? Function(OperationValue_Float value)? float,
    TResult? Function(OperationValue_String value)? string,
    TResult? Function(OperationValue_Relation value)? relation,
    TResult? Function(OperationValue_RelationList value)? relationList,
    TResult? Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult? Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
  }) {
    return float?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OperationValue_Boolean value)? boolean,
    TResult Function(OperationValue_Integer value)? integer,
    TResult Function(OperationValue_Float value)? float,
    TResult Function(OperationValue_String value)? string,
    TResult Function(OperationValue_Relation value)? relation,
    TResult Function(OperationValue_RelationList value)? relationList,
    TResult Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
    required TResult orElse(),
  }) {
    if (float != null) {
      return float(this);
    }
    return orElse();
  }
}

abstract class OperationValue_Float implements OperationValue {
  const factory OperationValue_Float(final double field0) =
      _$OperationValue_Float;

  @override
  double get field0;
  @JsonKey(ignore: true)
  _$$OperationValue_FloatCopyWith<_$OperationValue_Float> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OperationValue_StringCopyWith<$Res> {
  factory _$$OperationValue_StringCopyWith(_$OperationValue_String value,
          $Res Function(_$OperationValue_String) then) =
      __$$OperationValue_StringCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$OperationValue_StringCopyWithImpl<$Res>
    extends _$OperationValueCopyWithImpl<$Res, _$OperationValue_String>
    implements _$$OperationValue_StringCopyWith<$Res> {
  __$$OperationValue_StringCopyWithImpl(_$OperationValue_String _value,
      $Res Function(_$OperationValue_String) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$OperationValue_String(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OperationValue_String implements OperationValue_String {
  const _$OperationValue_String(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'OperationValue.string(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationValue_String &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationValue_StringCopyWith<_$OperationValue_String> get copyWith =>
      __$$OperationValue_StringCopyWithImpl<_$OperationValue_String>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool field0) boolean,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(String field0) relation,
    required TResult Function(List<String> field0) relationList,
    required TResult Function(String field0) pinnedRelation,
    required TResult Function(List<String> field0) pinnedRelationList,
  }) {
    return string(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool field0)? boolean,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(String field0)? relation,
    TResult? Function(List<String> field0)? relationList,
    TResult? Function(String field0)? pinnedRelation,
    TResult? Function(List<String> field0)? pinnedRelationList,
  }) {
    return string?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool field0)? boolean,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(String field0)? relation,
    TResult Function(List<String> field0)? relationList,
    TResult Function(String field0)? pinnedRelation,
    TResult Function(List<String> field0)? pinnedRelationList,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OperationValue_Boolean value) boolean,
    required TResult Function(OperationValue_Integer value) integer,
    required TResult Function(OperationValue_Float value) float,
    required TResult Function(OperationValue_String value) string,
    required TResult Function(OperationValue_Relation value) relation,
    required TResult Function(OperationValue_RelationList value) relationList,
    required TResult Function(OperationValue_PinnedRelation value)
        pinnedRelation,
    required TResult Function(OperationValue_PinnedRelationList value)
        pinnedRelationList,
  }) {
    return string(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OperationValue_Boolean value)? boolean,
    TResult? Function(OperationValue_Integer value)? integer,
    TResult? Function(OperationValue_Float value)? float,
    TResult? Function(OperationValue_String value)? string,
    TResult? Function(OperationValue_Relation value)? relation,
    TResult? Function(OperationValue_RelationList value)? relationList,
    TResult? Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult? Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
  }) {
    return string?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OperationValue_Boolean value)? boolean,
    TResult Function(OperationValue_Integer value)? integer,
    TResult Function(OperationValue_Float value)? float,
    TResult Function(OperationValue_String value)? string,
    TResult Function(OperationValue_Relation value)? relation,
    TResult Function(OperationValue_RelationList value)? relationList,
    TResult Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(this);
    }
    return orElse();
  }
}

abstract class OperationValue_String implements OperationValue {
  const factory OperationValue_String(final String field0) =
      _$OperationValue_String;

  @override
  String get field0;
  @JsonKey(ignore: true)
  _$$OperationValue_StringCopyWith<_$OperationValue_String> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OperationValue_RelationCopyWith<$Res> {
  factory _$$OperationValue_RelationCopyWith(_$OperationValue_Relation value,
          $Res Function(_$OperationValue_Relation) then) =
      __$$OperationValue_RelationCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$OperationValue_RelationCopyWithImpl<$Res>
    extends _$OperationValueCopyWithImpl<$Res, _$OperationValue_Relation>
    implements _$$OperationValue_RelationCopyWith<$Res> {
  __$$OperationValue_RelationCopyWithImpl(_$OperationValue_Relation _value,
      $Res Function(_$OperationValue_Relation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$OperationValue_Relation(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OperationValue_Relation implements OperationValue_Relation {
  const _$OperationValue_Relation(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'OperationValue.relation(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationValue_Relation &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationValue_RelationCopyWith<_$OperationValue_Relation> get copyWith =>
      __$$OperationValue_RelationCopyWithImpl<_$OperationValue_Relation>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool field0) boolean,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(String field0) relation,
    required TResult Function(List<String> field0) relationList,
    required TResult Function(String field0) pinnedRelation,
    required TResult Function(List<String> field0) pinnedRelationList,
  }) {
    return relation(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool field0)? boolean,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(String field0)? relation,
    TResult? Function(List<String> field0)? relationList,
    TResult? Function(String field0)? pinnedRelation,
    TResult? Function(List<String> field0)? pinnedRelationList,
  }) {
    return relation?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool field0)? boolean,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(String field0)? relation,
    TResult Function(List<String> field0)? relationList,
    TResult Function(String field0)? pinnedRelation,
    TResult Function(List<String> field0)? pinnedRelationList,
    required TResult orElse(),
  }) {
    if (relation != null) {
      return relation(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OperationValue_Boolean value) boolean,
    required TResult Function(OperationValue_Integer value) integer,
    required TResult Function(OperationValue_Float value) float,
    required TResult Function(OperationValue_String value) string,
    required TResult Function(OperationValue_Relation value) relation,
    required TResult Function(OperationValue_RelationList value) relationList,
    required TResult Function(OperationValue_PinnedRelation value)
        pinnedRelation,
    required TResult Function(OperationValue_PinnedRelationList value)
        pinnedRelationList,
  }) {
    return relation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OperationValue_Boolean value)? boolean,
    TResult? Function(OperationValue_Integer value)? integer,
    TResult? Function(OperationValue_Float value)? float,
    TResult? Function(OperationValue_String value)? string,
    TResult? Function(OperationValue_Relation value)? relation,
    TResult? Function(OperationValue_RelationList value)? relationList,
    TResult? Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult? Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
  }) {
    return relation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OperationValue_Boolean value)? boolean,
    TResult Function(OperationValue_Integer value)? integer,
    TResult Function(OperationValue_Float value)? float,
    TResult Function(OperationValue_String value)? string,
    TResult Function(OperationValue_Relation value)? relation,
    TResult Function(OperationValue_RelationList value)? relationList,
    TResult Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
    required TResult orElse(),
  }) {
    if (relation != null) {
      return relation(this);
    }
    return orElse();
  }
}

abstract class OperationValue_Relation implements OperationValue {
  const factory OperationValue_Relation(final String field0) =
      _$OperationValue_Relation;

  @override
  String get field0;
  @JsonKey(ignore: true)
  _$$OperationValue_RelationCopyWith<_$OperationValue_Relation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OperationValue_RelationListCopyWith<$Res> {
  factory _$$OperationValue_RelationListCopyWith(
          _$OperationValue_RelationList value,
          $Res Function(_$OperationValue_RelationList) then) =
      __$$OperationValue_RelationListCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> field0});
}

/// @nodoc
class __$$OperationValue_RelationListCopyWithImpl<$Res>
    extends _$OperationValueCopyWithImpl<$Res, _$OperationValue_RelationList>
    implements _$$OperationValue_RelationListCopyWith<$Res> {
  __$$OperationValue_RelationListCopyWithImpl(
      _$OperationValue_RelationList _value,
      $Res Function(_$OperationValue_RelationList) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$OperationValue_RelationList(
      null == field0
          ? _value._field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$OperationValue_RelationList implements OperationValue_RelationList {
  const _$OperationValue_RelationList(final List<String> field0)
      : _field0 = field0;

  final List<String> _field0;
  @override
  List<String> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'OperationValue.relationList(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationValue_RelationList &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationValue_RelationListCopyWith<_$OperationValue_RelationList>
      get copyWith => __$$OperationValue_RelationListCopyWithImpl<
          _$OperationValue_RelationList>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool field0) boolean,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(String field0) relation,
    required TResult Function(List<String> field0) relationList,
    required TResult Function(String field0) pinnedRelation,
    required TResult Function(List<String> field0) pinnedRelationList,
  }) {
    return relationList(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool field0)? boolean,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(String field0)? relation,
    TResult? Function(List<String> field0)? relationList,
    TResult? Function(String field0)? pinnedRelation,
    TResult? Function(List<String> field0)? pinnedRelationList,
  }) {
    return relationList?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool field0)? boolean,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(String field0)? relation,
    TResult Function(List<String> field0)? relationList,
    TResult Function(String field0)? pinnedRelation,
    TResult Function(List<String> field0)? pinnedRelationList,
    required TResult orElse(),
  }) {
    if (relationList != null) {
      return relationList(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OperationValue_Boolean value) boolean,
    required TResult Function(OperationValue_Integer value) integer,
    required TResult Function(OperationValue_Float value) float,
    required TResult Function(OperationValue_String value) string,
    required TResult Function(OperationValue_Relation value) relation,
    required TResult Function(OperationValue_RelationList value) relationList,
    required TResult Function(OperationValue_PinnedRelation value)
        pinnedRelation,
    required TResult Function(OperationValue_PinnedRelationList value)
        pinnedRelationList,
  }) {
    return relationList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OperationValue_Boolean value)? boolean,
    TResult? Function(OperationValue_Integer value)? integer,
    TResult? Function(OperationValue_Float value)? float,
    TResult? Function(OperationValue_String value)? string,
    TResult? Function(OperationValue_Relation value)? relation,
    TResult? Function(OperationValue_RelationList value)? relationList,
    TResult? Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult? Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
  }) {
    return relationList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OperationValue_Boolean value)? boolean,
    TResult Function(OperationValue_Integer value)? integer,
    TResult Function(OperationValue_Float value)? float,
    TResult Function(OperationValue_String value)? string,
    TResult Function(OperationValue_Relation value)? relation,
    TResult Function(OperationValue_RelationList value)? relationList,
    TResult Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
    required TResult orElse(),
  }) {
    if (relationList != null) {
      return relationList(this);
    }
    return orElse();
  }
}

abstract class OperationValue_RelationList implements OperationValue {
  const factory OperationValue_RelationList(final List<String> field0) =
      _$OperationValue_RelationList;

  @override
  List<String> get field0;
  @JsonKey(ignore: true)
  _$$OperationValue_RelationListCopyWith<_$OperationValue_RelationList>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OperationValue_PinnedRelationCopyWith<$Res> {
  factory _$$OperationValue_PinnedRelationCopyWith(
          _$OperationValue_PinnedRelation value,
          $Res Function(_$OperationValue_PinnedRelation) then) =
      __$$OperationValue_PinnedRelationCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$OperationValue_PinnedRelationCopyWithImpl<$Res>
    extends _$OperationValueCopyWithImpl<$Res, _$OperationValue_PinnedRelation>
    implements _$$OperationValue_PinnedRelationCopyWith<$Res> {
  __$$OperationValue_PinnedRelationCopyWithImpl(
      _$OperationValue_PinnedRelation _value,
      $Res Function(_$OperationValue_PinnedRelation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$OperationValue_PinnedRelation(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OperationValue_PinnedRelation implements OperationValue_PinnedRelation {
  const _$OperationValue_PinnedRelation(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'OperationValue.pinnedRelation(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationValue_PinnedRelation &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationValue_PinnedRelationCopyWith<_$OperationValue_PinnedRelation>
      get copyWith => __$$OperationValue_PinnedRelationCopyWithImpl<
          _$OperationValue_PinnedRelation>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool field0) boolean,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(String field0) relation,
    required TResult Function(List<String> field0) relationList,
    required TResult Function(String field0) pinnedRelation,
    required TResult Function(List<String> field0) pinnedRelationList,
  }) {
    return pinnedRelation(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool field0)? boolean,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(String field0)? relation,
    TResult? Function(List<String> field0)? relationList,
    TResult? Function(String field0)? pinnedRelation,
    TResult? Function(List<String> field0)? pinnedRelationList,
  }) {
    return pinnedRelation?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool field0)? boolean,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(String field0)? relation,
    TResult Function(List<String> field0)? relationList,
    TResult Function(String field0)? pinnedRelation,
    TResult Function(List<String> field0)? pinnedRelationList,
    required TResult orElse(),
  }) {
    if (pinnedRelation != null) {
      return pinnedRelation(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OperationValue_Boolean value) boolean,
    required TResult Function(OperationValue_Integer value) integer,
    required TResult Function(OperationValue_Float value) float,
    required TResult Function(OperationValue_String value) string,
    required TResult Function(OperationValue_Relation value) relation,
    required TResult Function(OperationValue_RelationList value) relationList,
    required TResult Function(OperationValue_PinnedRelation value)
        pinnedRelation,
    required TResult Function(OperationValue_PinnedRelationList value)
        pinnedRelationList,
  }) {
    return pinnedRelation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OperationValue_Boolean value)? boolean,
    TResult? Function(OperationValue_Integer value)? integer,
    TResult? Function(OperationValue_Float value)? float,
    TResult? Function(OperationValue_String value)? string,
    TResult? Function(OperationValue_Relation value)? relation,
    TResult? Function(OperationValue_RelationList value)? relationList,
    TResult? Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult? Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
  }) {
    return pinnedRelation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OperationValue_Boolean value)? boolean,
    TResult Function(OperationValue_Integer value)? integer,
    TResult Function(OperationValue_Float value)? float,
    TResult Function(OperationValue_String value)? string,
    TResult Function(OperationValue_Relation value)? relation,
    TResult Function(OperationValue_RelationList value)? relationList,
    TResult Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
    required TResult orElse(),
  }) {
    if (pinnedRelation != null) {
      return pinnedRelation(this);
    }
    return orElse();
  }
}

abstract class OperationValue_PinnedRelation implements OperationValue {
  const factory OperationValue_PinnedRelation(final String field0) =
      _$OperationValue_PinnedRelation;

  @override
  String get field0;
  @JsonKey(ignore: true)
  _$$OperationValue_PinnedRelationCopyWith<_$OperationValue_PinnedRelation>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OperationValue_PinnedRelationListCopyWith<$Res> {
  factory _$$OperationValue_PinnedRelationListCopyWith(
          _$OperationValue_PinnedRelationList value,
          $Res Function(_$OperationValue_PinnedRelationList) then) =
      __$$OperationValue_PinnedRelationListCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> field0});
}

/// @nodoc
class __$$OperationValue_PinnedRelationListCopyWithImpl<$Res>
    extends _$OperationValueCopyWithImpl<$Res,
        _$OperationValue_PinnedRelationList>
    implements _$$OperationValue_PinnedRelationListCopyWith<$Res> {
  __$$OperationValue_PinnedRelationListCopyWithImpl(
      _$OperationValue_PinnedRelationList _value,
      $Res Function(_$OperationValue_PinnedRelationList) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$OperationValue_PinnedRelationList(
      null == field0
          ? _value._field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$OperationValue_PinnedRelationList
    implements OperationValue_PinnedRelationList {
  const _$OperationValue_PinnedRelationList(final List<String> field0)
      : _field0 = field0;

  final List<String> _field0;
  @override
  List<String> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'OperationValue.pinnedRelationList(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperationValue_PinnedRelationList &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OperationValue_PinnedRelationListCopyWith<
          _$OperationValue_PinnedRelationList>
      get copyWith => __$$OperationValue_PinnedRelationListCopyWithImpl<
          _$OperationValue_PinnedRelationList>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool field0) boolean,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(String field0) relation,
    required TResult Function(List<String> field0) relationList,
    required TResult Function(String field0) pinnedRelation,
    required TResult Function(List<String> field0) pinnedRelationList,
  }) {
    return pinnedRelationList(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool field0)? boolean,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(String field0)? relation,
    TResult? Function(List<String> field0)? relationList,
    TResult? Function(String field0)? pinnedRelation,
    TResult? Function(List<String> field0)? pinnedRelationList,
  }) {
    return pinnedRelationList?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool field0)? boolean,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(String field0)? relation,
    TResult Function(List<String> field0)? relationList,
    TResult Function(String field0)? pinnedRelation,
    TResult Function(List<String> field0)? pinnedRelationList,
    required TResult orElse(),
  }) {
    if (pinnedRelationList != null) {
      return pinnedRelationList(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OperationValue_Boolean value) boolean,
    required TResult Function(OperationValue_Integer value) integer,
    required TResult Function(OperationValue_Float value) float,
    required TResult Function(OperationValue_String value) string,
    required TResult Function(OperationValue_Relation value) relation,
    required TResult Function(OperationValue_RelationList value) relationList,
    required TResult Function(OperationValue_PinnedRelation value)
        pinnedRelation,
    required TResult Function(OperationValue_PinnedRelationList value)
        pinnedRelationList,
  }) {
    return pinnedRelationList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OperationValue_Boolean value)? boolean,
    TResult? Function(OperationValue_Integer value)? integer,
    TResult? Function(OperationValue_Float value)? float,
    TResult? Function(OperationValue_String value)? string,
    TResult? Function(OperationValue_Relation value)? relation,
    TResult? Function(OperationValue_RelationList value)? relationList,
    TResult? Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult? Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
  }) {
    return pinnedRelationList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OperationValue_Boolean value)? boolean,
    TResult Function(OperationValue_Integer value)? integer,
    TResult Function(OperationValue_Float value)? float,
    TResult Function(OperationValue_String value)? string,
    TResult Function(OperationValue_Relation value)? relation,
    TResult Function(OperationValue_RelationList value)? relationList,
    TResult Function(OperationValue_PinnedRelation value)? pinnedRelation,
    TResult Function(OperationValue_PinnedRelationList value)?
        pinnedRelationList,
    required TResult orElse(),
  }) {
    if (pinnedRelationList != null) {
      return pinnedRelationList(this);
    }
    return orElse();
  }
}

abstract class OperationValue_PinnedRelationList implements OperationValue {
  const factory OperationValue_PinnedRelationList(final List<String> field0) =
      _$OperationValue_PinnedRelationList;

  @override
  List<String> get field0;
  @JsonKey(ignore: true)
  _$$OperationValue_PinnedRelationListCopyWith<
          _$OperationValue_PinnedRelationList>
      get copyWith => throw _privateConstructorUsedError;
}
