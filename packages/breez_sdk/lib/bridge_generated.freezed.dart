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
mixin _$BreezEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) newBlock,
    required TResult Function(InvoicePaidDetails field0) invoicePaid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? newBlock,
    TResult? Function(InvoicePaidDetails field0)? invoicePaid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? newBlock,
    TResult Function(InvoicePaidDetails field0)? invoicePaid,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreezEventCopyWith<$Res> {
  factory $BreezEventCopyWith(
          BreezEvent value, $Res Function(BreezEvent) then) =
      _$BreezEventCopyWithImpl<$Res, BreezEvent>;
}

/// @nodoc
class _$BreezEventCopyWithImpl<$Res, $Val extends BreezEvent>
    implements $BreezEventCopyWith<$Res> {
  _$BreezEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$BreezEvent_NewBlockCopyWith<$Res> {
  factory _$$BreezEvent_NewBlockCopyWith(_$BreezEvent_NewBlock value,
          $Res Function(_$BreezEvent_NewBlock) then) =
      __$$BreezEvent_NewBlockCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$BreezEvent_NewBlockCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_NewBlock>
    implements _$$BreezEvent_NewBlockCopyWith<$Res> {
  __$$BreezEvent_NewBlockCopyWithImpl(
      _$BreezEvent_NewBlock _value, $Res Function(_$BreezEvent_NewBlock) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$BreezEvent_NewBlock(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BreezEvent_NewBlock implements BreezEvent_NewBlock {
  const _$BreezEvent_NewBlock(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'BreezEvent.newBlock(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_NewBlock &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_NewBlockCopyWith<_$BreezEvent_NewBlock> get copyWith =>
      __$$BreezEvent_NewBlockCopyWithImpl<_$BreezEvent_NewBlock>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) newBlock,
    required TResult Function(InvoicePaidDetails field0) invoicePaid,
  }) {
    return newBlock(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? newBlock,
    TResult? Function(InvoicePaidDetails field0)? invoicePaid,
  }) {
    return newBlock?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? newBlock,
    TResult Function(InvoicePaidDetails field0)? invoicePaid,
    required TResult orElse(),
  }) {
    if (newBlock != null) {
      return newBlock(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
  }) {
    return newBlock(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
  }) {
    return newBlock?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    required TResult orElse(),
  }) {
    if (newBlock != null) {
      return newBlock(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_NewBlock implements BreezEvent {
  const factory BreezEvent_NewBlock(final int field0) = _$BreezEvent_NewBlock;

  int get field0;
  @JsonKey(ignore: true)
  _$$BreezEvent_NewBlockCopyWith<_$BreezEvent_NewBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BreezEvent_InvoicePaidCopyWith<$Res> {
  factory _$$BreezEvent_InvoicePaidCopyWith(_$BreezEvent_InvoicePaid value,
          $Res Function(_$BreezEvent_InvoicePaid) then) =
      __$$BreezEvent_InvoicePaidCopyWithImpl<$Res>;
  @useResult
  $Res call({InvoicePaidDetails field0});
}

/// @nodoc
class __$$BreezEvent_InvoicePaidCopyWithImpl<$Res>
    extends _$BreezEventCopyWithImpl<$Res, _$BreezEvent_InvoicePaid>
    implements _$$BreezEvent_InvoicePaidCopyWith<$Res> {
  __$$BreezEvent_InvoicePaidCopyWithImpl(_$BreezEvent_InvoicePaid _value,
      $Res Function(_$BreezEvent_InvoicePaid) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$BreezEvent_InvoicePaid(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as InvoicePaidDetails,
    ));
  }
}

/// @nodoc

class _$BreezEvent_InvoicePaid implements BreezEvent_InvoicePaid {
  const _$BreezEvent_InvoicePaid(this.field0);

  @override
  final InvoicePaidDetails field0;

  @override
  String toString() {
    return 'BreezEvent.invoicePaid(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_InvoicePaid &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_InvoicePaidCopyWith<_$BreezEvent_InvoicePaid> get copyWith =>
      __$$BreezEvent_InvoicePaidCopyWithImpl<_$BreezEvent_InvoicePaid>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) newBlock,
    required TResult Function(InvoicePaidDetails field0) invoicePaid,
  }) {
    return invoicePaid(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? newBlock,
    TResult? Function(InvoicePaidDetails field0)? invoicePaid,
  }) {
    return invoicePaid?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? newBlock,
    TResult Function(InvoicePaidDetails field0)? invoicePaid,
    required TResult orElse(),
  }) {
    if (invoicePaid != null) {
      return invoicePaid(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BreezEvent_NewBlock value) newBlock,
    required TResult Function(BreezEvent_InvoicePaid value) invoicePaid,
  }) {
    return invoicePaid(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BreezEvent_NewBlock value)? newBlock,
    TResult? Function(BreezEvent_InvoicePaid value)? invoicePaid,
  }) {
    return invoicePaid?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BreezEvent_NewBlock value)? newBlock,
    TResult Function(BreezEvent_InvoicePaid value)? invoicePaid,
    required TResult orElse(),
  }) {
    if (invoicePaid != null) {
      return invoicePaid(this);
    }
    return orElse();
  }
}

