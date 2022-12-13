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
mixin _$BreezEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
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
  $Res call({int block});
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
    Object? block = null,
  }) {
    return _then(_$BreezEvent_NewBlock(
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BreezEvent_NewBlock implements BreezEvent_NewBlock {
  const _$BreezEvent_NewBlock({required this.block});

  @override
  final int block;

  @override
  String toString() {
    return 'BreezEvent.newBlock(block: $block)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_NewBlock &&
            (identical(other.block, block) || other.block == block));
  }

  @override
  int get hashCode => Object.hash(runtimeType, block);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_NewBlockCopyWith<_$BreezEvent_NewBlock> get copyWith =>
      __$$BreezEvent_NewBlockCopyWithImpl<_$BreezEvent_NewBlock>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
  }) {
    return newBlock(block);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
  }) {
    return newBlock?.call(block);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    required TResult orElse(),
  }) {
    if (newBlock != null) {
      return newBlock(block);
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
  const factory BreezEvent_NewBlock({required final int block}) =
      _$BreezEvent_NewBlock;

  int get block;
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
  $Res call({InvoicePaidDetails details});
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
    Object? details = null,
  }) {
    return _then(_$BreezEvent_InvoicePaid(
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as InvoicePaidDetails,
    ));
  }
}

/// @nodoc

class _$BreezEvent_InvoicePaid implements BreezEvent_InvoicePaid {
  const _$BreezEvent_InvoicePaid({required this.details});

  @override
  final InvoicePaidDetails details;

  @override
  String toString() {
    return 'BreezEvent.invoicePaid(details: $details)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreezEvent_InvoicePaid &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreezEvent_InvoicePaidCopyWith<_$BreezEvent_InvoicePaid> get copyWith =>
      __$$BreezEvent_InvoicePaidCopyWithImpl<_$BreezEvent_InvoicePaid>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int block) newBlock,
    required TResult Function(InvoicePaidDetails details) invoicePaid,
  }) {
    return invoicePaid(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int block)? newBlock,
    TResult? Function(InvoicePaidDetails details)? invoicePaid,
  }) {
    return invoicePaid?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int block)? newBlock,
    TResult Function(InvoicePaidDetails details)? invoicePaid,
    required TResult orElse(),
  }) {
    if (invoicePaid != null) {
      return invoicePaid(details);
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
  const factory BreezEvent_InvoicePaid(
      {required final InvoicePaidDetails details}) = _$BreezEvent_InvoicePaid;

  InvoicePaidDetails get details;
  @JsonKey(ignore: true)
  _$$BreezEvent_InvoicePaidCopyWith<_$BreezEvent_InvoicePaid> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InputType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
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
    required TResult Function(InputType_LnUrlError value) lnUrlError,
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
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
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
    TResult Function(InputType_LnUrlError value)? lnUrlError,
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
  $Res call({BitcoinAddressData address});
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
    Object? address = null,
  }) {
    return _then(_$InputType_BitcoinAddress(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as BitcoinAddressData,
    ));
  }
}

/// @nodoc

class _$InputType_BitcoinAddress implements InputType_BitcoinAddress {
  const _$InputType_BitcoinAddress({required this.address});

  @override
  final BitcoinAddressData address;

  @override
  String toString() {
    return 'InputType.bitcoinAddress(address: $address)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_BitcoinAddress &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address);

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
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return bitcoinAddress(address);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return bitcoinAddress?.call(address);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(address);
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
    required TResult Function(InputType_LnUrlError value) lnUrlError,
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
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
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
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(this);
    }
    return orElse();
  }
}

abstract class InputType_BitcoinAddress implements InputType {
  const factory InputType_BitcoinAddress(
      {required final BitcoinAddressData address}) = _$InputType_BitcoinAddress;

  BitcoinAddressData get address;
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
  $Res call({LNInvoice invoice});
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
    Object? invoice = null,
  }) {
    return _then(_$InputType_Bolt11(
      invoice: null == invoice
          ? _value.invoice
          : invoice // ignore: cast_nullable_to_non_nullable
              as LNInvoice,
    ));
  }
}

/// @nodoc

class _$InputType_Bolt11 implements InputType_Bolt11 {
  const _$InputType_Bolt11({required this.invoice});

  @override
  final LNInvoice invoice;

