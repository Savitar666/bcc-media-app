// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_clicked.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChapterClickedEvent _$ChapterClickedEventFromJson(Map<String, dynamic> json) {
  return _ChapterClickedEvent.fromJson(json);
}

/// @nodoc
mixin _$ChapterClickedEvent {
  String get elementType => throw _privateConstructorUsedError;
  String get elementId => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  int get chapterStart => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChapterClickedEventCopyWith<ChapterClickedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterClickedEventCopyWith<$Res> {
  factory $ChapterClickedEventCopyWith(
          ChapterClickedEvent value, $Res Function(ChapterClickedEvent) then) =
      _$ChapterClickedEventCopyWithImpl<$Res, ChapterClickedEvent>;
  @useResult
  $Res call(
      {String elementType,
      String elementId,
      String chapterId,
      int chapterStart});
}

/// @nodoc
class _$ChapterClickedEventCopyWithImpl<$Res, $Val extends ChapterClickedEvent>
    implements $ChapterClickedEventCopyWith<$Res> {
  _$ChapterClickedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elementType = null,
    Object? elementId = null,
    Object? chapterId = null,
    Object? chapterStart = null,
  }) {
    return _then(_value.copyWith(
      elementType: null == elementType
          ? _value.elementType
          : elementType // ignore: cast_nullable_to_non_nullable
              as String,
      elementId: null == elementId
          ? _value.elementId
          : elementId // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      chapterStart: null == chapterStart
          ? _value.chapterStart
          : chapterStart // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChapterClickedEventCopyWith<$Res>
    implements $ChapterClickedEventCopyWith<$Res> {
  factory _$$_ChapterClickedEventCopyWith(_$_ChapterClickedEvent value,
          $Res Function(_$_ChapterClickedEvent) then) =
      __$$_ChapterClickedEventCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String elementType,
      String elementId,
      String chapterId,
      int chapterStart});
}

/// @nodoc
class __$$_ChapterClickedEventCopyWithImpl<$Res>
    extends _$ChapterClickedEventCopyWithImpl<$Res, _$_ChapterClickedEvent>
    implements _$$_ChapterClickedEventCopyWith<$Res> {
  __$$_ChapterClickedEventCopyWithImpl(_$_ChapterClickedEvent _value,
      $Res Function(_$_ChapterClickedEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elementType = null,
    Object? elementId = null,
    Object? chapterId = null,
    Object? chapterStart = null,
  }) {
    return _then(_$_ChapterClickedEvent(
      elementType: null == elementType
          ? _value.elementType
          : elementType // ignore: cast_nullable_to_non_nullable
              as String,
      elementId: null == elementId
          ? _value.elementId
          : elementId // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      chapterStart: null == chapterStart
          ? _value.chapterStart
          : chapterStart // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChapterClickedEvent implements _ChapterClickedEvent {
  const _$_ChapterClickedEvent(
      {required this.elementType,
      required this.elementId,
      required this.chapterId,
      required this.chapterStart});

  factory _$_ChapterClickedEvent.fromJson(Map<String, dynamic> json) =>
      _$$_ChapterClickedEventFromJson(json);

  @override
  final String elementType;
  @override
  final String elementId;
  @override
  final String chapterId;
  @override
  final int chapterStart;

  @override
  String toString() {
    return 'ChapterClickedEvent(elementType: $elementType, elementId: $elementId, chapterId: $chapterId, chapterStart: $chapterStart)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChapterClickedEvent &&
            (identical(other.elementType, elementType) ||
                other.elementType == elementType) &&
            (identical(other.elementId, elementId) ||
                other.elementId == elementId) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.chapterStart, chapterStart) ||
                other.chapterStart == chapterStart));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, elementType, elementId, chapterId, chapterStart);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChapterClickedEventCopyWith<_$_ChapterClickedEvent> get copyWith =>
      __$$_ChapterClickedEventCopyWithImpl<_$_ChapterClickedEvent>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChapterClickedEventToJson(
      this,
    );
  }
}

abstract class _ChapterClickedEvent implements ChapterClickedEvent {
  const factory _ChapterClickedEvent(
      {required final String elementType,
      required final String elementId,
      required final String chapterId,
      required final int chapterStart}) = _$_ChapterClickedEvent;

  factory _ChapterClickedEvent.fromJson(Map<String, dynamic> json) =
      _$_ChapterClickedEvent.fromJson;

  @override
  String get elementType;
  @override
  String get elementId;
  @override
  String get chapterId;
  @override
  int get chapterStart;
  @override
  @JsonKey(ignore: true)
  _$$_ChapterClickedEventCopyWith<_$_ChapterClickedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}
