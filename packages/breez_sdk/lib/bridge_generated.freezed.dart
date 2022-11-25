// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bridge_generated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$InputType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrlPay,
    required TResult Function(LnUrlRequestData field0) lnUrlWithdraw,
    required TResult Function(LnUrlRequestData field0) lnUrlAuth,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrlPay,
    TResult? Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult? Function(LnUrlRequestData field0)? lnUrlAuth,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrlPay,
    TResult Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult Function(LnUrlRequestData field0)? lnUrlAuth,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InputTypeCopyWith<$Res> {
  factory $InputTypeCopyWith(InputType value, $Res Function(InputType) then) =
      _$InputTypeCopyWithImpl<$Res, InputType>;
}

/// @nodoc
class _$InputTypeCopyWithImpl<$Res, $Val extends InputType>
    implements $InputTypeCopyWith<$Res> {
  _$InputTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InputType_BitcoinAddressCopyWith<$Res> {
  factory _$$InputType_BitcoinAddressCopyWith(_$InputType_BitcoinAddress value,
          $Res Function(_$InputType_BitcoinAddress) then) =
      __$$InputType_BitcoinAddressCopyWithImpl<$Res>;
  @useResult
  $Res call({BitcoinAddressData field0});
}

/// @nodoc
class __$$InputType_BitcoinAddressCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_BitcoinAddress>
    implements _$$InputType_BitcoinAddressCopyWith<$Res> {
  __$$InputType_BitcoinAddressCopyWithImpl(_$InputType_BitcoinAddress _value,
      $Res Function(_$InputType_BitcoinAddress) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$InputType_BitcoinAddress(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as BitcoinAddressData,
    ));
  }
}

/// @nodoc

class _$InputType_BitcoinAddress implements InputType_BitcoinAddress {
  const _$InputType_BitcoinAddress(this.field0);

  @override
  final BitcoinAddressData field0;

  @override
  String toString() {
    return 'InputType.bitcoinAddress(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_BitcoinAddress &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_BitcoinAddressCopyWith<_$InputType_BitcoinAddress>
      get copyWith =>
          __$$InputType_BitcoinAddressCopyWithImpl<_$InputType_BitcoinAddress>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrlPay,
    required TResult Function(LnUrlRequestData field0) lnUrlWithdraw,
    required TResult Function(LnUrlRequestData field0) lnUrlAuth,
  }) {
    return bitcoinAddress(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrlPay,
    TResult? Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult? Function(LnUrlRequestData field0)? lnUrlAuth,
  }) {
    return bitcoinAddress?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrlPay,
    TResult Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult Function(LnUrlRequestData field0)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
  }) {
    return bitcoinAddress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
  }) {
    return bitcoinAddress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(this);
    }
    return orElse();
  }
}

abstract class InputType_BitcoinAddress implements InputType {
  const factory InputType_BitcoinAddress(final BitcoinAddressData field0) =
      _$InputType_BitcoinAddress;

  BitcoinAddressData get field0;
  @JsonKey(ignore: true)
  _$$InputType_BitcoinAddressCopyWith<_$InputType_BitcoinAddress>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_Bolt11CopyWith<$Res> {
  factory _$$InputType_Bolt11CopyWith(
          _$InputType_Bolt11 value, $Res Function(_$InputType_Bolt11) then) =
      __$$InputType_Bolt11CopyWithImpl<$Res>;
  @useResult
  $Res call({LNInvoice field0});
}

/// @nodoc
class __$$InputType_Bolt11CopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_Bolt11>
    implements _$$InputType_Bolt11CopyWith<$Res> {
  __$$InputType_Bolt11CopyWithImpl(
      _$InputType_Bolt11 _value, $Res Function(_$InputType_Bolt11) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$InputType_Bolt11(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as LNInvoice,
    ));
  }
}

/// @nodoc

class _$InputType_Bolt11 implements InputType_Bolt11 {
  const _$InputType_Bolt11(this.field0);

  @override
  final LNInvoice field0;

