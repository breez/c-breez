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
    required TResult Function(LnUrlPayData field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlPayData field0)? lnUrlPay,
    TResult? Function(String field0)? lnUrlWithdraw,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlPayData field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
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
    required TResult Function(LnUrlPayData field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
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
    TResult? Function(LnUrlPayData field0)? lnUrlPay,
    TResult? Function(String field0)? lnUrlWithdraw,
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
    TResult Function(LnUrlPayData field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
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
    required TResult Function(LnUrlPayData field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
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
    TResult? Function(LnUrlPayData field0)? lnUrlPay,
    TResult? Function(String field0)? lnUrlWithdraw,
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
    TResult Function(LnUrlPayData field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
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
    required TResult Function(LnUrlPayData field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
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
    TResult? Function(LnUrlPayData field0)? lnUrlPay,
    TResult? Function(String field0)? lnUrlWithdraw,
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
    TResult Function(LnUrlPayData field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
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
    required TResult Function(LnUrlPayData field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
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
    TResult? Function(LnUrlPayData field0)? lnUrlPay,
    TResult? Function(String field0)? lnUrlWithdraw,
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
    TResult Function(LnUrlPayData field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
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
  $Res call({LnUrlPayData field0});
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
              as LnUrlPayData,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlPay implements InputType_LnUrlPay {
  const _$InputType_LnUrlPay(this.field0);

  @override
  final LnUrlPayData field0;

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
    required TResult Function(LnUrlPayData field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
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
    TResult? Function(LnUrlPayData field0)? lnUrlPay,
    TResult? Function(String field0)? lnUrlWithdraw,
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
    TResult Function(LnUrlPayData field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
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
    required TResult orElse(),
  }) {
    if (lnUrlPay != null) {
      return lnUrlPay(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlPay implements InputType {
  const factory InputType_LnUrlPay(final LnUrlPayData field0) =
      _$InputType_LnUrlPay;

  LnUrlPayData get field0;
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
  $Res call({String field0});
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
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlWithdraw implements InputType_LnUrlWithdraw {
  const _$InputType_LnUrlWithdraw(this.field0);

  @override
  final String field0;

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
    required TResult Function(LnUrlPayData field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
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
    TResult? Function(LnUrlPayData field0)? lnUrlPay,
    TResult? Function(String field0)? lnUrlWithdraw,
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
    TResult Function(LnUrlPayData field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
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
    required TResult orElse(),
  }) {
    if (lnUrlWithdraw != null) {
      return lnUrlWithdraw(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlWithdraw implements InputType {
  const factory InputType_LnUrlWithdraw(final String field0) =
      _$InputType_LnUrlWithdraw;

  String get field0;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlWithdrawCopyWith<_$InputType_LnUrlWithdraw> get copyWith =>
      throw _privateConstructorUsedError;
}