abstract class BreezEvent_InvoicePaid implements BreezEvent {
  const factory BreezEvent_InvoicePaid(final InvoicePaidDetails field0) =
      _$BreezEvent_InvoicePaid;

  InvoicePaidDetails get field0;
  @JsonKey(ignore: true)
  _$$BreezEvent_InvoicePaidCopyWith<_$BreezEvent_InvoicePaid> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InputType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrl,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrl,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrl,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrl value) lnUrl,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrl value)? lnUrl,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrl value)? lnUrl,
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
    required TResult Function(LnUrlRequestData field0) lnUrl,
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
    TResult? Function(LnUrlRequestData field0)? lnUrl,
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
    TResult Function(LnUrlRequestData field0)? lnUrl,
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
    required TResult Function(InputType_LnUrl value) lnUrl,
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
    TResult? Function(InputType_LnUrl value)? lnUrl,
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
    TResult Function(InputType_LnUrl value)? lnUrl,
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
    required TResult Function(LnUrlRequestData field0) lnUrl,
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
    TResult? Function(LnUrlRequestData field0)? lnUrl,
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
    TResult Function(LnUrlRequestData field0)? lnUrl,
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
    required TResult Function(InputType_LnUrl value) lnUrl,
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
    TResult? Function(InputType_LnUrl value)? lnUrl,
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
    TResult Function(InputType_LnUrl value)? lnUrl,
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
    required TResult Function(LnUrlRequestData field0) lnUrl,
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
    TResult? Function(LnUrlRequestData field0)? lnUrl,
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
    TResult Function(LnUrlRequestData field0)? lnUrl,
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
    required TResult Function(InputType_LnUrl value) lnUrl,
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
    TResult? Function(InputType_LnUrl value)? lnUrl,
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
    TResult Function(InputType_LnUrl value)? lnUrl,
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
    required TResult Function(LnUrlRequestData field0) lnUrl,
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
    TResult? Function(LnUrlRequestData field0)? lnUrl,
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
    TResult Function(LnUrlRequestData field0)? lnUrl,
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
    required TResult Function(InputType_LnUrl value) lnUrl,
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
    TResult? Function(InputType_LnUrl value)? lnUrl,
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
    TResult Function(InputType_LnUrl value)? lnUrl,
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
abstract class _$$InputType_LnUrlCopyWith<$Res> {
  factory _$$InputType_LnUrlCopyWith(
          _$InputType_LnUrl value, $Res Function(_$InputType_LnUrl) then) =
      __$$InputType_LnUrlCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlRequestData field0});

  $LnUrlRequestDataCopyWith<$Res> get field0;
}

/// @nodoc
class __$$InputType_LnUrlCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_LnUrl>
    implements _$$InputType_LnUrlCopyWith<$Res> {
  __$$InputType_LnUrlCopyWithImpl(
      _$InputType_LnUrl _value, $Res Function(_$InputType_LnUrl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$InputType_LnUrl(
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

class _$InputType_LnUrl implements InputType_LnUrl {
  const _$InputType_LnUrl(this.field0);

  @override
  final LnUrlRequestData field0;

  @override
  String toString() {
    return 'InputType.lnUrl(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlCopyWith<_$InputType_LnUrl> get copyWith =>
      __$$InputType_LnUrlCopyWithImpl<_$InputType_LnUrl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(LnUrlRequestData field0) lnUrl,
  }) {
    return lnUrl(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult? Function(LNInvoice field0)? bolt11,
    TResult? Function(String field0)? nodeId,
    TResult? Function(String field0)? url,
    TResult? Function(LnUrlRequestData field0)? lnUrl,
  }) {
    return lnUrl?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(LnUrlRequestData field0)? lnUrl,
    required TResult orElse(),
  }) {
    if (lnUrl != null) {
      return lnUrl(field0);
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
    required TResult Function(InputType_LnUrl value) lnUrl,
  }) {
    return lnUrl(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(InputType_Bolt11 value)? bolt11,
    TResult? Function(InputType_NodeId value)? nodeId,
    TResult? Function(InputType_Url value)? url,
    TResult? Function(InputType_LnUrl value)? lnUrl,
  }) {
    return lnUrl?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrl value)? lnUrl,
    required TResult orElse(),
  }) {
    if (lnUrl != null) {
      return lnUrl(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrl implements InputType {
  const factory InputType_LnUrl(final LnUrlRequestData field0) =
      _$InputType_LnUrl;

  LnUrlRequestData get field0;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlCopyWith<_$InputType_LnUrl> get copyWith =>
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