  @override
  String toString() {
    return 'InputType.bolt11(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_Bolt11 &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_Bolt11CopyWith<_$InputType_Bolt11> get copyWith =>
      __$$InputType_Bolt11CopyWithImpl<_$InputType_Bolt11>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrlPay,
    required TResult Function(LnUrlRequestData field0) lnUrlWithdraw,
    required TResult Function(LnUrlRequestData field0) lnUrlAuth,
  }) {
    return bolt11(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrlPay,
    TResult? Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult? Function(LnUrlRequestData field0)? lnUrlAuth,
  }) {
    return bolt11?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrlPay,
    TResult Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult Function(LnUrlRequestData field0)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (bolt11 != null) {
      return bolt11(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
  }) {
    return bolt11(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
  }) {
    return bolt11?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (bolt11 != null) {
      return bolt11(this);
    }
    return orElse();
  }
}

abstract class InputType_Bolt11 implements InputType {
  const factory InputType_Bolt11(final LNInvoice field0) = _$InputType_Bolt11;

  LNInvoice get field0;
  @JsonKey(ignore: true)
  _$$InputType_Bolt11CopyWith<_$InputType_Bolt11> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_NodeIdCopyWith<$Res> {
  factory _$$InputType_NodeIdCopyWith(
          _$InputType_NodeId value, $Res Function(_$InputType_NodeId) then) =
      __$$InputType_NodeIdCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$InputType_NodeIdCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_NodeId>
    implements _$$InputType_NodeIdCopyWith<$Res> {
  __$$InputType_NodeIdCopyWithImpl(
      _$InputType_NodeId _value, $Res Function(_$InputType_NodeId) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$InputType_NodeId(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_NodeId implements InputType_NodeId {
  const _$InputType_NodeId(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'InputType.nodeId(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_NodeId &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_NodeIdCopyWith<_$InputType_NodeId> get copyWith =>
      __$$InputType_NodeIdCopyWithImpl<_$InputType_NodeId>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrlPay,
    required TResult Function(LnUrlRequestData field0) lnUrlWithdraw,
    required TResult Function(LnUrlRequestData field0) lnUrlAuth,
  }) {
    return nodeId(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrlPay,
    TResult? Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult? Function(LnUrlRequestData field0)? lnUrlAuth,
  }) {
    return nodeId?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrlPay,
    TResult Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult Function(LnUrlRequestData field0)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (nodeId != null) {
      return nodeId(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
  }) {
    return nodeId(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
  }) {
    return nodeId?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (nodeId != null) {
      return nodeId(this);
    }
    return orElse();
  }
}

abstract class InputType_NodeId implements InputType {
  const factory InputType_NodeId(final String field0) = _$InputType_NodeId;

  String get field0;
  @JsonKey(ignore: true)
  _$$InputType_NodeIdCopyWith<_$InputType_NodeId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_UrlCopyWith<$Res> {
  factory _$$InputType_UrlCopyWith(
          _$InputType_Url value, $Res Function(_$InputType_Url) then) =
      __$$InputType_UrlCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$InputType_UrlCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_Url>
    implements _$$InputType_UrlCopyWith<$Res> {
  __$$InputType_UrlCopyWithImpl(
      _$InputType_Url _value, $Res Function(_$InputType_Url) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$InputType_Url(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_Url implements InputType_Url {
  const _$InputType_Url(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'InputType.url(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_Url &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_UrlCopyWith<_$InputType_Url> get copyWith =>
      __$$InputType_UrlCopyWithImpl<_$InputType_Url>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrlPay,
    required TResult Function(LnUrlRequestData field0) lnUrlWithdraw,
    required TResult Function(LnUrlRequestData field0) lnUrlAuth,
  }) {
    return url(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrlPay,
    TResult? Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult? Function(LnUrlRequestData field0)? lnUrlAuth,
  }) {
    return url?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrlPay,
    TResult Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult Function(LnUrlRequestData field0)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
  }) {
    return url(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
  }) {
    return url?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(this);
    }
    return orElse();
  }
}

abstract class InputType_Url implements InputType {
  const factory InputType_Url(final String field0) = _$InputType_Url;

  String get field0;
  @JsonKey(ignore: true)
  _$$InputType_UrlCopyWith<_$InputType_Url> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlPayCopyWith<$Res> {
  factory _$$InputType_LnUrlPayCopyWith(_$InputType_LnUrlPay value,
          $Res Function(_$InputType_LnUrlPay) then) =
      __$$InputType_LnUrlPayCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlRequestData field0});

  $LnUrlRequestDataCopyWith<$Res> get field0;
}

/// @nodoc
class __$$InputType_LnUrlPayCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_LnUrlPay>
    implements _$$InputType_LnUrlPayCopyWith<$Res> {
  __$$InputType_LnUrlPayCopyWithImpl(
      _$InputType_LnUrlPay _value, $Res Function(_$InputType_LnUrlPay) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$InputType_LnUrlPay(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as LnUrlRequestData,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $LnUrlRequestDataCopyWith<$Res> get field0 {
    return $LnUrlRequestDataCopyWith<$Res>(_value.field0, (value) {
      return _then(_value.copyWith(field0: value));
    });
  }
}

/// @nodoc

class _$InputType_LnUrlPay implements InputType_LnUrlPay {
  const _$InputType_LnUrlPay(this.field0);

  @override
  final LnUrlRequestData field0;

  @override
  String toString() {
    return 'InputType.lnUrlPay(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlPay &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlPayCopyWith<_$InputType_LnUrlPay> get copyWith =>
      __$$InputType_LnUrlPayCopyWithImpl<_$InputType_LnUrlPay>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrlPay,
    required TResult Function(LnUrlRequestData field0) lnUrlWithdraw,
    required TResult Function(LnUrlRequestData field0) lnUrlAuth,
  }) {
    return lnUrlPay(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrlPay,
    TResult? Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult? Function(LnUrlRequestData field0)? lnUrlAuth,
  }) {
    return lnUrlPay?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrlPay,
    TResult Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult Function(LnUrlRequestData field0)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (lnUrlPay != null) {
      return lnUrlPay(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
  }) {
    return lnUrlPay(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
  }) {
    return lnUrlPay?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (lnUrlPay != null) {
      return lnUrlPay(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlPay implements InputType {
  const factory InputType_LnUrlPay(final LnUrlRequestData field0) =
      _$InputType_LnUrlPay;

  LnUrlRequestData get field0;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlPayCopyWith<_$InputType_LnUrlPay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlWithdrawCopyWith<$Res> {
  factory _$$InputType_LnUrlWithdrawCopyWith(_$InputType_LnUrlWithdraw value,
          $Res Function(_$InputType_LnUrlWithdraw) then) =
      __$$InputType_LnUrlWithdrawCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlRequestData field0});

  $LnUrlRequestDataCopyWith<$Res> get field0;
}

/// @nodoc
class __$$InputType_LnUrlWithdrawCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_LnUrlWithdraw>
    implements _$$InputType_LnUrlWithdrawCopyWith<$Res> {
  __$$InputType_LnUrlWithdrawCopyWithImpl(_$InputType_LnUrlWithdraw _value,
      $Res Function(_$InputType_LnUrlWithdraw) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$InputType_LnUrlWithdraw(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as LnUrlRequestData,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $LnUrlRequestDataCopyWith<$Res> get field0 {
    return $LnUrlRequestDataCopyWith<$Res>(_value.field0, (value) {
      return _then(_value.copyWith(field0: value));
    });
  }
}

/// @nodoc

class _$InputType_LnUrlWithdraw implements InputType_LnUrlWithdraw {
  const _$InputType_LnUrlWithdraw(this.field0);

  @override
  final LnUrlRequestData field0;

  @override
  String toString() {
    return 'InputType.lnUrlWithdraw(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlWithdraw &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlWithdrawCopyWith<_$InputType_LnUrlWithdraw> get copyWith =>
      __$$InputType_LnUrlWithdrawCopyWithImpl<_$InputType_LnUrlWithdraw>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrlPay,
    required TResult Function(LnUrlRequestData field0) lnUrlWithdraw,
    required TResult Function(LnUrlRequestData field0) lnUrlAuth,
  }) {
    return lnUrlWithdraw(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrlPay,
    TResult? Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult? Function(LnUrlRequestData field0)? lnUrlAuth,
  }) {
    return lnUrlWithdraw?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrlPay,
    TResult Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult Function(LnUrlRequestData field0)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (lnUrlWithdraw != null) {
      return lnUrlWithdraw(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
  }) {
    return lnUrlWithdraw(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
  }) {
    return lnUrlWithdraw?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (lnUrlWithdraw != null) {
      return lnUrlWithdraw(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlWithdraw implements InputType {
  const factory InputType_LnUrlWithdraw(final LnUrlRequestData field0) =
      _$InputType_LnUrlWithdraw;

  LnUrlRequestData get field0;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlWithdrawCopyWith<_$InputType_LnUrlWithdraw> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlAuthCopyWith<$Res> {
  factory _$$InputType_LnUrlAuthCopyWith(_$InputType_LnUrlAuth value,
          $Res Function(_$InputType_LnUrlAuth) then) =
      __$$InputType_LnUrlAuthCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlRequestData field0});

  $LnUrlRequestDataCopyWith<$Res> get field0;
}

/// @nodoc
class __$$InputType_LnUrlAuthCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_LnUrlAuth>
    implements _$$InputType_LnUrlAuthCopyWith<$Res> {
  __$$InputType_LnUrlAuthCopyWithImpl(
      _$InputType_LnUrlAuth _value, $Res Function(_$InputType_LnUrlAuth) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$InputType_LnUrlAuth(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as LnUrlRequestData,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $LnUrlRequestDataCopyWith<$Res> get field0 {
    return $LnUrlRequestDataCopyWith<$Res>(_value.field0, (value) {
      return _then(_value.copyWith(field0: value));
    });
  }
}

/// @nodoc

class _$InputType_LnUrlAuth implements InputType_LnUrlAuth {
  const _$InputType_LnUrlAuth(this.field0);

  @override
  final LnUrlRequestData field0;

  @override
  String toString() {
    return 'InputType.lnUrlAuth(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlAuth &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlAuthCopyWith<_$InputType_LnUrlAuth> get copyWith =>
      __$$InputType_LnUrlAuthCopyWithImpl<_$InputType_LnUrlAuth>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrlPay,
    required TResult Function(LnUrlRequestData field0) lnUrlWithdraw,
    required TResult Function(LnUrlRequestData field0) lnUrlAuth,
  }) {
    return lnUrlAuth(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrlPay,
    TResult? Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult? Function(LnUrlRequestData field0)? lnUrlAuth,
  }) {
    return lnUrlAuth?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrlPay,
    TResult Function(LnUrlRequestData field0)? lnUrlWithdraw,
    TResult Function(LnUrlRequestData field0)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (lnUrlAuth != null) {
      return lnUrlAuth(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
    required TResult Function(InputType_LnUrlAuth value) lnUrlAuth,
  }) {
    return lnUrlAuth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult? Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult? Function(InputType_LnUrlAuth value)? lnUrlAuth,
  }) {
    return lnUrlAuth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    TResult Function(InputType_LnUrlAuth value)? lnUrlAuth,
    required TResult orElse(),
  }) {
    if (lnUrlAuth != null) {
      return lnUrlAuth(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlAuth implements InputType {
  const factory InputType_LnUrlAuth(final LnUrlRequestData field0) =
      _$InputType_LnUrlAuth;

  LnUrlRequestData get field0;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlAuthCopyWith<_$InputType_LnUrlAuth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LnUrlRequestData {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlPayRequestData field0) payRequest,
    required TResult Function(LnUrlWithdrawRequestData field0) withdrawRequest,
    required TResult Function(LnUrlAuthRequestData field0) authRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPayRequestData field0)? payRequest,
    TResult? Function(LnUrlWithdrawRequestData field0)? withdrawRequest,
    TResult? Function(LnUrlAuthRequestData field0)? authRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlPayRequestData field0)? payRequest,
    TResult Function(LnUrlWithdrawRequestData field0)? withdrawRequest,
    TResult Function(LnUrlAuthRequestData field0)? authRequest,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlRequestData_PayRequest value) payRequest,
    required TResult Function(LnUrlRequestData_WithdrawRequest value)
        withdrawRequest,
    required TResult Function(LnUrlRequestData_AuthRequest value) authRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlRequestData_PayRequest value)? payRequest,
    TResult? Function(LnUrlRequestData_WithdrawRequest value)? withdrawRequest,
    TResult? Function(LnUrlRequestData_AuthRequest value)? authRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlRequestData_PayRequest value)? payRequest,
    TResult Function(LnUrlRequestData_WithdrawRequest value)? withdrawRequest,
    TResult Function(LnUrlRequestData_AuthRequest value)? authRequest,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LnUrlRequestDataCopyWith<$Res> {
  factory $LnUrlRequestDataCopyWith(
          LnUrlRequestData value, $Res Function(LnUrlRequestData) then) =
      _$LnUrlRequestDataCopyWithImpl<$Res, LnUrlRequestData>;
}

/// @nodoc
class _$LnUrlRequestDataCopyWithImpl<$Res, $Val extends LnUrlRequestData>
    implements $LnUrlRequestDataCopyWith<$Res> {
  _$LnUrlRequestDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LnUrlRequestData_PayRequestCopyWith<$Res> {
  factory _$$LnUrlRequestData_PayRequestCopyWith(
          _$LnUrlRequestData_PayRequest value,
          $Res Function(_$LnUrlRequestData_PayRequest) then) =
      __$$LnUrlRequestData_PayRequestCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlPayRequestData field0});
}

/// @nodoc
class __$$LnUrlRequestData_PayRequestCopyWithImpl<$Res>
    extends _$LnUrlRequestDataCopyWithImpl<$Res, _$LnUrlRequestData_PayRequest>
    implements _$$LnUrlRequestData_PayRequestCopyWith<$Res> {
  __$$LnUrlRequestData_PayRequestCopyWithImpl(
      _$LnUrlRequestData_PayRequest _value,
      $Res Function(_$LnUrlRequestData_PayRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$LnUrlRequestData_PayRequest(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as LnUrlPayRequestData,
    ));
  }
}

/// @nodoc

class _$LnUrlRequestData_PayRequest implements LnUrlRequestData_PayRequest {
  const _$LnUrlRequestData_PayRequest(this.field0);

  @override
  final LnUrlPayRequestData field0;

  @override
  String toString() {
    return 'LnUrlRequestData.payRequest(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LnUrlRequestData_PayRequest &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LnUrlRequestData_PayRequestCopyWith<_$LnUrlRequestData_PayRequest>
      get copyWith => __$$LnUrlRequestData_PayRequestCopyWithImpl<
          _$LnUrlRequestData_PayRequest>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlPayRequestData field0) payRequest,
    required TResult Function(LnUrlWithdrawRequestData field0) withdrawRequest,
    required TResult Function(LnUrlAuthRequestData field0) authRequest,
  }) {
    return payRequest(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPayRequestData field0)? payRequest,
    TResult? Function(LnUrlWithdrawRequestData field0)? withdrawRequest,
    TResult? Function(LnUrlAuthRequestData field0)? authRequest,
  }) {
    return payRequest?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlPayRequestData field0)? payRequest,
    TResult Function(LnUrlWithdrawRequestData field0)? withdrawRequest,
    TResult Function(LnUrlAuthRequestData field0)? authRequest,
    required TResult orElse(),
  }) {
    if (payRequest != null) {
      return payRequest(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlRequestData_PayRequest value) payRequest,
    required TResult Function(LnUrlRequestData_WithdrawRequest value)
        withdrawRequest,
    required TResult Function(LnUrlRequestData_AuthRequest value) authRequest,
  }) {
    return payRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlRequestData_PayRequest value)? payRequest,
    TResult? Function(LnUrlRequestData_WithdrawRequest value)? withdrawRequest,
    TResult? Function(LnUrlRequestData_AuthRequest value)? authRequest,
  }) {
    return payRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlRequestData_PayRequest value)? payRequest,
    TResult Function(LnUrlRequestData_WithdrawRequest value)? withdrawRequest,
    TResult Function(LnUrlRequestData_AuthRequest value)? authRequest,
    required TResult orElse(),
  }) {
    if (payRequest != null) {
      return payRequest(this);
    }
    return orElse();
  }
}

abstract class LnUrlRequestData_PayRequest implements LnUrlRequestData {
  const factory LnUrlRequestData_PayRequest(final LnUrlPayRequestData field0) =
      _$LnUrlRequestData_PayRequest;

  LnUrlPayRequestData get field0;
  @JsonKey(ignore: true)
  _$$LnUrlRequestData_PayRequestCopyWith<_$LnUrlRequestData_PayRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LnUrlRequestData_WithdrawRequestCopyWith<$Res> {
  factory _$$LnUrlRequestData_WithdrawRequestCopyWith(
          _$LnUrlRequestData_WithdrawRequest value,
          $Res Function(_$LnUrlRequestData_WithdrawRequest) then) =
      __$$LnUrlRequestData_WithdrawRequestCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlWithdrawRequestData field0});
}

/// @nodoc
class __$$LnUrlRequestData_WithdrawRequestCopyWithImpl<$Res>
    extends _$LnUrlRequestDataCopyWithImpl<$Res,
        _$LnUrlRequestData_WithdrawRequest>
    implements _$$LnUrlRequestData_WithdrawRequestCopyWith<$Res> {
  __$$LnUrlRequestData_WithdrawRequestCopyWithImpl(
      _$LnUrlRequestData_WithdrawRequest _value,
      $Res Function(_$LnUrlRequestData_WithdrawRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$LnUrlRequestData_WithdrawRequest(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as LnUrlWithdrawRequestData,
    ));
  }
}

/// @nodoc

class _$LnUrlRequestData_WithdrawRequest
    implements LnUrlRequestData_WithdrawRequest {
  const _$LnUrlRequestData_WithdrawRequest(this.field0);

  @override
  final LnUrlWithdrawRequestData field0;

  @override
  String toString() {
    return 'LnUrlRequestData.withdrawRequest(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LnUrlRequestData_WithdrawRequest &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LnUrlRequestData_WithdrawRequestCopyWith<
          _$LnUrlRequestData_WithdrawRequest>
      get copyWith => __$$LnUrlRequestData_WithdrawRequestCopyWithImpl<
          _$LnUrlRequestData_WithdrawRequest>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlPayRequestData field0) payRequest,
    required TResult Function(LnUrlWithdrawRequestData field0) withdrawRequest,
    required TResult Function(LnUrlAuthRequestData field0) authRequest,
  }) {
    return withdrawRequest(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPayRequestData field0)? payRequest,
    TResult? Function(LnUrlWithdrawRequestData field0)? withdrawRequest,
    TResult? Function(LnUrlAuthRequestData field0)? authRequest,
  }) {
    return withdrawRequest?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlPayRequestData field0)? payRequest,
    TResult Function(LnUrlWithdrawRequestData field0)? withdrawRequest,
    TResult Function(LnUrlAuthRequestData field0)? authRequest,
    required TResult orElse(),
  }) {
    if (withdrawRequest != null) {
      return withdrawRequest(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlRequestData_PayRequest value) payRequest,
    required TResult Function(LnUrlRequestData_WithdrawRequest value)
        withdrawRequest,
    required TResult Function(LnUrlRequestData_AuthRequest value) authRequest,
  }) {
    return withdrawRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlRequestData_PayRequest value)? payRequest,
    TResult? Function(LnUrlRequestData_WithdrawRequest value)? withdrawRequest,
    TResult? Function(LnUrlRequestData_AuthRequest value)? authRequest,
  }) {
    return withdrawRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlRequestData_PayRequest value)? payRequest,
    TResult Function(LnUrlRequestData_WithdrawRequest value)? withdrawRequest,
    TResult Function(LnUrlRequestData_AuthRequest value)? authRequest,
    required TResult orElse(),
  }) {
    if (withdrawRequest != null) {
      return withdrawRequest(this);
    }
    return orElse();
  }
}