  @override
  String toString() {
    return 'InputType.bolt11(invoice: $invoice)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_Bolt11 &&
            (identical(other.invoice, invoice) || other.invoice == invoice));
  }

  @override
  int get hashCode => Object.hash(runtimeType, invoice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_Bolt11CopyWith<_$InputType_Bolt11> get copyWith =>
      __$$InputType_Bolt11CopyWithImpl<_$InputType_Bolt11>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return bolt11(invoice);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return bolt11?.call(invoice);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (bolt11 != null) {
      return bolt11(invoice);
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
    required TResult Function(InputType_LnUrlError value) lnUrlError,
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
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
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
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (bolt11 != null) {
      return bolt11(this);
    }
    return orElse();
  }
}

abstract class InputType_Bolt11 implements InputType {
  const factory InputType_Bolt11({required final LNInvoice invoice}) =
      _$InputType_Bolt11;

  LNInvoice get invoice;
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
  $Res call({String nodeId});
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
    Object? nodeId = null,
  }) {
    return _then(_$InputType_NodeId(
      nodeId: null == nodeId
          ? _value.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_NodeId implements InputType_NodeId {
  const _$InputType_NodeId({required this.nodeId});

  @override
  final String nodeId;

  @override
  String toString() {
    return 'InputType.nodeId(nodeId: $nodeId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_NodeId &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, nodeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_NodeIdCopyWith<_$InputType_NodeId> get copyWith =>
      __$$InputType_NodeIdCopyWithImpl<_$InputType_NodeId>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return nodeId(this.nodeId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return nodeId?.call(this.nodeId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (nodeId != null) {
      return nodeId(this.nodeId);
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
    required TResult Function(InputType_LnUrlError value) lnUrlError,
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
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
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
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (nodeId != null) {
      return nodeId(this);
    }
    return orElse();
  }
}

abstract class InputType_NodeId implements InputType {
  const factory InputType_NodeId({required final String nodeId}) =
      _$InputType_NodeId;

  String get nodeId;
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
  $Res call({String url});
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
    Object? url = null,
  }) {
    return _then(_$InputType_Url(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_Url implements InputType_Url {
  const _$InputType_Url({required this.url});

  @override
  final String url;

  @override
  String toString() {
    return 'InputType.url(url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_Url &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_UrlCopyWith<_$InputType_Url> get copyWith =>
      __$$InputType_UrlCopyWithImpl<_$InputType_Url>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return url(this.url);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return url?.call(this.url);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(this.url);
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
    required TResult Function(InputType_LnUrlError value) lnUrlError,
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
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
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
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(this);
    }
    return orElse();
  }
}

abstract class InputType_Url implements InputType {
  const factory InputType_Url({required final String url}) = _$InputType_Url;

  String get url;
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
  $Res call({LnUrlPayRequestData data});
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
    Object? data = null,
  }) {
    return _then(_$InputType_LnUrlPay(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlPayRequestData,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlPay implements InputType_LnUrlPay {
  const _$InputType_LnUrlPay({required this.data});

  @override
  final LnUrlPayRequestData data;

  @override
  String toString() {
    return 'InputType.lnUrlPay(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlPay &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlPayCopyWith<_$InputType_LnUrlPay> get copyWith =>
      __$$InputType_LnUrlPayCopyWithImpl<_$InputType_LnUrlPay>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return lnUrlPay(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return lnUrlPay?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlPay != null) {
      return lnUrlPay(data);
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
    required TResult Function(InputType_LnUrlError value) lnUrlError,
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
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
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
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlPay != null) {
      return lnUrlPay(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlPay implements InputType {
  const factory InputType_LnUrlPay({required final LnUrlPayRequestData data}) =
      _$InputType_LnUrlPay;

  LnUrlPayRequestData get data;
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
  $Res call({LnUrlWithdrawRequestData data});
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
    Object? data = null,
  }) {
    return _then(_$InputType_LnUrlWithdraw(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlWithdrawRequestData,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlWithdraw implements InputType_LnUrlWithdraw {
  const _$InputType_LnUrlWithdraw({required this.data});

  @override
  final LnUrlWithdrawRequestData data;

  @override
  String toString() {
    return 'InputType.lnUrlWithdraw(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlWithdraw &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlWithdrawCopyWith<_$InputType_LnUrlWithdraw> get copyWith =>
      __$$InputType_LnUrlWithdrawCopyWithImpl<_$InputType_LnUrlWithdraw>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return lnUrlWithdraw(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return lnUrlWithdraw?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlWithdraw != null) {
      return lnUrlWithdraw(data);
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
    required TResult Function(InputType_LnUrlError value) lnUrlError,
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
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
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
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlWithdraw != null) {
      return lnUrlWithdraw(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlWithdraw implements InputType {
  const factory InputType_LnUrlWithdraw(
          {required final LnUrlWithdrawRequestData data}) =
      _$InputType_LnUrlWithdraw;

  LnUrlWithdrawRequestData get data;
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
  $Res call({LnUrlAuthRequestData data});
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
    Object? data = null,
  }) {
    return _then(_$InputType_LnUrlAuth(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlAuthRequestData,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlAuth implements InputType_LnUrlAuth {
  const _$InputType_LnUrlAuth({required this.data});

  @override
  final LnUrlAuthRequestData data;

  @override
  String toString() {
    return 'InputType.lnUrlAuth(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlAuth &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlAuthCopyWith<_$InputType_LnUrlAuth> get copyWith =>
      __$$InputType_LnUrlAuthCopyWithImpl<_$InputType_LnUrlAuth>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return lnUrlAuth(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return lnUrlAuth?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlAuth != null) {
      return lnUrlAuth(data);
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
    required TResult Function(InputType_LnUrlError value) lnUrlError,
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
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
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
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlAuth != null) {
      return lnUrlAuth(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlAuth implements InputType {
  const factory InputType_LnUrlAuth(
      {required final LnUrlAuthRequestData data}) = _$InputType_LnUrlAuth;

  LnUrlAuthRequestData get data;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlAuthCopyWith<_$InputType_LnUrlAuth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlErrorCopyWith<$Res> {
  factory _$$InputType_LnUrlErrorCopyWith(_$InputType_LnUrlError value,
          $Res Function(_$InputType_LnUrlError) then) =
      __$$InputType_LnUrlErrorCopyWithImpl<$Res>;
  @useResult
  $Res call({LnUrlErrorData data});
}

/// @nodoc
class __$$InputType_LnUrlErrorCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res, _$InputType_LnUrlError>
    implements _$$InputType_LnUrlErrorCopyWith<$Res> {
  __$$InputType_LnUrlErrorCopyWithImpl(_$InputType_LnUrlError _value,
      $Res Function(_$InputType_LnUrlError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$InputType_LnUrlError(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LnUrlErrorData,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlError implements InputType_LnUrlError {
  const _$InputType_LnUrlError({required this.data});

  @override
  final LnUrlErrorData data;

  @override
  String toString() {
    return 'InputType.lnUrlError(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlError &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputType_LnUrlErrorCopyWith<_$InputType_LnUrlError> get copyWith =>
      __$$InputType_LnUrlErrorCopyWithImpl<_$InputType_LnUrlError>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData address) bitcoinAddress,
    required TResult Function(LNInvoice invoice) bolt11,
    required TResult Function(String nodeId) nodeId,
    required TResult Function(String url) url,
    required TResult Function(LnUrlPayRequestData data) lnUrlPay,
    required TResult Function(LnUrlWithdrawRequestData data) lnUrlWithdraw,
    required TResult Function(LnUrlAuthRequestData data) lnUrlAuth,
    required TResult Function(LnUrlErrorData data) lnUrlError,
  }) {
    return lnUrlError(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddressData address)? bitcoinAddress,
    TResult? Function(LNInvoice invoice)? bolt11,
    TResult? Function(String nodeId)? nodeId,
    TResult? Function(String url)? url,
    TResult? Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult? Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult? Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult? Function(LnUrlErrorData data)? lnUrlError,
  }) {
    return lnUrlError?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData address)? bitcoinAddress,
    TResult Function(LNInvoice invoice)? bolt11,
    TResult Function(String nodeId)? nodeId,
    TResult Function(String url)? url,
    TResult Function(LnUrlPayRequestData data)? lnUrlPay,
    TResult Function(LnUrlWithdrawRequestData data)? lnUrlWithdraw,
    TResult Function(LnUrlAuthRequestData data)? lnUrlAuth,
    TResult Function(LnUrlErrorData data)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlError != null) {
      return lnUrlError(data);
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
    required TResult Function(InputType_LnUrlError value) lnUrlError,
  }) {
    return lnUrlError(this);
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
    TResult? Function(InputType_LnUrlError value)? lnUrlError,
  }) {
    return lnUrlError?.call(this);
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
    TResult Function(InputType_LnUrlError value)? lnUrlError,
    required TResult orElse(),
  }) {
    if (lnUrlError != null) {
      return lnUrlError(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlError implements InputType {
  const factory InputType_LnUrlError({required final LnUrlErrorData data}) =
      _$InputType_LnUrlError;

  LnUrlErrorData get data;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlErrorCopyWith<_$InputType_LnUrlError> get copyWith =>
      throw _privateConstructorUsedError;
}
