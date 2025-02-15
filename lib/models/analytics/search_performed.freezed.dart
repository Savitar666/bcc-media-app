// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_performed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SearchPerformedEvent _$SearchPerformedEventFromJson(Map<String, dynamic> json) {
  return _SearchPerformedEvent.fromJson(json);
}

/// @nodoc
mixin _$SearchPerformedEvent {
  String get searchText => throw _privateConstructorUsedError;
  int get searchLatency => throw _privateConstructorUsedError;
  int get searchResultCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchPerformedEventCopyWith<SearchPerformedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchPerformedEventCopyWith<$Res> {
  factory $SearchPerformedEventCopyWith(SearchPerformedEvent value,
          $Res Function(SearchPerformedEvent) then) =
      _$SearchPerformedEventCopyWithImpl<$Res, SearchPerformedEvent>;
  @useResult
  $Res call({String searchText, int searchLatency, int searchResultCount});
}

/// @nodoc
class _$SearchPerformedEventCopyWithImpl<$Res,
        $Val extends SearchPerformedEvent>
    implements $SearchPerformedEventCopyWith<$Res> {
  _$SearchPerformedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchText = null,
    Object? searchLatency = null,
    Object? searchResultCount = null,
  }) {
    return _then(_value.copyWith(
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      searchLatency: null == searchLatency
          ? _value.searchLatency
          : searchLatency // ignore: cast_nullable_to_non_nullable
              as int,
      searchResultCount: null == searchResultCount
          ? _value.searchResultCount
          : searchResultCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SearchPerformedEventCopyWith<$Res>
    implements $SearchPerformedEventCopyWith<$Res> {
  factory _$$_SearchPerformedEventCopyWith(_$_SearchPerformedEvent value,
          $Res Function(_$_SearchPerformedEvent) then) =
      __$$_SearchPerformedEventCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String searchText, int searchLatency, int searchResultCount});
}

/// @nodoc
class __$$_SearchPerformedEventCopyWithImpl<$Res>
    extends _$SearchPerformedEventCopyWithImpl<$Res, _$_SearchPerformedEvent>
    implements _$$_SearchPerformedEventCopyWith<$Res> {
  __$$_SearchPerformedEventCopyWithImpl(_$_SearchPerformedEvent _value,
      $Res Function(_$_SearchPerformedEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchText = null,
    Object? searchLatency = null,
    Object? searchResultCount = null,
  }) {
    return _then(_$_SearchPerformedEvent(
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      searchLatency: null == searchLatency
          ? _value.searchLatency
          : searchLatency // ignore: cast_nullable_to_non_nullable
              as int,
      searchResultCount: null == searchResultCount
          ? _value.searchResultCount
          : searchResultCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SearchPerformedEvent implements _SearchPerformedEvent {
  const _$_SearchPerformedEvent(
      {required this.searchText,
      required this.searchLatency,
      required this.searchResultCount});

  factory _$_SearchPerformedEvent.fromJson(Map<String, dynamic> json) =>
      _$$_SearchPerformedEventFromJson(json);

  @override
  final String searchText;
  @override
  final int searchLatency;
  @override
  final int searchResultCount;

  @override
  String toString() {
    return 'SearchPerformedEvent(searchText: $searchText, searchLatency: $searchLatency, searchResultCount: $searchResultCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchPerformedEvent &&
            (identical(other.searchText, searchText) ||
                other.searchText == searchText) &&
            (identical(other.searchLatency, searchLatency) ||
                other.searchLatency == searchLatency) &&
            (identical(other.searchResultCount, searchResultCount) ||
                other.searchResultCount == searchResultCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, searchText, searchLatency, searchResultCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SearchPerformedEventCopyWith<_$_SearchPerformedEvent> get copyWith =>
      __$$_SearchPerformedEventCopyWithImpl<_$_SearchPerformedEvent>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SearchPerformedEventToJson(
      this,
    );
  }
}

abstract class _SearchPerformedEvent implements SearchPerformedEvent {
  const factory _SearchPerformedEvent(
      {required final String searchText,
      required final int searchLatency,
      required final int searchResultCount}) = _$_SearchPerformedEvent;

  factory _SearchPerformedEvent.fromJson(Map<String, dynamic> json) =
      _$_SearchPerformedEvent.fromJson;

  @override
  String get searchText;
  @override
  int get searchLatency;
  @override
  int get searchResultCount;
  @override
  @JsonKey(ignore: true)
  _$$_SearchPerformedEventCopyWith<_$_SearchPerformedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}