abstract class LnUrlRequestData_WithdrawRequest implements LnUrlRequestData {
  const factory LnUrlRequestData_WithdrawRequest(
          final LnUrlWithdrawRequestData field0) =
      _$LnUrlRequestData_WithdrawRequest;

  LnUrlWithdrawRequestData get field0;
  @JsonKey(ignore: true)
  _$$LnUrlRequestData_WithdrawRequestCopyWith<
          _$LnUrlRequestData_WithdrawRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LnUrlRequestData_AuthRequestCopyWith<$Res> {
  factory _$$LnUrlRequestData_AuthRequestCopyWith(
          _$LnUrlRequestData_AuthRequest value,
          $Res Function(_$LnUrlRequestData_AuthRequest) then) =
      __$$LnUrlRequestData_AuthRequestCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlAuthRequestData field0});
}

/// @nodoc
class __$$LnUrlRequestData_AuthRequestCopyWithImpl<$Res>
    extends _$LnUrlRequestDataCopyWithImpl<$Res, _$LnUrlRequestData_AuthRequest>
    implements _$$LnUrlRequestData_AuthRequestCopyWith<$Res> {
  __$$LnUrlRequestData_AuthRequestCopyWithImpl(
      _$LnUrlRequestData_AuthRequest _value,
      $Res Function(_$LnUrlRequestData_AuthRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$LnUrlRequestData_AuthRequest(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as LnUrlAuthRequestData,
    ));
  }
}

