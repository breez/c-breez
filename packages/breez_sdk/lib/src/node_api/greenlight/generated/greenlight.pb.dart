///
//  Generated code. Do not modify.
//  source: greenlight.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'greenlight.pbenum.dart';

export 'greenlight.pbenum.dart';

class HsmRequestContext extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HsmRequestContext',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId',
        $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dbid',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'capabilities',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  HsmRequestContext._() : super();
  factory HsmRequestContext({
    $core.List<$core.int>? nodeId,
    $fixnum.Int64? dbid,
    $fixnum.Int64? capabilities,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (dbid != null) {
      _result.dbid = dbid;
    }
    if (capabilities != null) {
      _result.capabilities = capabilities;
    }
    return _result;
  }
  factory HsmRequestContext.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HsmRequestContext.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HsmRequestContext clone() => HsmRequestContext()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HsmRequestContext copyWith(void Function(HsmRequestContext) updates) =>
      super.copyWith((message) => updates(message as HsmRequestContext))
          as HsmRequestContext; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HsmRequestContext create() => HsmRequestContext._();
  HsmRequestContext createEmptyInstance() => create();
  static $pb.PbList<HsmRequestContext> createRepeated() =>
      $pb.PbList<HsmRequestContext>();
  @$core.pragma('dart2js:noInline')
  static HsmRequestContext getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HsmRequestContext>(create);
  static HsmRequestContext? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get dbid => $_getI64(1);
  @$pb.TagNumber(2)
  set dbid($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDbid() => $_has(1);
  @$pb.TagNumber(2)
  void clearDbid() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get capabilities => $_getI64(2);
  @$pb.TagNumber(3)
  set capabilities($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCapabilities() => $_has(2);
  @$pb.TagNumber(3)
  void clearCapabilities() => clearField(3);
}

class HsmResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HsmResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'requestId',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'raw',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  HsmResponse._() : super();
  factory HsmResponse({
    $core.int? requestId,
    $core.List<$core.int>? raw,
  }) {
    final _result = create();
    if (requestId != null) {
      _result.requestId = requestId;
    }
    if (raw != null) {
      _result.raw = raw;
    }
    return _result;
  }
  factory HsmResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HsmResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HsmResponse clone() => HsmResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HsmResponse copyWith(void Function(HsmResponse) updates) =>
      super.copyWith((message) => updates(message as HsmResponse))
          as HsmResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HsmResponse create() => HsmResponse._();
  HsmResponse createEmptyInstance() => create();
  static $pb.PbList<HsmResponse> createRepeated() => $pb.PbList<HsmResponse>();
  @$core.pragma('dart2js:noInline')
  static HsmResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HsmResponse>(create);
  static HsmResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestId => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestId($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get raw => $_getN(1);
  @$pb.TagNumber(2)
  set raw($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRaw() => $_has(1);
  @$pb.TagNumber(2)
  void clearRaw() => clearField(2);
}

class HsmRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HsmRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'requestId',
        $pb.PbFieldType.OU3)
    ..aOM<HsmRequestContext>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'context',
        subBuilder: HsmRequestContext.create)
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'raw',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  HsmRequest._() : super();
  factory HsmRequest({
    $core.int? requestId,
    HsmRequestContext? context,
    $core.List<$core.int>? raw,
  }) {
    final _result = create();
    if (requestId != null) {
      _result.requestId = requestId;
    }
    if (context != null) {
      _result.context = context;
    }
    if (raw != null) {
      _result.raw = raw;
    }
    return _result;
  }
  factory HsmRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HsmRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HsmRequest clone() => HsmRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HsmRequest copyWith(void Function(HsmRequest) updates) =>
      super.copyWith((message) => updates(message as HsmRequest))
          as HsmRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HsmRequest create() => HsmRequest._();
  HsmRequest createEmptyInstance() => create();
  static $pb.PbList<HsmRequest> createRepeated() => $pb.PbList<HsmRequest>();
  @$core.pragma('dart2js:noInline')
  static HsmRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HsmRequest>(create);
  static HsmRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestId => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestId($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);

  @$pb.TagNumber(2)
  HsmRequestContext get context => $_getN(1);
  @$pb.TagNumber(2)
  set context(HsmRequestContext v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasContext() => $_has(1);
  @$pb.TagNumber(2)
  void clearContext() => clearField(2);
  @$pb.TagNumber(2)
  HsmRequestContext ensureContext() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get raw => $_getN(2);
  @$pb.TagNumber(3)
  set raw($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRaw() => $_has(2);
  @$pb.TagNumber(3)
  void clearRaw() => clearField(3);
}

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Empty',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  Empty._() : super();
  factory Empty() => create();
  factory Empty.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) =>
      super.copyWith((message) => updates(message as Empty))
          as Empty; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class Address extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Address',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..e<NetAddressType>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type',
        $pb.PbFieldType.OE,
        defaultOrMaker: NetAddressType.Ipv4,
        valueOf: NetAddressType.valueOf,
        enumValues: NetAddressType.values)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'addr')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'port',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  Address._() : super();
  factory Address({
    NetAddressType? type,
    $core.String? addr,
    $core.int? port,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (addr != null) {
      _result.addr = addr;
    }
    if (port != null) {
      _result.port = port;
    }
    return _result;
  }
  factory Address.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Address.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Address clone() => Address()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Address copyWith(void Function(Address) updates) =>
      super.copyWith((message) => updates(message as Address))
          as Address; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Address create() => Address._();
  Address createEmptyInstance() => create();
  static $pb.PbList<Address> createRepeated() => $pb.PbList<Address>();
  @$core.pragma('dart2js:noInline')
  static Address getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Address>(create);
  static Address? _defaultInstance;

  @$pb.TagNumber(1)
  NetAddressType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(NetAddressType v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get addr => $_getSZ(1);
  @$pb.TagNumber(2)
  set addr($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAddr() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddr() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => clearField(3);
}

class GetInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetInfoRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  GetInfoRequest._() : super();
  factory GetInfoRequest() => create();
  factory GetInfoRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetInfoRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetInfoRequest clone() => GetInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetInfoRequest copyWith(void Function(GetInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetInfoRequest))
          as GetInfoRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetInfoRequest create() => GetInfoRequest._();
  GetInfoRequest createEmptyInstance() => create();
  static $pb.PbList<GetInfoRequest> createRepeated() =>
      $pb.PbList<GetInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static GetInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInfoRequest>(create);
  static GetInfoRequest? _defaultInstance;
}

class GetInfoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GetInfoResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId',
        $pb.PbFieldType.OY)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'alias')
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'color',
        $pb.PbFieldType.OY)
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'numPeers',
        $pb.PbFieldType.OU3)
    ..pc<Address>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'addresses',
        $pb.PbFieldType.PM,
        subBuilder: Address.create)
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'version')
    ..a<$core.int>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blockheight',
        $pb.PbFieldType.OU3)
    ..aOS(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'network')
    ..hasRequiredFields = false;

  GetInfoResponse._() : super();
  factory GetInfoResponse({
    $core.List<$core.int>? nodeId,
    $core.String? alias,
    $core.List<$core.int>? color,
    $core.int? numPeers,
    $core.Iterable<Address>? addresses,
    $core.String? version,
    $core.int? blockheight,
    $core.String? network,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (alias != null) {
      _result.alias = alias;
    }
    if (color != null) {
      _result.color = color;
    }
    if (numPeers != null) {
      _result.numPeers = numPeers;
    }
    if (addresses != null) {
      _result.addresses.addAll(addresses);
    }
    if (version != null) {
      _result.version = version;
    }
    if (blockheight != null) {
      _result.blockheight = blockheight;
    }
    if (network != null) {
      _result.network = network;
    }
    return _result;
  }
  factory GetInfoResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetInfoResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetInfoResponse clone() => GetInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetInfoResponse copyWith(void Function(GetInfoResponse) updates) =>
      super.copyWith((message) => updates(message as GetInfoResponse))
          as GetInfoResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetInfoResponse create() => GetInfoResponse._();
  GetInfoResponse createEmptyInstance() => create();
  static $pb.PbList<GetInfoResponse> createRepeated() =>
      $pb.PbList<GetInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static GetInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInfoResponse>(create);
  static GetInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get alias => $_getSZ(1);
  @$pb.TagNumber(2)
  set alias($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAlias() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlias() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get color => $_getN(2);
  @$pb.TagNumber(3)
  set color($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get numPeers => $_getIZ(3);
  @$pb.TagNumber(4)
  set numPeers($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasNumPeers() => $_has(3);
  @$pb.TagNumber(4)
  void clearNumPeers() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<Address> get addresses => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get version => $_getSZ(5);
  @$pb.TagNumber(6)
  set version($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get blockheight => $_getIZ(6);
  @$pb.TagNumber(7)
  set blockheight($core.int v) {
    $_setUnsignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasBlockheight() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlockheight() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get network => $_getSZ(7);
  @$pb.TagNumber(8)
  set network($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasNetwork() => $_has(7);
  @$pb.TagNumber(8)
  void clearNetwork() => clearField(8);
}

class StopRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'StopRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  StopRequest._() : super();
  factory StopRequest() => create();
  factory StopRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StopRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  StopRequest clone() => StopRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  StopRequest copyWith(void Function(StopRequest) updates) =>
      super.copyWith((message) => updates(message as StopRequest))
          as StopRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StopRequest create() => StopRequest._();
  StopRequest createEmptyInstance() => create();
  static $pb.PbList<StopRequest> createRepeated() => $pb.PbList<StopRequest>();
  @$core.pragma('dart2js:noInline')
  static StopRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopRequest>(create);
  static StopRequest? _defaultInstance;
}

class StopResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'StopResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  StopResponse._() : super();
  factory StopResponse() => create();
  factory StopResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StopResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  StopResponse clone() => StopResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  StopResponse copyWith(void Function(StopResponse) updates) =>
      super.copyWith((message) => updates(message as StopResponse))
          as StopResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StopResponse create() => StopResponse._();
  StopResponse createEmptyInstance() => create();
  static $pb.PbList<StopResponse> createRepeated() =>
      $pb.PbList<StopResponse>();
  @$core.pragma('dart2js:noInline')
  static StopResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopResponse>(create);
  static StopResponse? _defaultInstance;
}

class ConnectRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConnectRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'addr')
    ..hasRequiredFields = false;

  ConnectRequest._() : super();
  factory ConnectRequest({
    $core.String? nodeId,
    $core.String? addr,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (addr != null) {
      _result.addr = addr;
    }
    return _result;
  }
  factory ConnectRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConnectRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConnectRequest clone() => ConnectRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConnectRequest copyWith(void Function(ConnectRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectRequest))
          as ConnectRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectRequest create() => ConnectRequest._();
  ConnectRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectRequest> createRepeated() =>
      $pb.PbList<ConnectRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectRequest>(create);
  static ConnectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get addr => $_getSZ(1);
  @$pb.TagNumber(2)
  set addr($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAddr() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddr() => clearField(2);
}

class ConnectResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConnectResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'features')
    ..hasRequiredFields = false;

  ConnectResponse._() : super();
  factory ConnectResponse({
    $core.String? nodeId,
    $core.String? features,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (features != null) {
      _result.features = features;
    }
    return _result;
  }
  factory ConnectResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConnectResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConnectResponse clone() => ConnectResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConnectResponse copyWith(void Function(ConnectResponse) updates) =>
      super.copyWith((message) => updates(message as ConnectResponse))
          as ConnectResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectResponse create() => ConnectResponse._();
  ConnectResponse createEmptyInstance() => create();
  static $pb.PbList<ConnectResponse> createRepeated() =>
      $pb.PbList<ConnectResponse>();
  @$core.pragma('dart2js:noInline')
  static ConnectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectResponse>(create);
  static ConnectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get features => $_getSZ(1);
  @$pb.TagNumber(2)
  set features($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFeatures() => $_has(1);
  @$pb.TagNumber(2)
  void clearFeatures() => clearField(2);
}

class ListPeersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListPeersRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId')
    ..hasRequiredFields = false;

  ListPeersRequest._() : super();
  factory ListPeersRequest({
    $core.String? nodeId,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    return _result;
  }
  factory ListPeersRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListPeersRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListPeersRequest clone() => ListPeersRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListPeersRequest copyWith(void Function(ListPeersRequest) updates) =>
      super.copyWith((message) => updates(message as ListPeersRequest))
          as ListPeersRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListPeersRequest create() => ListPeersRequest._();
  ListPeersRequest createEmptyInstance() => create();
  static $pb.PbList<ListPeersRequest> createRepeated() =>
      $pb.PbList<ListPeersRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPeersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPeersRequest>(create);
  static ListPeersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);
}

class Htlc extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Htlc',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'direction')
    ..a<$fixnum.Int64>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount')
    ..a<$fixnum.Int64>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'expiry',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentHash')
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'state')
    ..aOB(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'localTrimmed')
    ..hasRequiredFields = false;

  Htlc._() : super();
  factory Htlc({
    $core.String? direction,
    $fixnum.Int64? id,
    $core.String? amount,
    $fixnum.Int64? expiry,
    $core.String? paymentHash,
    $core.String? state,
    $core.bool? localTrimmed,
  }) {
    final _result = create();
    if (direction != null) {
      _result.direction = direction;
    }
    if (id != null) {
      _result.id = id;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (expiry != null) {
      _result.expiry = expiry;
    }
    if (paymentHash != null) {
      _result.paymentHash = paymentHash;
    }
    if (state != null) {
      _result.state = state;
    }
    if (localTrimmed != null) {
      _result.localTrimmed = localTrimmed;
    }
    return _result;
  }
  factory Htlc.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Htlc.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Htlc clone() => Htlc()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Htlc copyWith(void Function(Htlc) updates) =>
      super.copyWith((message) => updates(message as Htlc))
          as Htlc; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Htlc create() => Htlc._();
  Htlc createEmptyInstance() => create();
  static $pb.PbList<Htlc> createRepeated() => $pb.PbList<Htlc>();
  @$core.pragma('dart2js:noInline')
  static Htlc getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Htlc>(create);
  static Htlc? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get direction => $_getSZ(0);
  @$pb.TagNumber(1)
  set direction($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDirection() => $_has(0);
  @$pb.TagNumber(1)
  void clearDirection() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get id => $_getI64(1);
  @$pb.TagNumber(2)
  set id($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get amount => $_getSZ(2);
  @$pb.TagNumber(3)
  set amount($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiry => $_getI64(3);
  @$pb.TagNumber(4)
  set expiry($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasExpiry() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiry() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get paymentHash => $_getSZ(4);
  @$pb.TagNumber(5)
  set paymentHash($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPaymentHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearPaymentHash() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get state => $_getSZ(5);
  @$pb.TagNumber(6)
  set state($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get localTrimmed => $_getBF(6);
  @$pb.TagNumber(7)
  set localTrimmed($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasLocalTrimmed() => $_has(6);
  @$pb.TagNumber(7)
  void clearLocalTrimmed() => clearField(7);
}

class Channel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Channel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'state')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'owner')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'shortChannelId')
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'direction',
        $pb.PbFieldType.OU3)
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'channelId')
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fundingTxid')
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'closeToAddr')
    ..aOS(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'closeTo')
    ..aOB(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'private')
    ..aOS(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'total')
    ..aOS(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dustLimit')
    ..aOS(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'spendable')
    ..aOS(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'receivable')
    ..a<$core.int>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'theirToSelfDelay',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ourToSelfDelay',
        $pb.PbFieldType.OU3)
    ..pPS(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'status')
    ..pc<Htlc>(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'htlcs',
        $pb.PbFieldType.PM,
        subBuilder: Htlc.create)
    ..hasRequiredFields = false;

  Channel._() : super();
  factory Channel({
    $core.String? state,
    $core.String? owner,
    $core.String? shortChannelId,
    $core.int? direction,
    $core.String? channelId,
    $core.String? fundingTxid,
    $core.String? closeToAddr,
    $core.String? closeTo,
    $core.bool? private,
    $core.String? total,
    $core.String? dustLimit,
    $core.String? spendable,
    $core.String? receivable,
    $core.int? theirToSelfDelay,
    $core.int? ourToSelfDelay,
    $core.Iterable<$core.String>? status,
    $core.Iterable<Htlc>? htlcs,
  }) {
    final _result = create();
    if (state != null) {
      _result.state = state;
    }
    if (owner != null) {
      _result.owner = owner;
    }
    if (shortChannelId != null) {
      _result.shortChannelId = shortChannelId;
    }
    if (direction != null) {
      _result.direction = direction;
    }
    if (channelId != null) {
      _result.channelId = channelId;
    }
    if (fundingTxid != null) {
      _result.fundingTxid = fundingTxid;
    }
    if (closeToAddr != null) {
      _result.closeToAddr = closeToAddr;
    }
    if (closeTo != null) {
      _result.closeTo = closeTo;
    }
    if (private != null) {
      _result.private = private;
    }
    if (total != null) {
      _result.total = total;
    }
    if (dustLimit != null) {
      _result.dustLimit = dustLimit;
    }
    if (spendable != null) {
      _result.spendable = spendable;
    }
    if (receivable != null) {
      _result.receivable = receivable;
    }
    if (theirToSelfDelay != null) {
      _result.theirToSelfDelay = theirToSelfDelay;
    }
    if (ourToSelfDelay != null) {
      _result.ourToSelfDelay = ourToSelfDelay;
    }
    if (status != null) {
      _result.status.addAll(status);
    }
    if (htlcs != null) {
      _result.htlcs.addAll(htlcs);
    }
    return _result;
  }
  factory Channel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Channel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Channel clone() => Channel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Channel copyWith(void Function(Channel) updates) =>
      super.copyWith((message) => updates(message as Channel))
          as Channel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Channel create() => Channel._();
  Channel createEmptyInstance() => create();
  static $pb.PbList<Channel> createRepeated() => $pb.PbList<Channel>();
  @$core.pragma('dart2js:noInline')
  static Channel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Channel>(create);
  static Channel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get state => $_getSZ(0);
  @$pb.TagNumber(1)
  set state($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get owner => $_getSZ(1);
  @$pb.TagNumber(2)
  set owner($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOwner() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwner() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get shortChannelId => $_getSZ(2);
  @$pb.TagNumber(3)
  set shortChannelId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasShortChannelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearShortChannelId() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get direction => $_getIZ(3);
  @$pb.TagNumber(4)
  set direction($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDirection() => $_has(3);
  @$pb.TagNumber(4)
  void clearDirection() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get channelId => $_getSZ(4);
  @$pb.TagNumber(5)
  set channelId($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasChannelId() => $_has(4);
  @$pb.TagNumber(5)
  void clearChannelId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get fundingTxid => $_getSZ(5);
  @$pb.TagNumber(6)
  set fundingTxid($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasFundingTxid() => $_has(5);
  @$pb.TagNumber(6)
  void clearFundingTxid() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get closeToAddr => $_getSZ(6);
  @$pb.TagNumber(7)
  set closeToAddr($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasCloseToAddr() => $_has(6);
  @$pb.TagNumber(7)
  void clearCloseToAddr() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get closeTo => $_getSZ(7);
  @$pb.TagNumber(8)
  set closeTo($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasCloseTo() => $_has(7);
  @$pb.TagNumber(8)
  void clearCloseTo() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get private => $_getBF(8);
  @$pb.TagNumber(9)
  set private($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPrivate() => $_has(8);
  @$pb.TagNumber(9)
  void clearPrivate() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get total => $_getSZ(9);
  @$pb.TagNumber(10)
  set total($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasTotal() => $_has(9);
  @$pb.TagNumber(10)
  void clearTotal() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get dustLimit => $_getSZ(10);
  @$pb.TagNumber(11)
  set dustLimit($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasDustLimit() => $_has(10);
  @$pb.TagNumber(11)
  void clearDustLimit() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get spendable => $_getSZ(11);
  @$pb.TagNumber(12)
  set spendable($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasSpendable() => $_has(11);
  @$pb.TagNumber(12)
  void clearSpendable() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get receivable => $_getSZ(12);
  @$pb.TagNumber(13)
  set receivable($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasReceivable() => $_has(12);
  @$pb.TagNumber(13)
  void clearReceivable() => clearField(13);

  @$pb.TagNumber(14)
  $core.int get theirToSelfDelay => $_getIZ(13);
  @$pb.TagNumber(14)
  set theirToSelfDelay($core.int v) {
    $_setUnsignedInt32(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasTheirToSelfDelay() => $_has(13);
  @$pb.TagNumber(14)
  void clearTheirToSelfDelay() => clearField(14);

  @$pb.TagNumber(15)
  $core.int get ourToSelfDelay => $_getIZ(14);
  @$pb.TagNumber(15)
  set ourToSelfDelay($core.int v) {
    $_setUnsignedInt32(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasOurToSelfDelay() => $_has(14);
  @$pb.TagNumber(15)
  void clearOurToSelfDelay() => clearField(15);

  @$pb.TagNumber(16)
  $core.List<$core.String> get status => $_getList(15);

  @$pb.TagNumber(17)
  $core.List<Htlc> get htlcs => $_getList(16);
}

class Peer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Peer',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id',
        $pb.PbFieldType.OY)
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'connected')
    ..pc<Address>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'addresses',
        $pb.PbFieldType.PM,
        subBuilder: Address.create)
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'features')
    ..pc<Channel>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'channels',
        $pb.PbFieldType.PM,
        subBuilder: Channel.create)
    ..hasRequiredFields = false;

  Peer._() : super();
  factory Peer({
    $core.List<$core.int>? id,
    $core.bool? connected,
    $core.Iterable<Address>? addresses,
    $core.String? features,
    $core.Iterable<Channel>? channels,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (connected != null) {
      _result.connected = connected;
    }
    if (addresses != null) {
      _result.addresses.addAll(addresses);
    }
    if (features != null) {
      _result.features = features;
    }
    if (channels != null) {
      _result.channels.addAll(channels);
    }
    return _result;
  }
  factory Peer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Peer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Peer clone() => Peer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Peer copyWith(void Function(Peer) updates) =>
      super.copyWith((message) => updates(message as Peer))
          as Peer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Peer create() => Peer._();
  Peer createEmptyInstance() => create();
  static $pb.PbList<Peer> createRepeated() => $pb.PbList<Peer>();
  @$core.pragma('dart2js:noInline')
  static Peer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Peer>(create);
  static Peer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get id => $_getN(0);
  @$pb.TagNumber(1)
  set id($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get connected => $_getBF(1);
  @$pb.TagNumber(2)
  set connected($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasConnected() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnected() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<Address> get addresses => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get features => $_getSZ(3);
  @$pb.TagNumber(4)
  set features($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasFeatures() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeatures() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<Channel> get channels => $_getList(4);
}

class ListPeersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListPeersResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..pc<Peer>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'peers',
        $pb.PbFieldType.PM,
        subBuilder: Peer.create)
    ..hasRequiredFields = false;

  ListPeersResponse._() : super();
  factory ListPeersResponse({
    $core.Iterable<Peer>? peers,
  }) {
    final _result = create();
    if (peers != null) {
      _result.peers.addAll(peers);
    }
    return _result;
  }
  factory ListPeersResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListPeersResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListPeersResponse clone() => ListPeersResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListPeersResponse copyWith(void Function(ListPeersResponse) updates) =>
      super.copyWith((message) => updates(message as ListPeersResponse))
          as ListPeersResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListPeersResponse create() => ListPeersResponse._();
  ListPeersResponse createEmptyInstance() => create();
  static $pb.PbList<ListPeersResponse> createRepeated() =>
      $pb.PbList<ListPeersResponse>();
  @$core.pragma('dart2js:noInline')
  static ListPeersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPeersResponse>(create);
  static ListPeersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Peer> get peers => $_getList(0);
}

class DisconnectRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DisconnectRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId')
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'force')
    ..hasRequiredFields = false;

  DisconnectRequest._() : super();
  factory DisconnectRequest({
    $core.String? nodeId,
    $core.bool? force,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (force != null) {
      _result.force = force;
    }
    return _result;
  }
  factory DisconnectRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DisconnectRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DisconnectRequest clone() => DisconnectRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DisconnectRequest copyWith(void Function(DisconnectRequest) updates) =>
      super.copyWith((message) => updates(message as DisconnectRequest))
          as DisconnectRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DisconnectRequest create() => DisconnectRequest._();
  DisconnectRequest createEmptyInstance() => create();
  static $pb.PbList<DisconnectRequest> createRepeated() =>
      $pb.PbList<DisconnectRequest>();
  @$core.pragma('dart2js:noInline')
  static DisconnectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisconnectRequest>(create);
  static DisconnectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get force => $_getBF(1);
  @$pb.TagNumber(2)
  set force($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasForce() => $_has(1);
  @$pb.TagNumber(2)
  void clearForce() => clearField(2);
}

class DisconnectResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DisconnectResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  DisconnectResponse._() : super();
  factory DisconnectResponse() => create();
  factory DisconnectResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DisconnectResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DisconnectResponse clone() => DisconnectResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DisconnectResponse copyWith(void Function(DisconnectResponse) updates) =>
      super.copyWith((message) => updates(message as DisconnectResponse))
          as DisconnectResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DisconnectResponse create() => DisconnectResponse._();
  DisconnectResponse createEmptyInstance() => create();
  static $pb.PbList<DisconnectResponse> createRepeated() =>
      $pb.PbList<DisconnectResponse>();
  @$core.pragma('dart2js:noInline')
  static DisconnectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisconnectResponse>(create);
  static DisconnectResponse? _defaultInstance;
}

class NewAddrRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NewAddrRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..e<BtcAddressType>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'addressType',
        $pb.PbFieldType.OE,
        defaultOrMaker: BtcAddressType.BECH32,
        valueOf: BtcAddressType.valueOf,
        enumValues: BtcAddressType.values)
    ..hasRequiredFields = false;

  NewAddrRequest._() : super();
  factory NewAddrRequest({
    BtcAddressType? addressType,
  }) {
    final _result = create();
    if (addressType != null) {
      _result.addressType = addressType;
    }
    return _result;
  }
  factory NewAddrRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NewAddrRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NewAddrRequest clone() => NewAddrRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NewAddrRequest copyWith(void Function(NewAddrRequest) updates) =>
      super.copyWith((message) => updates(message as NewAddrRequest))
          as NewAddrRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NewAddrRequest create() => NewAddrRequest._();
  NewAddrRequest createEmptyInstance() => create();
  static $pb.PbList<NewAddrRequest> createRepeated() =>
      $pb.PbList<NewAddrRequest>();
  @$core.pragma('dart2js:noInline')
  static NewAddrRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NewAddrRequest>(create);
  static NewAddrRequest? _defaultInstance;

  @$pb.TagNumber(1)
  BtcAddressType get addressType => $_getN(0);
  @$pb.TagNumber(1)
  set addressType(BtcAddressType v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAddressType() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddressType() => clearField(1);
}

class NewAddrResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NewAddrResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..e<BtcAddressType>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'addressType',
        $pb.PbFieldType.OE,
        defaultOrMaker: BtcAddressType.BECH32,
        valueOf: BtcAddressType.valueOf,
        enumValues: BtcAddressType.values)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'address')
    ..hasRequiredFields = false;

  NewAddrResponse._() : super();
  factory NewAddrResponse({
    BtcAddressType? addressType,
    $core.String? address,
  }) {
    final _result = create();
    if (addressType != null) {
      _result.addressType = addressType;
    }
    if (address != null) {
      _result.address = address;
    }
    return _result;
  }
  factory NewAddrResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NewAddrResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NewAddrResponse clone() => NewAddrResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NewAddrResponse copyWith(void Function(NewAddrResponse) updates) =>
      super.copyWith((message) => updates(message as NewAddrResponse))
          as NewAddrResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NewAddrResponse create() => NewAddrResponse._();
  NewAddrResponse createEmptyInstance() => create();
  static $pb.PbList<NewAddrResponse> createRepeated() =>
      $pb.PbList<NewAddrResponse>();
  @$core.pragma('dart2js:noInline')
  static NewAddrResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NewAddrResponse>(create);
  static NewAddrResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BtcAddressType get addressType => $_getN(0);
  @$pb.TagNumber(1)
  set addressType(BtcAddressType v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAddressType() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddressType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get address => $_getSZ(1);
  @$pb.TagNumber(2)
  set address($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => clearField(2);
}

class ListFundsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListFundsRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOM<Confirmation>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'minconf',
        subBuilder: Confirmation.create)
    ..hasRequiredFields = false;

  ListFundsRequest._() : super();
  factory ListFundsRequest({
    Confirmation? minconf,
  }) {
    final _result = create();
    if (minconf != null) {
      _result.minconf = minconf;
    }
    return _result;
  }
  factory ListFundsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListFundsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListFundsRequest clone() => ListFundsRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListFundsRequest copyWith(void Function(ListFundsRequest) updates) =>
      super.copyWith((message) => updates(message as ListFundsRequest))
          as ListFundsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListFundsRequest create() => ListFundsRequest._();
  ListFundsRequest createEmptyInstance() => create();
  static $pb.PbList<ListFundsRequest> createRepeated() =>
      $pb.PbList<ListFundsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListFundsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFundsRequest>(create);
  static ListFundsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Confirmation get minconf => $_getN(0);
  @$pb.TagNumber(1)
  set minconf(Confirmation v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMinconf() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinconf() => clearField(1);
  @$pb.TagNumber(1)
  Confirmation ensureMinconf() => $_ensure(0);
}

class ListFundsOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListFundsOutput',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOM<Outpoint>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'output',
        subBuilder: Outpoint.create)
    ..aOM<Amount>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount',
        subBuilder: Amount.create)
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'address')
    ..e<OutputStatus>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'status',
        $pb.PbFieldType.OE,
        defaultOrMaker: OutputStatus.CONFIRMED,
        valueOf: OutputStatus.valueOf,
        enumValues: OutputStatus.values)
    ..hasRequiredFields = false;

  ListFundsOutput._() : super();
  factory ListFundsOutput({
    Outpoint? output,
    Amount? amount,
    $core.String? address,
    OutputStatus? status,
  }) {
    final _result = create();
    if (output != null) {
      _result.output = output;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (address != null) {
      _result.address = address;
    }
    if (status != null) {
      _result.status = status;
    }
    return _result;
  }
  factory ListFundsOutput.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListFundsOutput.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListFundsOutput clone() => ListFundsOutput()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListFundsOutput copyWith(void Function(ListFundsOutput) updates) =>
      super.copyWith((message) => updates(message as ListFundsOutput))
          as ListFundsOutput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListFundsOutput create() => ListFundsOutput._();
  ListFundsOutput createEmptyInstance() => create();
  static $pb.PbList<ListFundsOutput> createRepeated() =>
      $pb.PbList<ListFundsOutput>();
  @$core.pragma('dart2js:noInline')
  static ListFundsOutput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFundsOutput>(create);
  static ListFundsOutput? _defaultInstance;

  @$pb.TagNumber(1)
  Outpoint get output => $_getN(0);
  @$pb.TagNumber(1)
  set output(Outpoint v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOutput() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutput() => clearField(1);
  @$pb.TagNumber(1)
  Outpoint ensureOutput() => $_ensure(0);

  @$pb.TagNumber(2)
  Amount get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount(Amount v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
  @$pb.TagNumber(2)
  Amount ensureAmount() => $_ensure(1);

  @$pb.TagNumber(4)
  $core.String get address => $_getSZ(2);
  @$pb.TagNumber(4)
  set address($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAddress() => $_has(2);
  @$pb.TagNumber(4)
  void clearAddress() => clearField(4);

  @$pb.TagNumber(5)
  OutputStatus get status => $_getN(3);
  @$pb.TagNumber(5)
  set status(OutputStatus v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);
}

class ListFundsChannel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListFundsChannel',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'peerId',
        $pb.PbFieldType.OY)
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'connected')
    ..a<$fixnum.Int64>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'shortChannelId',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ourAmountMsat',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amountMsat',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fundingTxid',
        $pb.PbFieldType.OY)
    ..a<$core.int>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'fundingOutput',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  ListFundsChannel._() : super();
  factory ListFundsChannel({
    $core.List<$core.int>? peerId,
    $core.bool? connected,
    $fixnum.Int64? shortChannelId,
    $fixnum.Int64? ourAmountMsat,
    $fixnum.Int64? amountMsat,
    $core.List<$core.int>? fundingTxid,
    $core.int? fundingOutput,
  }) {
    final _result = create();
    if (peerId != null) {
      _result.peerId = peerId;
    }
    if (connected != null) {
      _result.connected = connected;
    }
    if (shortChannelId != null) {
      _result.shortChannelId = shortChannelId;
    }
    if (ourAmountMsat != null) {
      _result.ourAmountMsat = ourAmountMsat;
    }
    if (amountMsat != null) {
      _result.amountMsat = amountMsat;
    }
    if (fundingTxid != null) {
      _result.fundingTxid = fundingTxid;
    }
    if (fundingOutput != null) {
      _result.fundingOutput = fundingOutput;
    }
    return _result;
  }
  factory ListFundsChannel.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListFundsChannel.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListFundsChannel clone() => ListFundsChannel()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListFundsChannel copyWith(void Function(ListFundsChannel) updates) =>
      super.copyWith((message) => updates(message as ListFundsChannel))
          as ListFundsChannel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListFundsChannel create() => ListFundsChannel._();
  ListFundsChannel createEmptyInstance() => create();
  static $pb.PbList<ListFundsChannel> createRepeated() =>
      $pb.PbList<ListFundsChannel>();
  @$core.pragma('dart2js:noInline')
  static ListFundsChannel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFundsChannel>(create);
  static ListFundsChannel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get peerId => $_getN(0);
  @$pb.TagNumber(1)
  set peerId($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get connected => $_getBF(1);
  @$pb.TagNumber(2)
  set connected($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasConnected() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnected() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get shortChannelId => $_getI64(2);
  @$pb.TagNumber(3)
  set shortChannelId($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasShortChannelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearShortChannelId() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get ourAmountMsat => $_getI64(3);
  @$pb.TagNumber(4)
  set ourAmountMsat($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasOurAmountMsat() => $_has(3);
  @$pb.TagNumber(4)
  void clearOurAmountMsat() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get amountMsat => $_getI64(4);
  @$pb.TagNumber(5)
  set amountMsat($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAmountMsat() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmountMsat() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get fundingTxid => $_getN(5);
  @$pb.TagNumber(6)
  set fundingTxid($core.List<$core.int> v) {
    $_setBytes(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasFundingTxid() => $_has(5);
  @$pb.TagNumber(6)
  void clearFundingTxid() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get fundingOutput => $_getIZ(6);
  @$pb.TagNumber(7)
  set fundingOutput($core.int v) {
    $_setUnsignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasFundingOutput() => $_has(6);
  @$pb.TagNumber(7)
  void clearFundingOutput() => clearField(7);
}

class ListFundsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListFundsResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..pc<ListFundsOutput>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'outputs',
        $pb.PbFieldType.PM,
        subBuilder: ListFundsOutput.create)
    ..pc<ListFundsChannel>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'channels',
        $pb.PbFieldType.PM,
        subBuilder: ListFundsChannel.create)
    ..hasRequiredFields = false;

  ListFundsResponse._() : super();
  factory ListFundsResponse({
    $core.Iterable<ListFundsOutput>? outputs,
    $core.Iterable<ListFundsChannel>? channels,
  }) {
    final _result = create();
    if (outputs != null) {
      _result.outputs.addAll(outputs);
    }
    if (channels != null) {
      _result.channels.addAll(channels);
    }
    return _result;
  }
  factory ListFundsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListFundsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListFundsResponse clone() => ListFundsResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListFundsResponse copyWith(void Function(ListFundsResponse) updates) =>
      super.copyWith((message) => updates(message as ListFundsResponse))
          as ListFundsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListFundsResponse create() => ListFundsResponse._();
  ListFundsResponse createEmptyInstance() => create();
  static $pb.PbList<ListFundsResponse> createRepeated() =>
      $pb.PbList<ListFundsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListFundsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFundsResponse>(create);
  static ListFundsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ListFundsOutput> get outputs => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<ListFundsChannel> get channels => $_getList(1);
}

enum Feerate_Value { preset, perkw, perkb, notSet }

class Feerate extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Feerate_Value> _Feerate_ValueByTag = {
    1: Feerate_Value.preset,
    5: Feerate_Value.perkw,
    6: Feerate_Value.perkb,
    0: Feerate_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Feerate',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..oo(0, [1, 5, 6])
    ..e<FeeratePreset>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'preset',
        $pb.PbFieldType.OE,
        defaultOrMaker: FeeratePreset.NORMAL,
        valueOf: FeeratePreset.valueOf,
        enumValues: FeeratePreset.values)
    ..a<$fixnum.Int64>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'perkw',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'perkb',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  Feerate._() : super();
  factory Feerate({
    FeeratePreset? preset,
    $fixnum.Int64? perkw,
    $fixnum.Int64? perkb,
  }) {
    final _result = create();
    if (preset != null) {
      _result.preset = preset;
    }
    if (perkw != null) {
      _result.perkw = perkw;
    }
    if (perkb != null) {
      _result.perkb = perkb;
    }
    return _result;
  }
  factory Feerate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Feerate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Feerate clone() => Feerate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Feerate copyWith(void Function(Feerate) updates) =>
      super.copyWith((message) => updates(message as Feerate))
          as Feerate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Feerate create() => Feerate._();
  Feerate createEmptyInstance() => create();
  static $pb.PbList<Feerate> createRepeated() => $pb.PbList<Feerate>();
  @$core.pragma('dart2js:noInline')
  static Feerate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Feerate>(create);
  static Feerate? _defaultInstance;

  Feerate_Value whichValue() => _Feerate_ValueByTag[$_whichOneof(0)]!;
  void clearValue() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  FeeratePreset get preset => $_getN(0);
  @$pb.TagNumber(1)
  set preset(FeeratePreset v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPreset() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreset() => clearField(1);

  @$pb.TagNumber(5)
  $fixnum.Int64 get perkw => $_getI64(1);
  @$pb.TagNumber(5)
  set perkw($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPerkw() => $_has(1);
  @$pb.TagNumber(5)
  void clearPerkw() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get perkb => $_getI64(2);
  @$pb.TagNumber(6)
  set perkb($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPerkb() => $_has(2);
  @$pb.TagNumber(6)
  void clearPerkb() => clearField(6);
}

class Confirmation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Confirmation',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'blocks',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  Confirmation._() : super();
  factory Confirmation({
    $core.int? blocks,
  }) {
    final _result = create();
    if (blocks != null) {
      _result.blocks = blocks;
    }
    return _result;
  }
  factory Confirmation.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Confirmation.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Confirmation clone() => Confirmation()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Confirmation copyWith(void Function(Confirmation) updates) =>
      super.copyWith((message) => updates(message as Confirmation))
          as Confirmation; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Confirmation create() => Confirmation._();
  Confirmation createEmptyInstance() => create();
  static $pb.PbList<Confirmation> createRepeated() =>
      $pb.PbList<Confirmation>();
  @$core.pragma('dart2js:noInline')
  static Confirmation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Confirmation>(create);
  static Confirmation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get blocks => $_getIZ(0);
  @$pb.TagNumber(1)
  set blocks($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBlocks() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlocks() => clearField(1);
}

class WithdrawRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'WithdrawRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'destination')
    ..aOM<Amount>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount',
        subBuilder: Amount.create)
    ..aOM<Feerate>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'feerate',
        subBuilder: Feerate.create)
    ..aOM<Confirmation>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'minconf',
        subBuilder: Confirmation.create)
    ..pc<Outpoint>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'utxos',
        $pb.PbFieldType.PM,
        subBuilder: Outpoint.create)
    ..hasRequiredFields = false;

  WithdrawRequest._() : super();
  factory WithdrawRequest({
    $core.String? destination,
    Amount? amount,
    Feerate? feerate,
    Confirmation? minconf,
    $core.Iterable<Outpoint>? utxos,
  }) {
    final _result = create();
    if (destination != null) {
      _result.destination = destination;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (feerate != null) {
      _result.feerate = feerate;
    }
    if (minconf != null) {
      _result.minconf = minconf;
    }
    if (utxos != null) {
      _result.utxos.addAll(utxos);
    }
    return _result;
  }
  factory WithdrawRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory WithdrawRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  WithdrawRequest clone() => WithdrawRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  WithdrawRequest copyWith(void Function(WithdrawRequest) updates) =>
      super.copyWith((message) => updates(message as WithdrawRequest))
          as WithdrawRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WithdrawRequest create() => WithdrawRequest._();
  WithdrawRequest createEmptyInstance() => create();
  static $pb.PbList<WithdrawRequest> createRepeated() =>
      $pb.PbList<WithdrawRequest>();
  @$core.pragma('dart2js:noInline')
  static WithdrawRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawRequest>(create);
  static WithdrawRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get destination => $_getSZ(0);
  @$pb.TagNumber(1)
  set destination($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDestination() => $_has(0);
  @$pb.TagNumber(1)
  void clearDestination() => clearField(1);

  @$pb.TagNumber(2)
  Amount get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount(Amount v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
  @$pb.TagNumber(2)
  Amount ensureAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  Feerate get feerate => $_getN(2);
  @$pb.TagNumber(3)
  set feerate(Feerate v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFeerate() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeerate() => clearField(3);
  @$pb.TagNumber(3)
  Feerate ensureFeerate() => $_ensure(2);

  @$pb.TagNumber(7)
  Confirmation get minconf => $_getN(3);
  @$pb.TagNumber(7)
  set minconf(Confirmation v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasMinconf() => $_has(3);
  @$pb.TagNumber(7)
  void clearMinconf() => clearField(7);
  @$pb.TagNumber(7)
  Confirmation ensureMinconf() => $_ensure(3);

  @$pb.TagNumber(8)
  $core.List<Outpoint> get utxos => $_getList(4);
}

class WithdrawResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'WithdrawResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tx',
        $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'txid',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  WithdrawResponse._() : super();
  factory WithdrawResponse({
    $core.List<$core.int>? tx,
    $core.List<$core.int>? txid,
  }) {
    final _result = create();
    if (tx != null) {
      _result.tx = tx;
    }
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory WithdrawResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory WithdrawResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  WithdrawResponse clone() => WithdrawResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  WithdrawResponse copyWith(void Function(WithdrawResponse) updates) =>
      super.copyWith((message) => updates(message as WithdrawResponse))
          as WithdrawResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WithdrawResponse create() => WithdrawResponse._();
  WithdrawResponse createEmptyInstance() => create();
  static $pb.PbList<WithdrawResponse> createRepeated() =>
      $pb.PbList<WithdrawResponse>();
  @$core.pragma('dart2js:noInline')
  static WithdrawResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawResponse>(create);
  static WithdrawResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get tx => $_getN(0);
  @$pb.TagNumber(1)
  set tx($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTx() => $_has(0);
  @$pb.TagNumber(1)
  void clearTx() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get txid => $_getN(1);
  @$pb.TagNumber(2)
  set txid($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTxid() => $_has(1);
  @$pb.TagNumber(2)
  void clearTxid() => clearField(2);
}

class FundChannelRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'FundChannelRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId',
        $pb.PbFieldType.OY)
    ..aOM<Amount>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount',
        subBuilder: Amount.create)
    ..aOM<Feerate>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'feerate',
        subBuilder: Feerate.create)
    ..aOB(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'announce')
    ..aOM<Confirmation>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'minconf',
        subBuilder: Confirmation.create)
    ..aOS(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'closeTo')
    ..hasRequiredFields = false;

  FundChannelRequest._() : super();
  factory FundChannelRequest({
    $core.List<$core.int>? nodeId,
    Amount? amount,
    Feerate? feerate,
    $core.bool? announce,
    Confirmation? minconf,
    $core.String? closeTo,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (feerate != null) {
      _result.feerate = feerate;
    }
    if (announce != null) {
      _result.announce = announce;
    }
    if (minconf != null) {
      _result.minconf = minconf;
    }
    if (closeTo != null) {
      _result.closeTo = closeTo;
    }
    return _result;
  }
  factory FundChannelRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory FundChannelRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  FundChannelRequest clone() => FundChannelRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  FundChannelRequest copyWith(void Function(FundChannelRequest) updates) =>
      super.copyWith((message) => updates(message as FundChannelRequest))
          as FundChannelRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FundChannelRequest create() => FundChannelRequest._();
  FundChannelRequest createEmptyInstance() => create();
  static $pb.PbList<FundChannelRequest> createRepeated() =>
      $pb.PbList<FundChannelRequest>();
  @$core.pragma('dart2js:noInline')
  static FundChannelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FundChannelRequest>(create);
  static FundChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  Amount get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount(Amount v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
  @$pb.TagNumber(2)
  Amount ensureAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  Feerate get feerate => $_getN(2);
  @$pb.TagNumber(3)
  set feerate(Feerate v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFeerate() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeerate() => clearField(3);
  @$pb.TagNumber(3)
  Feerate ensureFeerate() => $_ensure(2);

  @$pb.TagNumber(7)
  $core.bool get announce => $_getBF(3);
  @$pb.TagNumber(7)
  set announce($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasAnnounce() => $_has(3);
  @$pb.TagNumber(7)
  void clearAnnounce() => clearField(7);

  @$pb.TagNumber(8)
  Confirmation get minconf => $_getN(4);
  @$pb.TagNumber(8)
  set minconf(Confirmation v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasMinconf() => $_has(4);
  @$pb.TagNumber(8)
  void clearMinconf() => clearField(8);
  @$pb.TagNumber(8)
  Confirmation ensureMinconf() => $_ensure(4);

  @$pb.TagNumber(10)
  $core.String get closeTo => $_getSZ(5);
  @$pb.TagNumber(10)
  set closeTo($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasCloseTo() => $_has(5);
  @$pb.TagNumber(10)
  void clearCloseTo() => clearField(10);
}

class Outpoint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Outpoint',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'txid',
        $pb.PbFieldType.OY)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'outnum',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  Outpoint._() : super();
  factory Outpoint({
    $core.List<$core.int>? txid,
    $core.int? outnum,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    if (outnum != null) {
      _result.outnum = outnum;
    }
    return _result;
  }
  factory Outpoint.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Outpoint.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Outpoint clone() => Outpoint()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Outpoint copyWith(void Function(Outpoint) updates) =>
      super.copyWith((message) => updates(message as Outpoint))
          as Outpoint; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Outpoint create() => Outpoint._();
  Outpoint createEmptyInstance() => create();
  static $pb.PbList<Outpoint> createRepeated() => $pb.PbList<Outpoint>();
  @$core.pragma('dart2js:noInline')
  static Outpoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Outpoint>(create);
  static Outpoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txid => $_getN(0);
  @$pb.TagNumber(1)
  set txid($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get outnum => $_getIZ(1);
  @$pb.TagNumber(2)
  set outnum($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOutnum() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutnum() => clearField(2);
}

class FundChannelResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'FundChannelResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tx',
        $pb.PbFieldType.OY)
    ..aOM<Outpoint>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'outpoint',
        subBuilder: Outpoint.create)
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'channelId',
        $pb.PbFieldType.OY)
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'closeTo')
    ..hasRequiredFields = false;

  FundChannelResponse._() : super();
  factory FundChannelResponse({
    $core.List<$core.int>? tx,
    Outpoint? outpoint,
    $core.List<$core.int>? channelId,
    $core.String? closeTo,
  }) {
    final _result = create();
    if (tx != null) {
      _result.tx = tx;
    }
    if (outpoint != null) {
      _result.outpoint = outpoint;
    }
    if (channelId != null) {
      _result.channelId = channelId;
    }
    if (closeTo != null) {
      _result.closeTo = closeTo;
    }
    return _result;
  }
  factory FundChannelResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory FundChannelResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  FundChannelResponse clone() => FundChannelResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  FundChannelResponse copyWith(void Function(FundChannelResponse) updates) =>
      super.copyWith((message) => updates(message as FundChannelResponse))
          as FundChannelResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FundChannelResponse create() => FundChannelResponse._();
  FundChannelResponse createEmptyInstance() => create();
  static $pb.PbList<FundChannelResponse> createRepeated() =>
      $pb.PbList<FundChannelResponse>();
  @$core.pragma('dart2js:noInline')
  static FundChannelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FundChannelResponse>(create);
  static FundChannelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get tx => $_getN(0);
  @$pb.TagNumber(1)
  set tx($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTx() => $_has(0);
  @$pb.TagNumber(1)
  void clearTx() => clearField(1);

  @$pb.TagNumber(2)
  Outpoint get outpoint => $_getN(1);
  @$pb.TagNumber(2)
  set outpoint(Outpoint v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOutpoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutpoint() => clearField(2);
  @$pb.TagNumber(2)
  Outpoint ensureOutpoint() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get channelId => $_getN(2);
  @$pb.TagNumber(3)
  set channelId($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasChannelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannelId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get closeTo => $_getSZ(3);
  @$pb.TagNumber(4)
  set closeTo($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCloseTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearCloseTo() => clearField(4);
}

class Timeout extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Timeout',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seconds',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  Timeout._() : super();
  factory Timeout({
    $core.int? seconds,
  }) {
    final _result = create();
    if (seconds != null) {
      _result.seconds = seconds;
    }
    return _result;
  }
  factory Timeout.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Timeout.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Timeout clone() => Timeout()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Timeout copyWith(void Function(Timeout) updates) =>
      super.copyWith((message) => updates(message as Timeout))
          as Timeout; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Timeout create() => Timeout._();
  Timeout createEmptyInstance() => create();
  static $pb.PbList<Timeout> createRepeated() => $pb.PbList<Timeout>();
  @$core.pragma('dart2js:noInline')
  static Timeout getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Timeout>(create);
  static Timeout? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seconds => $_getIZ(0);
  @$pb.TagNumber(1)
  set seconds($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeconds() => clearField(1);
}

class BitcoinAddress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'BitcoinAddress',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'address')
    ..hasRequiredFields = false;

  BitcoinAddress._() : super();
  factory BitcoinAddress({
    $core.String? address,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    return _result;
  }
  factory BitcoinAddress.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BitcoinAddress.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BitcoinAddress clone() => BitcoinAddress()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BitcoinAddress copyWith(void Function(BitcoinAddress) updates) =>
      super.copyWith((message) => updates(message as BitcoinAddress))
          as BitcoinAddress; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BitcoinAddress create() => BitcoinAddress._();
  BitcoinAddress createEmptyInstance() => create();
  static $pb.PbList<BitcoinAddress> createRepeated() =>
      $pb.PbList<BitcoinAddress>();
  @$core.pragma('dart2js:noInline')
  static BitcoinAddress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BitcoinAddress>(create);
  static BitcoinAddress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class CloseChannelRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CloseChannelRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId',
        $pb.PbFieldType.OY)
    ..aOM<Timeout>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'unilateraltimeout',
        subBuilder: Timeout.create)
    ..aOM<BitcoinAddress>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'destination',
        subBuilder: BitcoinAddress.create)
    ..hasRequiredFields = false;

  CloseChannelRequest._() : super();
  factory CloseChannelRequest({
    $core.List<$core.int>? nodeId,
    Timeout? unilateraltimeout,
    BitcoinAddress? destination,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (unilateraltimeout != null) {
      _result.unilateraltimeout = unilateraltimeout;
    }
    if (destination != null) {
      _result.destination = destination;
    }
    return _result;
  }
  factory CloseChannelRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CloseChannelRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CloseChannelRequest clone() => CloseChannelRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CloseChannelRequest copyWith(void Function(CloseChannelRequest) updates) =>
      super.copyWith((message) => updates(message as CloseChannelRequest))
          as CloseChannelRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CloseChannelRequest create() => CloseChannelRequest._();
  CloseChannelRequest createEmptyInstance() => create();
  static $pb.PbList<CloseChannelRequest> createRepeated() =>
      $pb.PbList<CloseChannelRequest>();
  @$core.pragma('dart2js:noInline')
  static CloseChannelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseChannelRequest>(create);
  static CloseChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  Timeout get unilateraltimeout => $_getN(1);
  @$pb.TagNumber(2)
  set unilateraltimeout(Timeout v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUnilateraltimeout() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnilateraltimeout() => clearField(2);
  @$pb.TagNumber(2)
  Timeout ensureUnilateraltimeout() => $_ensure(1);

  @$pb.TagNumber(3)
  BitcoinAddress get destination => $_getN(2);
  @$pb.TagNumber(3)
  set destination(BitcoinAddress v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDestination() => $_has(2);
  @$pb.TagNumber(3)
  void clearDestination() => clearField(3);
  @$pb.TagNumber(3)
  BitcoinAddress ensureDestination() => $_ensure(2);
}

class CloseChannelResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CloseChannelResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..e<CloseChannelType>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'closeType',
        $pb.PbFieldType.OE,
        defaultOrMaker: CloseChannelType.MUTUAL,
        valueOf: CloseChannelType.valueOf,
        enumValues: CloseChannelType.values)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tx',
        $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'txid',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  CloseChannelResponse._() : super();
  factory CloseChannelResponse({
    CloseChannelType? closeType,
    $core.List<$core.int>? tx,
    $core.List<$core.int>? txid,
  }) {
    final _result = create();
    if (closeType != null) {
      _result.closeType = closeType;
    }
    if (tx != null) {
      _result.tx = tx;
    }
    if (txid != null) {
      _result.txid = txid;
    }
    return _result;
  }
  factory CloseChannelResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CloseChannelResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CloseChannelResponse clone() =>
      CloseChannelResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CloseChannelResponse copyWith(void Function(CloseChannelResponse) updates) =>
      super.copyWith((message) => updates(message as CloseChannelResponse))
          as CloseChannelResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CloseChannelResponse create() => CloseChannelResponse._();
  CloseChannelResponse createEmptyInstance() => create();
  static $pb.PbList<CloseChannelResponse> createRepeated() =>
      $pb.PbList<CloseChannelResponse>();
  @$core.pragma('dart2js:noInline')
  static CloseChannelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseChannelResponse>(create);
  static CloseChannelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CloseChannelType get closeType => $_getN(0);
  @$pb.TagNumber(1)
  set closeType(CloseChannelType v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCloseType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCloseType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get tx => $_getN(1);
  @$pb.TagNumber(2)
  set tx($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTx() => $_has(1);
  @$pb.TagNumber(2)
  void clearTx() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get txid => $_getN(2);
  @$pb.TagNumber(3)
  set txid($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTxid() => $_has(2);
  @$pb.TagNumber(3)
  void clearTxid() => clearField(3);
}

enum Amount_Unit { millisatoshi, satoshi, bitcoin, all, any, notSet }

class Amount extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Amount_Unit> _Amount_UnitByTag = {
    1: Amount_Unit.millisatoshi,
    2: Amount_Unit.satoshi,
    3: Amount_Unit.bitcoin,
    4: Amount_Unit.all,
    5: Amount_Unit.any,
    0: Amount_Unit.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Amount',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..a<$fixnum.Int64>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'millisatoshi',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'satoshi',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bitcoin',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'all')
    ..aOB(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'any')
    ..hasRequiredFields = false;

  Amount._() : super();
  factory Amount({
    $fixnum.Int64? millisatoshi,
    $fixnum.Int64? satoshi,
    $fixnum.Int64? bitcoin,
    $core.bool? all,
    $core.bool? any,
  }) {
    final _result = create();
    if (millisatoshi != null) {
      _result.millisatoshi = millisatoshi;
    }
    if (satoshi != null) {
      _result.satoshi = satoshi;
    }
    if (bitcoin != null) {
      _result.bitcoin = bitcoin;
    }
    if (all != null) {
      _result.all = all;
    }
    if (any != null) {
      _result.any = any;
    }
    return _result;
  }
  factory Amount.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Amount.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Amount clone() => Amount()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Amount copyWith(void Function(Amount) updates) =>
      super.copyWith((message) => updates(message as Amount))
          as Amount; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Amount create() => Amount._();
  Amount createEmptyInstance() => create();
  static $pb.PbList<Amount> createRepeated() => $pb.PbList<Amount>();
  @$core.pragma('dart2js:noInline')
  static Amount getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Amount>(create);
  static Amount? _defaultInstance;

  Amount_Unit whichUnit() => _Amount_UnitByTag[$_whichOneof(0)]!;
  void clearUnit() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get millisatoshi => $_getI64(0);
  @$pb.TagNumber(1)
  set millisatoshi($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMillisatoshi() => $_has(0);
  @$pb.TagNumber(1)
  void clearMillisatoshi() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get satoshi => $_getI64(1);
  @$pb.TagNumber(2)
  set satoshi($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSatoshi() => $_has(1);
  @$pb.TagNumber(2)
  void clearSatoshi() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get bitcoin => $_getI64(2);
  @$pb.TagNumber(3)
  set bitcoin($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasBitcoin() => $_has(2);
  @$pb.TagNumber(3)
  void clearBitcoin() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get all => $_getBF(3);
  @$pb.TagNumber(4)
  set all($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAll() => $_has(3);
  @$pb.TagNumber(4)
  void clearAll() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get any => $_getBF(4);
  @$pb.TagNumber(5)
  set any($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAny() => $_has(4);
  @$pb.TagNumber(5)
  void clearAny() => clearField(5);
}

class InvoiceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'InvoiceRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOM<Amount>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount',
        subBuilder: Amount.create)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'description')
    ..hasRequiredFields = false;

  InvoiceRequest._() : super();
  factory InvoiceRequest({
    Amount? amount,
    $core.String? label,
    $core.String? description,
  }) {
    final _result = create();
    if (amount != null) {
      _result.amount = amount;
    }
    if (label != null) {
      _result.label = label;
    }
    if (description != null) {
      _result.description = description;
    }
    return _result;
  }
  factory InvoiceRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InvoiceRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InvoiceRequest clone() => InvoiceRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InvoiceRequest copyWith(void Function(InvoiceRequest) updates) =>
      super.copyWith((message) => updates(message as InvoiceRequest))
          as InvoiceRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InvoiceRequest create() => InvoiceRequest._();
  InvoiceRequest createEmptyInstance() => create();
  static $pb.PbList<InvoiceRequest> createRepeated() =>
      $pb.PbList<InvoiceRequest>();
  @$core.pragma('dart2js:noInline')
  static InvoiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvoiceRequest>(create);
  static InvoiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Amount get amount => $_getN(0);
  @$pb.TagNumber(1)
  set amount(Amount v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => clearField(1);
  @$pb.TagNumber(1)
  Amount ensureAmount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => clearField(3);
}

class Invoice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Invoice',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'description')
    ..aOM<Amount>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount',
        subBuilder: Amount.create)
    ..aOM<Amount>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'received',
        subBuilder: Amount.create)
    ..e<InvoiceStatus>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'status',
        $pb.PbFieldType.OE,
        defaultOrMaker: InvoiceStatus.UNPAID,
        valueOf: InvoiceStatus.valueOf,
        enumValues: InvoiceStatus.values)
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentTime',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'expiryTime',
        $pb.PbFieldType.OU3)
    ..aOS(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bolt11')
    ..a<$core.List<$core.int>>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentHash',
        $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentPreimage',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  Invoice._() : super();
  factory Invoice({
    $core.String? label,
    $core.String? description,
    Amount? amount,
    Amount? received,
    InvoiceStatus? status,
    $core.int? paymentTime,
    $core.int? expiryTime,
    $core.String? bolt11,
    $core.List<$core.int>? paymentHash,
    $core.List<$core.int>? paymentPreimage,
  }) {
    final _result = create();
    if (label != null) {
      _result.label = label;
    }
    if (description != null) {
      _result.description = description;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (received != null) {
      _result.received = received;
    }
    if (status != null) {
      _result.status = status;
    }
    if (paymentTime != null) {
      _result.paymentTime = paymentTime;
    }
    if (expiryTime != null) {
      _result.expiryTime = expiryTime;
    }
    if (bolt11 != null) {
      _result.bolt11 = bolt11;
    }
    if (paymentHash != null) {
      _result.paymentHash = paymentHash;
    }
    if (paymentPreimage != null) {
      _result.paymentPreimage = paymentPreimage;
    }
    return _result;
  }
  factory Invoice.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Invoice.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Invoice clone() => Invoice()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Invoice copyWith(void Function(Invoice) updates) =>
      super.copyWith((message) => updates(message as Invoice))
          as Invoice; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Invoice create() => Invoice._();
  Invoice createEmptyInstance() => create();
  static $pb.PbList<Invoice> createRepeated() => $pb.PbList<Invoice>();
  @$core.pragma('dart2js:noInline')
  static Invoice getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Invoice>(create);
  static Invoice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get label => $_getSZ(0);
  @$pb.TagNumber(1)
  set label($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => clearField(2);

  @$pb.TagNumber(3)
  Amount get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount(Amount v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
  @$pb.TagNumber(3)
  Amount ensureAmount() => $_ensure(2);

  @$pb.TagNumber(4)
  Amount get received => $_getN(3);
  @$pb.TagNumber(4)
  set received(Amount v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasReceived() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceived() => clearField(4);
  @$pb.TagNumber(4)
  Amount ensureReceived() => $_ensure(3);

  @$pb.TagNumber(5)
  InvoiceStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(InvoiceStatus v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get paymentTime => $_getIZ(5);
  @$pb.TagNumber(6)
  set paymentTime($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPaymentTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearPaymentTime() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get expiryTime => $_getIZ(6);
  @$pb.TagNumber(7)
  set expiryTime($core.int v) {
    $_setUnsignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasExpiryTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpiryTime() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get bolt11 => $_getSZ(7);
  @$pb.TagNumber(8)
  set bolt11($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasBolt11() => $_has(7);
  @$pb.TagNumber(8)
  void clearBolt11() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get paymentHash => $_getN(8);
  @$pb.TagNumber(9)
  set paymentHash($core.List<$core.int> v) {
    $_setBytes(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPaymentHash() => $_has(8);
  @$pb.TagNumber(9)
  void clearPaymentHash() => clearField(9);

  @$pb.TagNumber(10)
  $core.List<$core.int> get paymentPreimage => $_getN(9);
  @$pb.TagNumber(10)
  set paymentPreimage($core.List<$core.int> v) {
    $_setBytes(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasPaymentPreimage() => $_has(9);
  @$pb.TagNumber(10)
  void clearPaymentPreimage() => clearField(10);
}

class PayRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PayRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bolt11')
    ..aOM<Amount>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount',
        subBuilder: Amount.create)
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timeout',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  PayRequest._() : super();
  factory PayRequest({
    $core.String? bolt11,
    Amount? amount,
    $core.int? timeout,
  }) {
    final _result = create();
    if (bolt11 != null) {
      _result.bolt11 = bolt11;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (timeout != null) {
      _result.timeout = timeout;
    }
    return _result;
  }
  factory PayRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PayRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PayRequest clone() => PayRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PayRequest copyWith(void Function(PayRequest) updates) =>
      super.copyWith((message) => updates(message as PayRequest))
          as PayRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PayRequest create() => PayRequest._();
  PayRequest createEmptyInstance() => create();
  static $pb.PbList<PayRequest> createRepeated() => $pb.PbList<PayRequest>();
  @$core.pragma('dart2js:noInline')
  static PayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PayRequest>(create);
  static PayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bolt11 => $_getSZ(0);
  @$pb.TagNumber(1)
  set bolt11($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBolt11() => $_has(0);
  @$pb.TagNumber(1)
  void clearBolt11() => clearField(1);

  @$pb.TagNumber(2)
  Amount get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount(Amount v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
  @$pb.TagNumber(2)
  Amount ensureAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get timeout => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeout($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTimeout() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeout() => clearField(3);
}

class Payment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Payment',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'destination',
        $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentHash',
        $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentPreimage',
        $pb.PbFieldType.OY)
    ..e<PayStatus>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'status',
        $pb.PbFieldType.OE,
        defaultOrMaker: PayStatus.PENDING,
        valueOf: PayStatus.valueOf,
        enumValues: PayStatus.values)
    ..aOM<Amount>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount',
        subBuilder: Amount.create)
    ..aOM<Amount>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amountSent',
        subBuilder: Amount.create)
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bolt11')
    ..a<$core.double>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'createdAt',
        $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  Payment._() : super();
  factory Payment({
    $core.List<$core.int>? destination,
    $core.List<$core.int>? paymentHash,
    $core.List<$core.int>? paymentPreimage,
    PayStatus? status,
    Amount? amount,
    Amount? amountSent,
    $core.String? bolt11,
    $core.double? createdAt,
  }) {
    final _result = create();
    if (destination != null) {
      _result.destination = destination;
    }
    if (paymentHash != null) {
      _result.paymentHash = paymentHash;
    }
    if (paymentPreimage != null) {
      _result.paymentPreimage = paymentPreimage;
    }
    if (status != null) {
      _result.status = status;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (amountSent != null) {
      _result.amountSent = amountSent;
    }
    if (bolt11 != null) {
      _result.bolt11 = bolt11;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    return _result;
  }
  factory Payment.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Payment.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Payment clone() => Payment()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Payment copyWith(void Function(Payment) updates) =>
      super.copyWith((message) => updates(message as Payment))
          as Payment; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Payment create() => Payment._();
  Payment createEmptyInstance() => create();
  static $pb.PbList<Payment> createRepeated() => $pb.PbList<Payment>();
  @$core.pragma('dart2js:noInline')
  static Payment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Payment>(create);
  static Payment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get destination => $_getN(0);
  @$pb.TagNumber(1)
  set destination($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDestination() => $_has(0);
  @$pb.TagNumber(1)
  void clearDestination() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get paymentHash => $_getN(1);
  @$pb.TagNumber(2)
  set paymentHash($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPaymentHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentHash() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get paymentPreimage => $_getN(2);
  @$pb.TagNumber(3)
  set paymentPreimage($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPaymentPreimage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaymentPreimage() => clearField(3);

  @$pb.TagNumber(4)
  PayStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(PayStatus v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  @$pb.TagNumber(5)
  Amount get amount => $_getN(4);
  @$pb.TagNumber(5)
  set amount(Amount v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmount() => clearField(5);
  @$pb.TagNumber(5)
  Amount ensureAmount() => $_ensure(4);

  @$pb.TagNumber(6)
  Amount get amountSent => $_getN(5);
  @$pb.TagNumber(6)
  set amountSent(Amount v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasAmountSent() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmountSent() => clearField(6);
  @$pb.TagNumber(6)
  Amount ensureAmountSent() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get bolt11 => $_getSZ(6);
  @$pb.TagNumber(7)
  set bolt11($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasBolt11() => $_has(6);
  @$pb.TagNumber(7)
  void clearBolt11() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($core.double v) {
    $_setDouble(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => clearField(8);
}

enum PaymentIdentifier_Id { bolt11, paymentHash, notSet }

class PaymentIdentifier extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, PaymentIdentifier_Id>
      _PaymentIdentifier_IdByTag = {
    1: PaymentIdentifier_Id.bolt11,
    2: PaymentIdentifier_Id.paymentHash,
    0: PaymentIdentifier_Id.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PaymentIdentifier',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bolt11')
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentHash',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  PaymentIdentifier._() : super();
  factory PaymentIdentifier({
    $core.String? bolt11,
    $core.List<$core.int>? paymentHash,
  }) {
    final _result = create();
    if (bolt11 != null) {
      _result.bolt11 = bolt11;
    }
    if (paymentHash != null) {
      _result.paymentHash = paymentHash;
    }
    return _result;
  }
  factory PaymentIdentifier.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PaymentIdentifier.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PaymentIdentifier clone() => PaymentIdentifier()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PaymentIdentifier copyWith(void Function(PaymentIdentifier) updates) =>
      super.copyWith((message) => updates(message as PaymentIdentifier))
          as PaymentIdentifier; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PaymentIdentifier create() => PaymentIdentifier._();
  PaymentIdentifier createEmptyInstance() => create();
  static $pb.PbList<PaymentIdentifier> createRepeated() =>
      $pb.PbList<PaymentIdentifier>();
  @$core.pragma('dart2js:noInline')
  static PaymentIdentifier getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaymentIdentifier>(create);
  static PaymentIdentifier? _defaultInstance;

  PaymentIdentifier_Id whichId() =>
      _PaymentIdentifier_IdByTag[$_whichOneof(0)]!;
  void clearId() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get bolt11 => $_getSZ(0);
  @$pb.TagNumber(1)
  set bolt11($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBolt11() => $_has(0);
  @$pb.TagNumber(1)
  void clearBolt11() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get paymentHash => $_getN(1);
  @$pb.TagNumber(2)
  set paymentHash($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPaymentHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentHash() => clearField(2);
}

class ListPaymentsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListPaymentsRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOM<PaymentIdentifier>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'identifier',
        subBuilder: PaymentIdentifier.create)
    ..hasRequiredFields = false;

  ListPaymentsRequest._() : super();
  factory ListPaymentsRequest({
    PaymentIdentifier? identifier,
  }) {
    final _result = create();
    if (identifier != null) {
      _result.identifier = identifier;
    }
    return _result;
  }
  factory ListPaymentsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListPaymentsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListPaymentsRequest clone() => ListPaymentsRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListPaymentsRequest copyWith(void Function(ListPaymentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPaymentsRequest))
          as ListPaymentsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListPaymentsRequest create() => ListPaymentsRequest._();
  ListPaymentsRequest createEmptyInstance() => create();
  static $pb.PbList<ListPaymentsRequest> createRepeated() =>
      $pb.PbList<ListPaymentsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPaymentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPaymentsRequest>(create);
  static ListPaymentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  PaymentIdentifier get identifier => $_getN(0);
  @$pb.TagNumber(1)
  set identifier(PaymentIdentifier v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasIdentifier() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifier() => clearField(1);
  @$pb.TagNumber(1)
  PaymentIdentifier ensureIdentifier() => $_ensure(0);
}

class ListPaymentsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListPaymentsResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..pc<Payment>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'payments',
        $pb.PbFieldType.PM,
        subBuilder: Payment.create)
    ..hasRequiredFields = false;

  ListPaymentsResponse._() : super();
  factory ListPaymentsResponse({
    $core.Iterable<Payment>? payments,
  }) {
    final _result = create();
    if (payments != null) {
      _result.payments.addAll(payments);
    }
    return _result;
  }
  factory ListPaymentsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListPaymentsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListPaymentsResponse clone() =>
      ListPaymentsResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListPaymentsResponse copyWith(void Function(ListPaymentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPaymentsResponse))
          as ListPaymentsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListPaymentsResponse create() => ListPaymentsResponse._();
  ListPaymentsResponse createEmptyInstance() => create();
  static $pb.PbList<ListPaymentsResponse> createRepeated() =>
      $pb.PbList<ListPaymentsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListPaymentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPaymentsResponse>(create);
  static ListPaymentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Payment> get payments => $_getList(0);
}

enum InvoiceIdentifier_Id { label, invstring, paymentHash, notSet }

class InvoiceIdentifier extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, InvoiceIdentifier_Id>
      _InvoiceIdentifier_IdByTag = {
    1: InvoiceIdentifier_Id.label,
    2: InvoiceIdentifier_Id.invstring,
    3: InvoiceIdentifier_Id.paymentHash,
    0: InvoiceIdentifier_Id.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'InvoiceIdentifier',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'invstring')
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentHash',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  InvoiceIdentifier._() : super();
  factory InvoiceIdentifier({
    $core.String? label,
    $core.String? invstring,
    $core.List<$core.int>? paymentHash,
  }) {
    final _result = create();
    if (label != null) {
      _result.label = label;
    }
    if (invstring != null) {
      _result.invstring = invstring;
    }
    if (paymentHash != null) {
      _result.paymentHash = paymentHash;
    }
    return _result;
  }
  factory InvoiceIdentifier.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InvoiceIdentifier.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InvoiceIdentifier clone() => InvoiceIdentifier()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InvoiceIdentifier copyWith(void Function(InvoiceIdentifier) updates) =>
      super.copyWith((message) => updates(message as InvoiceIdentifier))
          as InvoiceIdentifier; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InvoiceIdentifier create() => InvoiceIdentifier._();
  InvoiceIdentifier createEmptyInstance() => create();
  static $pb.PbList<InvoiceIdentifier> createRepeated() =>
      $pb.PbList<InvoiceIdentifier>();
  @$core.pragma('dart2js:noInline')
  static InvoiceIdentifier getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvoiceIdentifier>(create);
  static InvoiceIdentifier? _defaultInstance;

  InvoiceIdentifier_Id whichId() =>
      _InvoiceIdentifier_IdByTag[$_whichOneof(0)]!;
  void clearId() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get label => $_getSZ(0);
  @$pb.TagNumber(1)
  set label($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get invstring => $_getSZ(1);
  @$pb.TagNumber(2)
  set invstring($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasInvstring() => $_has(1);
  @$pb.TagNumber(2)
  void clearInvstring() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get paymentHash => $_getN(2);
  @$pb.TagNumber(3)
  set paymentHash($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPaymentHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaymentHash() => clearField(3);
}

class ListInvoicesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListInvoicesRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOM<InvoiceIdentifier>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'identifier',
        subBuilder: InvoiceIdentifier.create)
    ..hasRequiredFields = false;

  ListInvoicesRequest._() : super();
  factory ListInvoicesRequest({
    InvoiceIdentifier? identifier,
  }) {
    final _result = create();
    if (identifier != null) {
      _result.identifier = identifier;
    }
    return _result;
  }
  factory ListInvoicesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListInvoicesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListInvoicesRequest clone() => ListInvoicesRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListInvoicesRequest copyWith(void Function(ListInvoicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListInvoicesRequest))
          as ListInvoicesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListInvoicesRequest create() => ListInvoicesRequest._();
  ListInvoicesRequest createEmptyInstance() => create();
  static $pb.PbList<ListInvoicesRequest> createRepeated() =>
      $pb.PbList<ListInvoicesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListInvoicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvoicesRequest>(create);
  static ListInvoicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  InvoiceIdentifier get identifier => $_getN(0);
  @$pb.TagNumber(1)
  set identifier(InvoiceIdentifier v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasIdentifier() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifier() => clearField(1);
  @$pb.TagNumber(1)
  InvoiceIdentifier ensureIdentifier() => $_ensure(0);
}

class StreamIncomingFilter extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'StreamIncomingFilter',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  StreamIncomingFilter._() : super();
  factory StreamIncomingFilter() => create();
  factory StreamIncomingFilter.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StreamIncomingFilter.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  StreamIncomingFilter clone() =>
      StreamIncomingFilter()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  StreamIncomingFilter copyWith(void Function(StreamIncomingFilter) updates) =>
      super.copyWith((message) => updates(message as StreamIncomingFilter))
          as StreamIncomingFilter; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StreamIncomingFilter create() => StreamIncomingFilter._();
  StreamIncomingFilter createEmptyInstance() => create();
  static $pb.PbList<StreamIncomingFilter> createRepeated() =>
      $pb.PbList<StreamIncomingFilter>();
  @$core.pragma('dart2js:noInline')
  static StreamIncomingFilter getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamIncomingFilter>(create);
  static StreamIncomingFilter? _defaultInstance;
}

class ListInvoicesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ListInvoicesResponse',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..pc<Invoice>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'invoices',
        $pb.PbFieldType.PM,
        subBuilder: Invoice.create)
    ..hasRequiredFields = false;

  ListInvoicesResponse._() : super();
  factory ListInvoicesResponse({
    $core.Iterable<Invoice>? invoices,
  }) {
    final _result = create();
    if (invoices != null) {
      _result.invoices.addAll(invoices);
    }
    return _result;
  }
  factory ListInvoicesResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ListInvoicesResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ListInvoicesResponse clone() =>
      ListInvoicesResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ListInvoicesResponse copyWith(void Function(ListInvoicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListInvoicesResponse))
          as ListInvoicesResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListInvoicesResponse create() => ListInvoicesResponse._();
  ListInvoicesResponse createEmptyInstance() => create();
  static $pb.PbList<ListInvoicesResponse> createRepeated() =>
      $pb.PbList<ListInvoicesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListInvoicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvoicesResponse>(create);
  static ListInvoicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Invoice> get invoices => $_getList(0);
}

class TlvField extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'TlvField',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  TlvField._() : super();
  factory TlvField({
    $fixnum.Int64? type,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory TlvField.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TlvField.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TlvField clone() => TlvField()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TlvField copyWith(void Function(TlvField) updates) =>
      super.copyWith((message) => updates(message as TlvField))
          as TlvField; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TlvField create() => TlvField._();
  TlvField createEmptyInstance() => create();
  static $pb.PbList<TlvField> createRepeated() => $pb.PbList<TlvField>();
  @$core.pragma('dart2js:noInline')
  static TlvField getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TlvField>(create);
  static TlvField? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get type => $_getI64(0);
  @$pb.TagNumber(1)
  set type($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class OffChainPayment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'OffChainPayment',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label')
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'preimage',
        $pb.PbFieldType.OY)
    ..aOM<Amount>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount',
        subBuilder: Amount.create)
    ..pc<TlvField>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'extratlvs',
        $pb.PbFieldType.PM,
        subBuilder: TlvField.create)
    ..a<$core.List<$core.int>>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paymentHash',
        $pb.PbFieldType.OY)
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bolt11')
    ..hasRequiredFields = false;

  OffChainPayment._() : super();
  factory OffChainPayment({
    $core.String? label,
    $core.List<$core.int>? preimage,
    Amount? amount,
    $core.Iterable<TlvField>? extratlvs,
    $core.List<$core.int>? paymentHash,
    $core.String? bolt11,
  }) {
    final _result = create();
    if (label != null) {
      _result.label = label;
    }
    if (preimage != null) {
      _result.preimage = preimage;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (extratlvs != null) {
      _result.extratlvs.addAll(extratlvs);
    }
    if (paymentHash != null) {
      _result.paymentHash = paymentHash;
    }
    if (bolt11 != null) {
      _result.bolt11 = bolt11;
    }
    return _result;
  }
  factory OffChainPayment.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory OffChainPayment.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  OffChainPayment clone() => OffChainPayment()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  OffChainPayment copyWith(void Function(OffChainPayment) updates) =>
      super.copyWith((message) => updates(message as OffChainPayment))
          as OffChainPayment; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OffChainPayment create() => OffChainPayment._();
  OffChainPayment createEmptyInstance() => create();
  static $pb.PbList<OffChainPayment> createRepeated() =>
      $pb.PbList<OffChainPayment>();
  @$core.pragma('dart2js:noInline')
  static OffChainPayment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OffChainPayment>(create);
  static OffChainPayment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get label => $_getSZ(0);
  @$pb.TagNumber(1)
  set label($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get preimage => $_getN(1);
  @$pb.TagNumber(2)
  set preimage($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPreimage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreimage() => clearField(2);

  @$pb.TagNumber(3)
  Amount get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount(Amount v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
  @$pb.TagNumber(3)
  Amount ensureAmount() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<TlvField> get extratlvs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$core.int> get paymentHash => $_getN(4);
  @$pb.TagNumber(5)
  set paymentHash($core.List<$core.int> v) {
    $_setBytes(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPaymentHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearPaymentHash() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get bolt11 => $_getSZ(5);
  @$pb.TagNumber(6)
  set bolt11($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasBolt11() => $_has(5);
  @$pb.TagNumber(6)
  void clearBolt11() => clearField(6);
}

enum IncomingPayment_Details { offchain, notSet }

class IncomingPayment extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, IncomingPayment_Details>
      _IncomingPayment_DetailsByTag = {
    1: IncomingPayment_Details.offchain,
    0: IncomingPayment_Details.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'IncomingPayment',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<OffChainPayment>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offchain',
        subBuilder: OffChainPayment.create)
    ..hasRequiredFields = false;

  IncomingPayment._() : super();
  factory IncomingPayment({
    OffChainPayment? offchain,
  }) {
    final _result = create();
    if (offchain != null) {
      _result.offchain = offchain;
    }
    return _result;
  }
  factory IncomingPayment.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory IncomingPayment.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  IncomingPayment clone() => IncomingPayment()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  IncomingPayment copyWith(void Function(IncomingPayment) updates) =>
      super.copyWith((message) => updates(message as IncomingPayment))
          as IncomingPayment; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IncomingPayment create() => IncomingPayment._();
  IncomingPayment createEmptyInstance() => create();
  static $pb.PbList<IncomingPayment> createRepeated() =>
      $pb.PbList<IncomingPayment>();
  @$core.pragma('dart2js:noInline')
  static IncomingPayment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IncomingPayment>(create);
  static IncomingPayment? _defaultInstance;

  IncomingPayment_Details whichDetails() =>
      _IncomingPayment_DetailsByTag[$_whichOneof(0)]!;
  void clearDetails() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  OffChainPayment get offchain => $_getN(0);
  @$pb.TagNumber(1)
  set offchain(OffChainPayment v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOffchain() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffchain() => clearField(1);
  @$pb.TagNumber(1)
  OffChainPayment ensureOffchain() => $_ensure(0);
}

class RoutehintHop extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'RoutehintHop',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId',
        $pb.PbFieldType.OY)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'shortChannelId')
    ..a<$fixnum.Int64>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'feeBase',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'feeProp',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cltvExpiryDelta',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  RoutehintHop._() : super();
  factory RoutehintHop({
    $core.List<$core.int>? nodeId,
    $core.String? shortChannelId,
    $fixnum.Int64? feeBase,
    $core.int? feeProp,
    $core.int? cltvExpiryDelta,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (shortChannelId != null) {
      _result.shortChannelId = shortChannelId;
    }
    if (feeBase != null) {
      _result.feeBase = feeBase;
    }
    if (feeProp != null) {
      _result.feeProp = feeProp;
    }
    if (cltvExpiryDelta != null) {
      _result.cltvExpiryDelta = cltvExpiryDelta;
    }
    return _result;
  }
  factory RoutehintHop.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RoutehintHop.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  RoutehintHop clone() => RoutehintHop()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  RoutehintHop copyWith(void Function(RoutehintHop) updates) =>
      super.copyWith((message) => updates(message as RoutehintHop))
          as RoutehintHop; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RoutehintHop create() => RoutehintHop._();
  RoutehintHop createEmptyInstance() => create();
  static $pb.PbList<RoutehintHop> createRepeated() =>
      $pb.PbList<RoutehintHop>();
  @$core.pragma('dart2js:noInline')
  static RoutehintHop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoutehintHop>(create);
  static RoutehintHop? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get shortChannelId => $_getSZ(1);
  @$pb.TagNumber(2)
  set shortChannelId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasShortChannelId() => $_has(1);
  @$pb.TagNumber(2)
  void clearShortChannelId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get feeBase => $_getI64(2);
  @$pb.TagNumber(3)
  set feeBase($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFeeBase() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeeBase() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get feeProp => $_getIZ(3);
  @$pb.TagNumber(4)
  set feeProp($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasFeeProp() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeeProp() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get cltvExpiryDelta => $_getIZ(4);
  @$pb.TagNumber(5)
  set cltvExpiryDelta($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCltvExpiryDelta() => $_has(4);
  @$pb.TagNumber(5)
  void clearCltvExpiryDelta() => clearField(5);
}

class Routehint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Routehint',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..pc<RoutehintHop>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'hops',
        $pb.PbFieldType.PM,
        subBuilder: RoutehintHop.create)
    ..hasRequiredFields = false;

  Routehint._() : super();
  factory Routehint({
    $core.Iterable<RoutehintHop>? hops,
  }) {
    final _result = create();
    if (hops != null) {
      _result.hops.addAll(hops);
    }
    return _result;
  }
  factory Routehint.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Routehint.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Routehint clone() => Routehint()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Routehint copyWith(void Function(Routehint) updates) =>
      super.copyWith((message) => updates(message as Routehint))
          as Routehint; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Routehint create() => Routehint._();
  Routehint createEmptyInstance() => create();
  static $pb.PbList<Routehint> createRepeated() => $pb.PbList<Routehint>();
  @$core.pragma('dart2js:noInline')
  static Routehint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Routehint>(create);
  static Routehint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<RoutehintHop> get hops => $_getList(0);
}

class KeysendRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'KeysendRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nodeId',
        $pb.PbFieldType.OY)
    ..aOM<Amount>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'amount',
        subBuilder: Amount.create)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label')
    ..pc<Routehint>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'routehints',
        $pb.PbFieldType.PM,
        subBuilder: Routehint.create)
    ..pc<TlvField>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'extratlvs',
        $pb.PbFieldType.PM,
        subBuilder: TlvField.create)
    ..hasRequiredFields = false;

  KeysendRequest._() : super();
  factory KeysendRequest({
    $core.List<$core.int>? nodeId,
    Amount? amount,
    $core.String? label,
    $core.Iterable<Routehint>? routehints,
    $core.Iterable<TlvField>? extratlvs,
  }) {
    final _result = create();
    if (nodeId != null) {
      _result.nodeId = nodeId;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (label != null) {
      _result.label = label;
    }
    if (routehints != null) {
      _result.routehints.addAll(routehints);
    }
    if (extratlvs != null) {
      _result.extratlvs.addAll(extratlvs);
    }
    return _result;
  }
  factory KeysendRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory KeysendRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  KeysendRequest clone() => KeysendRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  KeysendRequest copyWith(void Function(KeysendRequest) updates) =>
      super.copyWith((message) => updates(message as KeysendRequest))
          as KeysendRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static KeysendRequest create() => KeysendRequest._();
  KeysendRequest createEmptyInstance() => create();
  static $pb.PbList<KeysendRequest> createRepeated() =>
      $pb.PbList<KeysendRequest>();
  @$core.pragma('dart2js:noInline')
  static KeysendRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeysendRequest>(create);
  static KeysendRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nodeId => $_getN(0);
  @$pb.TagNumber(1)
  set nodeId($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => clearField(1);

  @$pb.TagNumber(2)
  Amount get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount(Amount v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
  @$pb.TagNumber(2)
  Amount ensureAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<Routehint> get routehints => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<TlvField> get extratlvs => $_getList(4);
}

class StreamLogRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'StreamLogRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  StreamLogRequest._() : super();
  factory StreamLogRequest() => create();
  factory StreamLogRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StreamLogRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  StreamLogRequest clone() => StreamLogRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  StreamLogRequest copyWith(void Function(StreamLogRequest) updates) =>
      super.copyWith((message) => updates(message as StreamLogRequest))
          as StreamLogRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StreamLogRequest create() => StreamLogRequest._();
  StreamLogRequest createEmptyInstance() => create();
  static $pb.PbList<StreamLogRequest> createRepeated() =>
      $pb.PbList<StreamLogRequest>();
  @$core.pragma('dart2js:noInline')
  static StreamLogRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamLogRequest>(create);
  static StreamLogRequest? _defaultInstance;
}

class LogEntry extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'LogEntry',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'greenlight'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'line')
    ..hasRequiredFields = false;

  LogEntry._() : super();
  factory LogEntry({
    $core.String? line,
  }) {
    final _result = create();
    if (line != null) {
      _result.line = line;
    }
    return _result;
  }
  factory LogEntry.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory LogEntry.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LogEntry clone() => LogEntry()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LogEntry copyWith(void Function(LogEntry) updates) =>
      super.copyWith((message) => updates(message as LogEntry))
          as LogEntry; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LogEntry create() => LogEntry._();
  LogEntry createEmptyInstance() => create();
  static $pb.PbList<LogEntry> createRepeated() => $pb.PbList<LogEntry>();
  @$core.pragma('dart2js:noInline')
  static LogEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogEntry>(create);
  static LogEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get line => $_getSZ(0);
  @$pb.TagNumber(1)
  set line($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLine() => $_has(0);
  @$pb.TagNumber(1)
  void clearLine() => clearField(1);
}