/// @nodoc

class _$LnUrlRequestData_AuthRequest implements LnUrlRequestData_AuthRequest {
  const _$LnUrlRequestData_AuthRequest(this.field0);

  @override
  final LnUrlAuthRequestData field0;

  @override
  String toString() {
    return 'LnUrlRequestData.authRequest(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LnUrlRequestData_AuthRequest &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LnUrlRequestData_AuthRequestCopyWith<_$LnUrlRequestData_AuthRequest>
      get copyWith => __$$LnUrlRequestData_AuthRequestCopyWithImpl<
          _$LnUrlRequestData_AuthRequest>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LnUrlPayRequestData field0) payRequest,
    required TResult Function(LnUrlWithdrawRequestData field0) withdrawRequest,
    required TResult Function(LnUrlAuthRequestData field0) authRequest,
  }) {
    return authRequest(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LnUrlPayRequestData field0)? payRequest,
    TResult? Function(LnUrlWithdrawRequestData field0)? withdrawRequest,
    TResult? Function(LnUrlAuthRequestData field0)? authRequest,
  }) {
    return authRequest?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LnUrlPayRequestData field0)? payRequest,
    TResult Function(LnUrlWithdrawRequestData field0)? withdrawRequest,
    TResult Function(LnUrlAuthRequestData field0)? authRequest,
    required TResult orElse(),
  }) {
    if (authRequest != null) {
      return authRequest(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LnUrlRequestData_PayRequest value) payRequest,
    required TResult Function(LnUrlRequestData_WithdrawRequest value)
        withdrawRequest,
    required TResult Function(LnUrlRequestData_AuthRequest value) authRequest,
  }) {
    return authRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LnUrlRequestData_PayRequest value)? payRequest,
    TResult? Function(LnUrlRequestData_WithdrawRequest value)? withdrawRequest,
    TResult? Function(LnUrlRequestData_AuthRequest value)? authRequest,
  }) {
    return authRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LnUrlRequestData_PayRequest value)? payRequest,
    TResult Function(LnUrlRequestData_WithdrawRequest value)? withdrawRequest,
    TResult Function(LnUrlRequestData_AuthRequest value)? authRequest,
    required TResult orElse(),
  }) {
    if (authRequest != null) {
      return authRequest(this);
    }
    return orElse();
  }
}

abstract class LnUrlRequestData_AuthRequest implements LnUrlRequestData {
  const factory LnUrlRequestData_AuthRequest(
      final LnUrlAuthRequestData field0) = _$LnUrlRequestData_AuthRequest;

  LnUrlAuthRequestData get field0;
  @JsonKey(ignore: true)
  _$$LnUrlRequestData_AuthRequestCopyWith<_$LnUrlRequestData_AuthRequest>
      get copyWith => throw _privateConstructorUsedError;
}
