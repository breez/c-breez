// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class NodeState extends DataClass implements Insertable<NodeState> {
  final String nodeID;
  final int channelsBalanceMsats;
  final int onchainBalanceMsats;
  final int blockHeight;
  final int connectionStatus;
  final int maxAllowedToPayMsats;
  final int maxAllowedToReceiveMsats;
  final int maxPaymentAmountMsats;
  final int maxChanReserveMsats;
  final String connectedPeers;
  final int maxInboundLiquidityMsats;
  final int onChainFeeRate;
  NodeState(
      {required this.nodeID,
      required this.channelsBalanceMsats,
      required this.onchainBalanceMsats,
      required this.blockHeight,
      required this.connectionStatus,
      required this.maxAllowedToPayMsats,
      required this.maxAllowedToReceiveMsats,
      required this.maxPaymentAmountMsats,
      required this.maxChanReserveMsats,
      required this.connectedPeers,
      required this.maxInboundLiquidityMsats,
      required this.onChainFeeRate});
  factory NodeState.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return NodeState(
      nodeID: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_i_d'])!,
      channelsBalanceMsats: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}channels_balance_msats'])!,
      onchainBalanceMsats: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}onchain_balance_msats'])!,
      blockHeight: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}block_height'])!,
      connectionStatus: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}connection_status'])!,
      maxAllowedToPayMsats: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}max_allowed_to_pay_msats'])!,
      maxAllowedToReceiveMsats: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}max_allowed_to_receive_msats'])!,
      maxPaymentAmountMsats: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}max_payment_amount_msats'])!,
      maxChanReserveMsats: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}max_chan_reserve_msats'])!,
      connectedPeers: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}connected_peers'])!,
      maxInboundLiquidityMsats: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}max_inbound_liquidity_msats'])!,
      onChainFeeRate: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}on_chain_fee_rate'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['node_i_d'] = Variable<String>(nodeID);
    map['channels_balance_msats'] = Variable<int>(channelsBalanceMsats);
    map['onchain_balance_msats'] = Variable<int>(onchainBalanceMsats);
    map['block_height'] = Variable<int>(blockHeight);
    map['connection_status'] = Variable<int>(connectionStatus);
    map['max_allowed_to_pay_msats'] = Variable<int>(maxAllowedToPayMsats);
    map['max_allowed_to_receive_msats'] =
        Variable<int>(maxAllowedToReceiveMsats);
    map['max_payment_amount_msats'] = Variable<int>(maxPaymentAmountMsats);
    map['max_chan_reserve_msats'] = Variable<int>(maxChanReserveMsats);
    map['connected_peers'] = Variable<String>(connectedPeers);
    map['max_inbound_liquidity_msats'] =
        Variable<int>(maxInboundLiquidityMsats);
    map['on_chain_fee_rate'] = Variable<int>(onChainFeeRate);
    return map;
  }

  NodeStatesCompanion toCompanion(bool nullToAbsent) {
    return NodeStatesCompanion(
      nodeID: Value(nodeID),
      channelsBalanceMsats: Value(channelsBalanceMsats),
      onchainBalanceMsats: Value(onchainBalanceMsats),
      blockHeight: Value(blockHeight),
      connectionStatus: Value(connectionStatus),
      maxAllowedToPayMsats: Value(maxAllowedToPayMsats),
      maxAllowedToReceiveMsats: Value(maxAllowedToReceiveMsats),
      maxPaymentAmountMsats: Value(maxPaymentAmountMsats),
      maxChanReserveMsats: Value(maxChanReserveMsats),
      connectedPeers: Value(connectedPeers),
      maxInboundLiquidityMsats: Value(maxInboundLiquidityMsats),
      onChainFeeRate: Value(onChainFeeRate),
    );
  }

  factory NodeState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeState(
      nodeID: serializer.fromJson<String>(json['nodeID']),
      channelsBalanceMsats:
          serializer.fromJson<int>(json['channelsBalanceMsats']),
      onchainBalanceMsats:
          serializer.fromJson<int>(json['onchainBalanceMsats']),
      blockHeight: serializer.fromJson<int>(json['blockHeight']),
      connectionStatus: serializer.fromJson<int>(json['connectionStatus']),
      maxAllowedToPayMsats:
          serializer.fromJson<int>(json['maxAllowedToPayMsats']),
      maxAllowedToReceiveMsats:
          serializer.fromJson<int>(json['maxAllowedToReceiveMsats']),
      maxPaymentAmountMsats:
          serializer.fromJson<int>(json['maxPaymentAmountMsats']),
      maxChanReserveMsats:
          serializer.fromJson<int>(json['maxChanReserveMsats']),
      connectedPeers: serializer.fromJson<String>(json['connectedPeers']),
      maxInboundLiquidityMsats:
          serializer.fromJson<int>(json['maxInboundLiquidityMsats']),
      onChainFeeRate: serializer.fromJson<int>(json['onChainFeeRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'nodeID': serializer.toJson<String>(nodeID),
      'channelsBalanceMsats': serializer.toJson<int>(channelsBalanceMsats),
      'onchainBalanceMsats': serializer.toJson<int>(onchainBalanceMsats),
      'blockHeight': serializer.toJson<int>(blockHeight),
      'connectionStatus': serializer.toJson<int>(connectionStatus),
      'maxAllowedToPayMsats': serializer.toJson<int>(maxAllowedToPayMsats),
      'maxAllowedToReceiveMsats':
          serializer.toJson<int>(maxAllowedToReceiveMsats),
      'maxPaymentAmountMsats': serializer.toJson<int>(maxPaymentAmountMsats),
      'maxChanReserveMsats': serializer.toJson<int>(maxChanReserveMsats),
      'connectedPeers': serializer.toJson<String>(connectedPeers),
      'maxInboundLiquidityMsats':
          serializer.toJson<int>(maxInboundLiquidityMsats),
      'onChainFeeRate': serializer.toJson<int>(onChainFeeRate),
    };
  }

  NodeState copyWith(
          {String? nodeID,
          int? channelsBalanceMsats,
          int? onchainBalanceMsats,
          int? blockHeight,
          int? connectionStatus,
          int? maxAllowedToPayMsats,
          int? maxAllowedToReceiveMsats,
          int? maxPaymentAmountMsats,
          int? maxChanReserveMsats,
          String? connectedPeers,
          int? maxInboundLiquidityMsats,
          int? onChainFeeRate}) =>
      NodeState(
        nodeID: nodeID ?? this.nodeID,
        channelsBalanceMsats: channelsBalanceMsats ?? this.channelsBalanceMsats,
        onchainBalanceMsats: onchainBalanceMsats ?? this.onchainBalanceMsats,
        blockHeight: blockHeight ?? this.blockHeight,
        connectionStatus: connectionStatus ?? this.connectionStatus,
        maxAllowedToPayMsats: maxAllowedToPayMsats ?? this.maxAllowedToPayMsats,
        maxAllowedToReceiveMsats:
            maxAllowedToReceiveMsats ?? this.maxAllowedToReceiveMsats,
        maxPaymentAmountMsats:
            maxPaymentAmountMsats ?? this.maxPaymentAmountMsats,
        maxChanReserveMsats: maxChanReserveMsats ?? this.maxChanReserveMsats,
        connectedPeers: connectedPeers ?? this.connectedPeers,
        maxInboundLiquidityMsats:
            maxInboundLiquidityMsats ?? this.maxInboundLiquidityMsats,
        onChainFeeRate: onChainFeeRate ?? this.onChainFeeRate,
      );
  @override
  String toString() {
    return (StringBuffer('NodeState(')
          ..write('nodeID: $nodeID, ')
          ..write('channelsBalanceMsats: $channelsBalanceMsats, ')
          ..write('onchainBalanceMsats: $onchainBalanceMsats, ')
          ..write('blockHeight: $blockHeight, ')
          ..write('connectionStatus: $connectionStatus, ')
          ..write('maxAllowedToPayMsats: $maxAllowedToPayMsats, ')
          ..write('maxAllowedToReceiveMsats: $maxAllowedToReceiveMsats, ')
          ..write('maxPaymentAmountMsats: $maxPaymentAmountMsats, ')
          ..write('maxChanReserveMsats: $maxChanReserveMsats, ')
          ..write('connectedPeers: $connectedPeers, ')
          ..write('maxInboundLiquidityMsats: $maxInboundLiquidityMsats, ')
          ..write('onChainFeeRate: $onChainFeeRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      nodeID,
      channelsBalanceMsats,
      onchainBalanceMsats,
      blockHeight,
      connectionStatus,
      maxAllowedToPayMsats,
      maxAllowedToReceiveMsats,
      maxPaymentAmountMsats,
      maxChanReserveMsats,
      connectedPeers,
      maxInboundLiquidityMsats,
      onChainFeeRate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeState &&
          other.nodeID == this.nodeID &&
          other.channelsBalanceMsats == this.channelsBalanceMsats &&
          other.onchainBalanceMsats == this.onchainBalanceMsats &&
          other.blockHeight == this.blockHeight &&
          other.connectionStatus == this.connectionStatus &&
          other.maxAllowedToPayMsats == this.maxAllowedToPayMsats &&
          other.maxAllowedToReceiveMsats == this.maxAllowedToReceiveMsats &&
          other.maxPaymentAmountMsats == this.maxPaymentAmountMsats &&
          other.maxChanReserveMsats == this.maxChanReserveMsats &&
          other.connectedPeers == this.connectedPeers &&
          other.maxInboundLiquidityMsats == this.maxInboundLiquidityMsats &&
          other.onChainFeeRate == this.onChainFeeRate);
}

class NodeStatesCompanion extends UpdateCompanion<NodeState> {
  final Value<String> nodeID;
  final Value<int> channelsBalanceMsats;
  final Value<int> onchainBalanceMsats;
  final Value<int> blockHeight;
  final Value<int> connectionStatus;
  final Value<int> maxAllowedToPayMsats;
  final Value<int> maxAllowedToReceiveMsats;
  final Value<int> maxPaymentAmountMsats;
  final Value<int> maxChanReserveMsats;
  final Value<String> connectedPeers;
  final Value<int> maxInboundLiquidityMsats;
  final Value<int> onChainFeeRate;
  const NodeStatesCompanion({
    this.nodeID = const Value.absent(),
    this.channelsBalanceMsats = const Value.absent(),
    this.onchainBalanceMsats = const Value.absent(),
    this.blockHeight = const Value.absent(),
    this.connectionStatus = const Value.absent(),
    this.maxAllowedToPayMsats = const Value.absent(),
    this.maxAllowedToReceiveMsats = const Value.absent(),
    this.maxPaymentAmountMsats = const Value.absent(),
    this.maxChanReserveMsats = const Value.absent(),
    this.connectedPeers = const Value.absent(),
    this.maxInboundLiquidityMsats = const Value.absent(),
    this.onChainFeeRate = const Value.absent(),
  });
  NodeStatesCompanion.insert({
    required String nodeID,
    required int channelsBalanceMsats,
    required int onchainBalanceMsats,
    required int blockHeight,
    required int connectionStatus,
    required int maxAllowedToPayMsats,
    required int maxAllowedToReceiveMsats,
    required int maxPaymentAmountMsats,
    required int maxChanReserveMsats,
    required String connectedPeers,
    required int maxInboundLiquidityMsats,
    required int onChainFeeRate,
  })  : nodeID = Value(nodeID),
        channelsBalanceMsats = Value(channelsBalanceMsats),
        onchainBalanceMsats = Value(onchainBalanceMsats),
        blockHeight = Value(blockHeight),
        connectionStatus = Value(connectionStatus),
        maxAllowedToPayMsats = Value(maxAllowedToPayMsats),
        maxAllowedToReceiveMsats = Value(maxAllowedToReceiveMsats),
        maxPaymentAmountMsats = Value(maxPaymentAmountMsats),
        maxChanReserveMsats = Value(maxChanReserveMsats),
        connectedPeers = Value(connectedPeers),
        maxInboundLiquidityMsats = Value(maxInboundLiquidityMsats),
        onChainFeeRate = Value(onChainFeeRate);
  static Insertable<NodeState> custom({
    Expression<String>? nodeID,
    Expression<int>? channelsBalanceMsats,
    Expression<int>? onchainBalanceMsats,
    Expression<int>? blockHeight,
    Expression<int>? connectionStatus,
    Expression<int>? maxAllowedToPayMsats,
    Expression<int>? maxAllowedToReceiveMsats,
    Expression<int>? maxPaymentAmountMsats,
    Expression<int>? maxChanReserveMsats,
    Expression<String>? connectedPeers,
    Expression<int>? maxInboundLiquidityMsats,
    Expression<int>? onChainFeeRate,
  }) {
    return RawValuesInsertable({
      if (nodeID != null) 'node_i_d': nodeID,
      if (channelsBalanceMsats != null)
        'channels_balance_msats': channelsBalanceMsats,
      if (onchainBalanceMsats != null)
        'onchain_balance_msats': onchainBalanceMsats,
      if (blockHeight != null) 'block_height': blockHeight,
      if (connectionStatus != null) 'connection_status': connectionStatus,
      if (maxAllowedToPayMsats != null)
        'max_allowed_to_pay_msats': maxAllowedToPayMsats,
      if (maxAllowedToReceiveMsats != null)
        'max_allowed_to_receive_msats': maxAllowedToReceiveMsats,
      if (maxPaymentAmountMsats != null)
        'max_payment_amount_msats': maxPaymentAmountMsats,
      if (maxChanReserveMsats != null)
        'max_chan_reserve_msats': maxChanReserveMsats,
      if (connectedPeers != null) 'connected_peers': connectedPeers,
      if (maxInboundLiquidityMsats != null)
        'max_inbound_liquidity_msats': maxInboundLiquidityMsats,
      if (onChainFeeRate != null) 'on_chain_fee_rate': onChainFeeRate,
    });
  }

  NodeStatesCompanion copyWith(
      {Value<String>? nodeID,
      Value<int>? channelsBalanceMsats,
      Value<int>? onchainBalanceMsats,
      Value<int>? blockHeight,
      Value<int>? connectionStatus,
      Value<int>? maxAllowedToPayMsats,
      Value<int>? maxAllowedToReceiveMsats,
      Value<int>? maxPaymentAmountMsats,
      Value<int>? maxChanReserveMsats,
      Value<String>? connectedPeers,
      Value<int>? maxInboundLiquidityMsats,
      Value<int>? onChainFeeRate}) {
    return NodeStatesCompanion(
      nodeID: nodeID ?? this.nodeID,
      channelsBalanceMsats: channelsBalanceMsats ?? this.channelsBalanceMsats,
      onchainBalanceMsats: onchainBalanceMsats ?? this.onchainBalanceMsats,
      blockHeight: blockHeight ?? this.blockHeight,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      maxAllowedToPayMsats: maxAllowedToPayMsats ?? this.maxAllowedToPayMsats,
      maxAllowedToReceiveMsats:
          maxAllowedToReceiveMsats ?? this.maxAllowedToReceiveMsats,
      maxPaymentAmountMsats:
          maxPaymentAmountMsats ?? this.maxPaymentAmountMsats,
      maxChanReserveMsats: maxChanReserveMsats ?? this.maxChanReserveMsats,
      connectedPeers: connectedPeers ?? this.connectedPeers,
      maxInboundLiquidityMsats:
          maxInboundLiquidityMsats ?? this.maxInboundLiquidityMsats,
      onChainFeeRate: onChainFeeRate ?? this.onChainFeeRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (nodeID.present) {
      map['node_i_d'] = Variable<String>(nodeID.value);
    }
    if (channelsBalanceMsats.present) {
      map['channels_balance_msats'] = Variable<int>(channelsBalanceMsats.value);
    }
    if (onchainBalanceMsats.present) {
      map['onchain_balance_msats'] = Variable<int>(onchainBalanceMsats.value);
    }
    if (blockHeight.present) {
      map['block_height'] = Variable<int>(blockHeight.value);
    }
    if (connectionStatus.present) {
      map['connection_status'] = Variable<int>(connectionStatus.value);
    }
    if (maxAllowedToPayMsats.present) {
      map['max_allowed_to_pay_msats'] =
          Variable<int>(maxAllowedToPayMsats.value);
    }
    if (maxAllowedToReceiveMsats.present) {
      map['max_allowed_to_receive_msats'] =
          Variable<int>(maxAllowedToReceiveMsats.value);
    }
    if (maxPaymentAmountMsats.present) {
      map['max_payment_amount_msats'] =
          Variable<int>(maxPaymentAmountMsats.value);
    }
    if (maxChanReserveMsats.present) {
      map['max_chan_reserve_msats'] = Variable<int>(maxChanReserveMsats.value);
    }
    if (connectedPeers.present) {
      map['connected_peers'] = Variable<String>(connectedPeers.value);
    }
    if (maxInboundLiquidityMsats.present) {
      map['max_inbound_liquidity_msats'] =
          Variable<int>(maxInboundLiquidityMsats.value);
    }
    if (onChainFeeRate.present) {
      map['on_chain_fee_rate'] = Variable<int>(onChainFeeRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodeStatesCompanion(')
          ..write('nodeID: $nodeID, ')
          ..write('channelsBalanceMsats: $channelsBalanceMsats, ')
          ..write('onchainBalanceMsats: $onchainBalanceMsats, ')
          ..write('blockHeight: $blockHeight, ')
          ..write('connectionStatus: $connectionStatus, ')
          ..write('maxAllowedToPayMsats: $maxAllowedToPayMsats, ')
          ..write('maxAllowedToReceiveMsats: $maxAllowedToReceiveMsats, ')
          ..write('maxPaymentAmountMsats: $maxPaymentAmountMsats, ')
          ..write('maxChanReserveMsats: $maxChanReserveMsats, ')
          ..write('connectedPeers: $connectedPeers, ')
          ..write('maxInboundLiquidityMsats: $maxInboundLiquidityMsats, ')
          ..write('onChainFeeRate: $onChainFeeRate')
          ..write(')'))
        .toString();
  }
}

class $NodeStatesTable extends NodeStates
    with TableInfo<$NodeStatesTable, NodeState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodeStatesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _nodeIDMeta = const VerificationMeta('nodeID');
  @override
  late final GeneratedColumn<String?> nodeID = GeneratedColumn<String?>(
      'node_i_d', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 66, maxTextLength: 66),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _channelsBalanceMsatsMeta =
      const VerificationMeta('channelsBalanceMsats');
  @override
  late final GeneratedColumn<int?> channelsBalanceMsats = GeneratedColumn<int?>(
      'channels_balance_msats', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _onchainBalanceMsatsMeta =
      const VerificationMeta('onchainBalanceMsats');
  @override
  late final GeneratedColumn<int?> onchainBalanceMsats = GeneratedColumn<int?>(
      'onchain_balance_msats', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _blockHeightMeta =
      const VerificationMeta('blockHeight');
  @override
  late final GeneratedColumn<int?> blockHeight = GeneratedColumn<int?>(
      'block_height', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _connectionStatusMeta =
      const VerificationMeta('connectionStatus');
  @override
  late final GeneratedColumn<int?> connectionStatus = GeneratedColumn<int?>(
      'connection_status', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _maxAllowedToPayMsatsMeta =
      const VerificationMeta('maxAllowedToPayMsats');
  @override
  late final GeneratedColumn<int?> maxAllowedToPayMsats = GeneratedColumn<int?>(
      'max_allowed_to_pay_msats', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _maxAllowedToReceiveMsatsMeta =
      const VerificationMeta('maxAllowedToReceiveMsats');
  @override
  late final GeneratedColumn<int?> maxAllowedToReceiveMsats =
      GeneratedColumn<int?>('max_allowed_to_receive_msats', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _maxPaymentAmountMsatsMeta =
      const VerificationMeta('maxPaymentAmountMsats');
  @override
  late final GeneratedColumn<int?> maxPaymentAmountMsats =
      GeneratedColumn<int?>('max_payment_amount_msats', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _maxChanReserveMsatsMeta =
      const VerificationMeta('maxChanReserveMsats');
  @override
  late final GeneratedColumn<int?> maxChanReserveMsats = GeneratedColumn<int?>(
      'max_chan_reserve_msats', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _connectedPeersMeta =
      const VerificationMeta('connectedPeers');
  @override
  late final GeneratedColumn<String?> connectedPeers = GeneratedColumn<String?>(
      'connected_peers', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _maxInboundLiquidityMsatsMeta =
      const VerificationMeta('maxInboundLiquidityMsats');
  @override
  late final GeneratedColumn<int?> maxInboundLiquidityMsats =
      GeneratedColumn<int?>('max_inbound_liquidity_msats', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _onChainFeeRateMeta =
      const VerificationMeta('onChainFeeRate');
  @override
  late final GeneratedColumn<int?> onChainFeeRate = GeneratedColumn<int?>(
      'on_chain_fee_rate', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        nodeID,
        channelsBalanceMsats,
        onchainBalanceMsats,
        blockHeight,
        connectionStatus,
        maxAllowedToPayMsats,
        maxAllowedToReceiveMsats,
        maxPaymentAmountMsats,
        maxChanReserveMsats,
        connectedPeers,
        maxInboundLiquidityMsats,
        onChainFeeRate
      ];
  @override
  String get aliasedName => _alias ?? 'node_states';
  @override
  String get actualTableName => 'node_states';
  @override
  VerificationContext validateIntegrity(Insertable<NodeState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('node_i_d')) {
      context.handle(_nodeIDMeta,
          nodeID.isAcceptableOrUnknown(data['node_i_d']!, _nodeIDMeta));
    } else if (isInserting) {
      context.missing(_nodeIDMeta);
    }
    if (data.containsKey('channels_balance_msats')) {
      context.handle(
          _channelsBalanceMsatsMeta,
          channelsBalanceMsats.isAcceptableOrUnknown(
              data['channels_balance_msats']!, _channelsBalanceMsatsMeta));
    } else if (isInserting) {
      context.missing(_channelsBalanceMsatsMeta);
    }
    if (data.containsKey('onchain_balance_msats')) {
      context.handle(
          _onchainBalanceMsatsMeta,
          onchainBalanceMsats.isAcceptableOrUnknown(
              data['onchain_balance_msats']!, _onchainBalanceMsatsMeta));
    } else if (isInserting) {
      context.missing(_onchainBalanceMsatsMeta);
    }
    if (data.containsKey('block_height')) {
      context.handle(
          _blockHeightMeta,
          blockHeight.isAcceptableOrUnknown(
              data['block_height']!, _blockHeightMeta));
    } else if (isInserting) {
      context.missing(_blockHeightMeta);
    }
    if (data.containsKey('connection_status')) {
      context.handle(
          _connectionStatusMeta,
          connectionStatus.isAcceptableOrUnknown(
              data['connection_status']!, _connectionStatusMeta));
    } else if (isInserting) {
      context.missing(_connectionStatusMeta);
    }
    if (data.containsKey('max_allowed_to_pay_msats')) {
      context.handle(
          _maxAllowedToPayMsatsMeta,
          maxAllowedToPayMsats.isAcceptableOrUnknown(
              data['max_allowed_to_pay_msats']!, _maxAllowedToPayMsatsMeta));
    } else if (isInserting) {
      context.missing(_maxAllowedToPayMsatsMeta);
    }
    if (data.containsKey('max_allowed_to_receive_msats')) {
      context.handle(
          _maxAllowedToReceiveMsatsMeta,
          maxAllowedToReceiveMsats.isAcceptableOrUnknown(
              data['max_allowed_to_receive_msats']!,
              _maxAllowedToReceiveMsatsMeta));
    } else if (isInserting) {
      context.missing(_maxAllowedToReceiveMsatsMeta);
    }
    if (data.containsKey('max_payment_amount_msats')) {
      context.handle(
          _maxPaymentAmountMsatsMeta,
          maxPaymentAmountMsats.isAcceptableOrUnknown(
              data['max_payment_amount_msats']!, _maxPaymentAmountMsatsMeta));
    } else if (isInserting) {
      context.missing(_maxPaymentAmountMsatsMeta);
    }
    if (data.containsKey('max_chan_reserve_msats')) {
      context.handle(
          _maxChanReserveMsatsMeta,
          maxChanReserveMsats.isAcceptableOrUnknown(
              data['max_chan_reserve_msats']!, _maxChanReserveMsatsMeta));
    } else if (isInserting) {
      context.missing(_maxChanReserveMsatsMeta);
    }
    if (data.containsKey('connected_peers')) {
      context.handle(
          _connectedPeersMeta,
          connectedPeers.isAcceptableOrUnknown(
              data['connected_peers']!, _connectedPeersMeta));
    } else if (isInserting) {
      context.missing(_connectedPeersMeta);
    }
    if (data.containsKey('max_inbound_liquidity_msats')) {
      context.handle(
          _maxInboundLiquidityMsatsMeta,
          maxInboundLiquidityMsats.isAcceptableOrUnknown(
              data['max_inbound_liquidity_msats']!,
              _maxInboundLiquidityMsatsMeta));
    } else if (isInserting) {
      context.missing(_maxInboundLiquidityMsatsMeta);
    }
    if (data.containsKey('on_chain_fee_rate')) {
      context.handle(
          _onChainFeeRateMeta,
          onChainFeeRate.isAcceptableOrUnknown(
              data['on_chain_fee_rate']!, _onChainFeeRateMeta));
    } else if (isInserting) {
      context.missing(_onChainFeeRateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {nodeID};
  @override
  NodeState map(Map<String, dynamic> data, {String? tablePrefix}) {
    return NodeState.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $NodeStatesTable createAlias(String alias) {
    return $NodeStatesTable(attachedDatabase, alias);
  }
}

class NodeAddresse extends DataClass implements Insertable<NodeAddresse> {
  final int id;
  final int type;
  final String addr;
  final int port;
  final String nodeId;
  NodeAddresse(
      {required this.id,
      required this.type,
      required this.addr,
      required this.port,
      required this.nodeId});
  factory NodeAddresse.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return NodeAddresse(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      addr: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}addr'])!,
      port: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}port'])!,
      nodeId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<int>(type);
    map['addr'] = Variable<String>(addr);
    map['port'] = Variable<int>(port);
    map['node_id'] = Variable<String>(nodeId);
    return map;
  }

  NodeAddressesCompanion toCompanion(bool nullToAbsent) {
    return NodeAddressesCompanion(
      id: Value(id),
      type: Value(type),
      addr: Value(addr),
      port: Value(port),
      nodeId: Value(nodeId),
    );
  }

  factory NodeAddresse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeAddresse(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<int>(json['type']),
      addr: serializer.fromJson<String>(json['addr']),
      port: serializer.fromJson<int>(json['port']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<int>(type),
      'addr': serializer.toJson<String>(addr),
      'port': serializer.toJson<int>(port),
      'nodeId': serializer.toJson<String>(nodeId),
    };
  }

  NodeAddresse copyWith(
          {int? id, int? type, String? addr, int? port, String? nodeId}) =>
      NodeAddresse(
        id: id ?? this.id,
        type: type ?? this.type,
        addr: addr ?? this.addr,
        port: port ?? this.port,
        nodeId: nodeId ?? this.nodeId,
      );
  @override
  String toString() {
    return (StringBuffer('NodeAddresse(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('addr: $addr, ')
          ..write('port: $port, ')
          ..write('nodeId: $nodeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, addr, port, nodeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeAddresse &&
          other.id == this.id &&
          other.type == this.type &&
          other.addr == this.addr &&
          other.port == this.port &&
          other.nodeId == this.nodeId);
}

class NodeAddressesCompanion extends UpdateCompanion<NodeAddresse> {
  final Value<int> id;
  final Value<int> type;
  final Value<String> addr;
  final Value<int> port;
  final Value<String> nodeId;
  const NodeAddressesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.addr = const Value.absent(),
    this.port = const Value.absent(),
    this.nodeId = const Value.absent(),
  });
  NodeAddressesCompanion.insert({
    this.id = const Value.absent(),
    required int type,
    required String addr,
    required int port,
    required String nodeId,
  })  : type = Value(type),
        addr = Value(addr),
        port = Value(port),
        nodeId = Value(nodeId);
  static Insertable<NodeAddresse> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<String>? addr,
    Expression<int>? port,
    Expression<String>? nodeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (addr != null) 'addr': addr,
      if (port != null) 'port': port,
      if (nodeId != null) 'node_id': nodeId,
    });
  }

  NodeAddressesCompanion copyWith(
      {Value<int>? id,
      Value<int>? type,
      Value<String>? addr,
      Value<int>? port,
      Value<String>? nodeId}) {
    return NodeAddressesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      addr: addr ?? this.addr,
      port: port ?? this.port,
      nodeId: nodeId ?? this.nodeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (addr.present) {
      map['addr'] = Variable<String>(addr.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodeAddressesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('addr: $addr, ')
          ..write('port: $port, ')
          ..write('nodeId: $nodeId')
          ..write(')'))
        .toString();
  }
}

class $NodeAddressesTable extends NodeAddresses
    with TableInfo<$NodeAddressesTable, NodeAddresse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodeAddressesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _addrMeta = const VerificationMeta('addr');
  @override
  late final GeneratedColumn<String?> addr = GeneratedColumn<String?>(
      'addr', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int?> port = GeneratedColumn<int?>(
      'port', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String?> nodeId = GeneratedColumn<String?>(
      'node_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 66, maxTextLength: 66),
      type: const StringType(),
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, type, addr, port, nodeId];
  @override
  String get aliasedName => _alias ?? 'node_addresses';
  @override
  String get actualTableName => 'node_addresses';
  @override
  VerificationContext validateIntegrity(Insertable<NodeAddresse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('addr')) {
      context.handle(
          _addrMeta, addr.isAcceptableOrUnknown(data['addr']!, _addrMeta));
    } else if (isInserting) {
      context.missing(_addrMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port']!, _portMeta));
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NodeAddresse map(Map<String, dynamic> data, {String? tablePrefix}) {
    return NodeAddresse.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $NodeAddressesTable createAlias(String alias) {
    return $NodeAddressesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final String label;
  final int amountMsat;
  final int receivedMsat;
  final int status;
  final int paymentTime;
  final int expiryTime;
  final String bolt11;
  final String paymentPreimage;
  final String paymentHash;
  Invoice(
      {required this.label,
      required this.amountMsat,
      required this.receivedMsat,
      required this.status,
      required this.paymentTime,
      required this.expiryTime,
      required this.bolt11,
      required this.paymentPreimage,
      required this.paymentHash});
  factory Invoice.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Invoice(
      label: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}label'])!,
      amountMsat: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount_msat'])!,
      receivedMsat: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}received_msat'])!,
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      paymentTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payment_time'])!,
      expiryTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}expiry_time'])!,
      bolt11: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bolt11'])!,
      paymentPreimage: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payment_preimage'])!,
      paymentHash: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payment_hash'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['label'] = Variable<String>(label);
    map['amount_msat'] = Variable<int>(amountMsat);
    map['received_msat'] = Variable<int>(receivedMsat);
    map['status'] = Variable<int>(status);
    map['payment_time'] = Variable<int>(paymentTime);
    map['expiry_time'] = Variable<int>(expiryTime);
    map['bolt11'] = Variable<String>(bolt11);
    map['payment_preimage'] = Variable<String>(paymentPreimage);
    map['payment_hash'] = Variable<String>(paymentHash);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      label: Value(label),
      amountMsat: Value(amountMsat),
      receivedMsat: Value(receivedMsat),
      status: Value(status),
      paymentTime: Value(paymentTime),
      expiryTime: Value(expiryTime),
      bolt11: Value(bolt11),
      paymentPreimage: Value(paymentPreimage),
      paymentHash: Value(paymentHash),
    );
  }

  factory Invoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      label: serializer.fromJson<String>(json['label']),
      amountMsat: serializer.fromJson<int>(json['amountMsat']),
      receivedMsat: serializer.fromJson<int>(json['receivedMsat']),
      status: serializer.fromJson<int>(json['status']),
      paymentTime: serializer.fromJson<int>(json['paymentTime']),
      expiryTime: serializer.fromJson<int>(json['expiryTime']),
      bolt11: serializer.fromJson<String>(json['bolt11']),
      paymentPreimage: serializer.fromJson<String>(json['paymentPreimage']),
      paymentHash: serializer.fromJson<String>(json['paymentHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'label': serializer.toJson<String>(label),
      'amountMsat': serializer.toJson<int>(amountMsat),
      'receivedMsat': serializer.toJson<int>(receivedMsat),
      'status': serializer.toJson<int>(status),
      'paymentTime': serializer.toJson<int>(paymentTime),
      'expiryTime': serializer.toJson<int>(expiryTime),
      'bolt11': serializer.toJson<String>(bolt11),
      'paymentPreimage': serializer.toJson<String>(paymentPreimage),
      'paymentHash': serializer.toJson<String>(paymentHash),
    };
  }

  Invoice copyWith(
          {String? label,
          int? amountMsat,
          int? receivedMsat,
          int? status,
          int? paymentTime,
          int? expiryTime,
          String? bolt11,
          String? paymentPreimage,
          String? paymentHash}) =>
      Invoice(
        label: label ?? this.label,
        amountMsat: amountMsat ?? this.amountMsat,
        receivedMsat: receivedMsat ?? this.receivedMsat,
        status: status ?? this.status,
        paymentTime: paymentTime ?? this.paymentTime,
        expiryTime: expiryTime ?? this.expiryTime,
        bolt11: bolt11 ?? this.bolt11,
        paymentPreimage: paymentPreimage ?? this.paymentPreimage,
        paymentHash: paymentHash ?? this.paymentHash,
      );
  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('label: $label, ')
          ..write('amountMsat: $amountMsat, ')
          ..write('receivedMsat: $receivedMsat, ')
          ..write('status: $status, ')
          ..write('paymentTime: $paymentTime, ')
          ..write('expiryTime: $expiryTime, ')
          ..write('bolt11: $bolt11, ')
          ..write('paymentPreimage: $paymentPreimage, ')
          ..write('paymentHash: $paymentHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(label, amountMsat, receivedMsat, status,
      paymentTime, expiryTime, bolt11, paymentPreimage, paymentHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.label == this.label &&
          other.amountMsat == this.amountMsat &&
          other.receivedMsat == this.receivedMsat &&
          other.status == this.status &&
          other.paymentTime == this.paymentTime &&
          other.expiryTime == this.expiryTime &&
          other.bolt11 == this.bolt11 &&
          other.paymentPreimage == this.paymentPreimage &&
          other.paymentHash == this.paymentHash);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<String> label;
  final Value<int> amountMsat;
  final Value<int> receivedMsat;
  final Value<int> status;
  final Value<int> paymentTime;
  final Value<int> expiryTime;
  final Value<String> bolt11;
  final Value<String> paymentPreimage;
  final Value<String> paymentHash;
  const InvoicesCompanion({
    this.label = const Value.absent(),
    this.amountMsat = const Value.absent(),
    this.receivedMsat = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentTime = const Value.absent(),
    this.expiryTime = const Value.absent(),
    this.bolt11 = const Value.absent(),
    this.paymentPreimage = const Value.absent(),
    this.paymentHash = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String label,
    required int amountMsat,
    required int receivedMsat,
    required int status,
    required int paymentTime,
    required int expiryTime,
    required String bolt11,
    required String paymentPreimage,
    required String paymentHash,
  })  : label = Value(label),
        amountMsat = Value(amountMsat),
        receivedMsat = Value(receivedMsat),
        status = Value(status),
        paymentTime = Value(paymentTime),
        expiryTime = Value(expiryTime),
        bolt11 = Value(bolt11),
        paymentPreimage = Value(paymentPreimage),
        paymentHash = Value(paymentHash);
  static Insertable<Invoice> custom({
    Expression<String>? label,
    Expression<int>? amountMsat,
    Expression<int>? receivedMsat,
    Expression<int>? status,
    Expression<int>? paymentTime,
    Expression<int>? expiryTime,
    Expression<String>? bolt11,
    Expression<String>? paymentPreimage,
    Expression<String>? paymentHash,
  }) {
    return RawValuesInsertable({
      if (label != null) 'label': label,
      if (amountMsat != null) 'amount_msat': amountMsat,
      if (receivedMsat != null) 'received_msat': receivedMsat,
      if (status != null) 'status': status,
      if (paymentTime != null) 'payment_time': paymentTime,
      if (expiryTime != null) 'expiry_time': expiryTime,
      if (bolt11 != null) 'bolt11': bolt11,
      if (paymentPreimage != null) 'payment_preimage': paymentPreimage,
      if (paymentHash != null) 'payment_hash': paymentHash,
    });
  }

  InvoicesCompanion copyWith(
      {Value<String>? label,
      Value<int>? amountMsat,
      Value<int>? receivedMsat,
      Value<int>? status,
      Value<int>? paymentTime,
      Value<int>? expiryTime,
      Value<String>? bolt11,
      Value<String>? paymentPreimage,
      Value<String>? paymentHash}) {
    return InvoicesCompanion(
      label: label ?? this.label,
      amountMsat: amountMsat ?? this.amountMsat,
      receivedMsat: receivedMsat ?? this.receivedMsat,
      status: status ?? this.status,
      paymentTime: paymentTime ?? this.paymentTime,
      expiryTime: expiryTime ?? this.expiryTime,
      bolt11: bolt11 ?? this.bolt11,
      paymentPreimage: paymentPreimage ?? this.paymentPreimage,
      paymentHash: paymentHash ?? this.paymentHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (amountMsat.present) {
      map['amount_msat'] = Variable<int>(amountMsat.value);
    }
    if (receivedMsat.present) {
      map['received_msat'] = Variable<int>(receivedMsat.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (paymentTime.present) {
      map['payment_time'] = Variable<int>(paymentTime.value);
    }
    if (expiryTime.present) {
      map['expiry_time'] = Variable<int>(expiryTime.value);
    }
    if (bolt11.present) {
      map['bolt11'] = Variable<String>(bolt11.value);
    }
    if (paymentPreimage.present) {
      map['payment_preimage'] = Variable<String>(paymentPreimage.value);
    }
    if (paymentHash.present) {
      map['payment_hash'] = Variable<String>(paymentHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('label: $label, ')
          ..write('amountMsat: $amountMsat, ')
          ..write('receivedMsat: $receivedMsat, ')
          ..write('status: $status, ')
          ..write('paymentTime: $paymentTime, ')
          ..write('expiryTime: $expiryTime, ')
          ..write('bolt11: $bolt11, ')
          ..write('paymentPreimage: $paymentPreimage, ')
          ..write('paymentHash: $paymentHash')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String?> label = GeneratedColumn<String?>(
      'label', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _amountMsatMeta = const VerificationMeta('amountMsat');
  @override
  late final GeneratedColumn<int?> amountMsat = GeneratedColumn<int?>(
      'amount_msat', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _receivedMsatMeta =
      const VerificationMeta('receivedMsat');
  @override
  late final GeneratedColumn<int?> receivedMsat = GeneratedColumn<int?>(
      'received_msat', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _paymentTimeMeta =
      const VerificationMeta('paymentTime');
  @override
  late final GeneratedColumn<int?> paymentTime = GeneratedColumn<int?>(
      'payment_time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _expiryTimeMeta = const VerificationMeta('expiryTime');
  @override
  late final GeneratedColumn<int?> expiryTime = GeneratedColumn<int?>(
      'expiry_time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _bolt11Meta = const VerificationMeta('bolt11');
  @override
  late final GeneratedColumn<String?> bolt11 = GeneratedColumn<String?>(
      'bolt11', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _paymentPreimageMeta =
      const VerificationMeta('paymentPreimage');
  @override
  late final GeneratedColumn<String?> paymentPreimage =
      GeneratedColumn<String?>('payment_preimage', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _paymentHashMeta =
      const VerificationMeta('paymentHash');
  @override
  late final GeneratedColumn<String?> paymentHash = GeneratedColumn<String?>(
      'payment_hash', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        label,
        amountMsat,
        receivedMsat,
        status,
        paymentTime,
        expiryTime,
        bolt11,
        paymentPreimage,
        paymentHash
      ];
  @override
  String get aliasedName => _alias ?? 'invoices';
  @override
  String get actualTableName => 'invoices';
  @override
  VerificationContext validateIntegrity(Insertable<Invoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('amount_msat')) {
      context.handle(
          _amountMsatMeta,
          amountMsat.isAcceptableOrUnknown(
              data['amount_msat']!, _amountMsatMeta));
    } else if (isInserting) {
      context.missing(_amountMsatMeta);
    }
    if (data.containsKey('received_msat')) {
      context.handle(
          _receivedMsatMeta,
          receivedMsat.isAcceptableOrUnknown(
              data['received_msat']!, _receivedMsatMeta));
    } else if (isInserting) {
      context.missing(_receivedMsatMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payment_time')) {
      context.handle(
          _paymentTimeMeta,
          paymentTime.isAcceptableOrUnknown(
              data['payment_time']!, _paymentTimeMeta));
    } else if (isInserting) {
      context.missing(_paymentTimeMeta);
    }
    if (data.containsKey('expiry_time')) {
      context.handle(
          _expiryTimeMeta,
          expiryTime.isAcceptableOrUnknown(
              data['expiry_time']!, _expiryTimeMeta));
    } else if (isInserting) {
      context.missing(_expiryTimeMeta);
    }
    if (data.containsKey('bolt11')) {
      context.handle(_bolt11Meta,
          bolt11.isAcceptableOrUnknown(data['bolt11']!, _bolt11Meta));
    } else if (isInserting) {
      context.missing(_bolt11Meta);
    }
    if (data.containsKey('payment_preimage')) {
      context.handle(
          _paymentPreimageMeta,
          paymentPreimage.isAcceptableOrUnknown(
              data['payment_preimage']!, _paymentPreimageMeta));
    } else if (isInserting) {
      context.missing(_paymentPreimageMeta);
    }
    if (data.containsKey('payment_hash')) {
      context.handle(
          _paymentHashMeta,
          paymentHash.isAcceptableOrUnknown(
              data['payment_hash']!, _paymentHashMeta));
    } else if (isInserting) {
      context.missing(_paymentHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Invoice.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class OutgoingLightningPayment extends DataClass
    implements Insertable<OutgoingLightningPayment> {
  final int createdAt;
  final String paymentHash;
  final String destination;
  final int feeMsat;
  final int amountMsats;
  final int amountSentMsats;
  final String preimage;
  final bool isKeySend;
  final bool pending;
  final String bolt11;
  OutgoingLightningPayment(
      {required this.createdAt,
      required this.paymentHash,
      required this.destination,
      required this.feeMsat,
      required this.amountMsats,
      required this.amountSentMsats,
      required this.preimage,
      required this.isKeySend,
      required this.pending,
      required this.bolt11});
  factory OutgoingLightningPayment.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return OutgoingLightningPayment(
      createdAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      paymentHash: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payment_hash'])!,
      destination: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}destination'])!,
      feeMsat: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fee_msat'])!,
      amountMsats: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount_msats'])!,
      amountSentMsats: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}amount_sent_msats'])!,
      preimage: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}preimage'])!,
      isKeySend: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_key_send'])!,
      pending: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pending'])!,
      bolt11: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bolt11'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<int>(createdAt);
    map['payment_hash'] = Variable<String>(paymentHash);
    map['destination'] = Variable<String>(destination);
    map['fee_msat'] = Variable<int>(feeMsat);
    map['amount_msats'] = Variable<int>(amountMsats);
    map['amount_sent_msats'] = Variable<int>(amountSentMsats);
    map['preimage'] = Variable<String>(preimage);
    map['is_key_send'] = Variable<bool>(isKeySend);
    map['pending'] = Variable<bool>(pending);
    map['bolt11'] = Variable<String>(bolt11);
    return map;
  }

  OutgoingLightningPaymentsCompanion toCompanion(bool nullToAbsent) {
    return OutgoingLightningPaymentsCompanion(
      createdAt: Value(createdAt),
      paymentHash: Value(paymentHash),
      destination: Value(destination),
      feeMsat: Value(feeMsat),
      amountMsats: Value(amountMsats),
      amountSentMsats: Value(amountSentMsats),
      preimage: Value(preimage),
      isKeySend: Value(isKeySend),
      pending: Value(pending),
      bolt11: Value(bolt11),
    );
  }

  factory OutgoingLightningPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutgoingLightningPayment(
      createdAt: serializer.fromJson<int>(json['createdAt']),
      paymentHash: serializer.fromJson<String>(json['paymentHash']),
      destination: serializer.fromJson<String>(json['destination']),
      feeMsat: serializer.fromJson<int>(json['feeMsat']),
      amountMsats: serializer.fromJson<int>(json['amountMsats']),
      amountSentMsats: serializer.fromJson<int>(json['amountSentMsats']),
      preimage: serializer.fromJson<String>(json['preimage']),
      isKeySend: serializer.fromJson<bool>(json['isKeySend']),
      pending: serializer.fromJson<bool>(json['pending']),
      bolt11: serializer.fromJson<String>(json['bolt11']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<int>(createdAt),
      'paymentHash': serializer.toJson<String>(paymentHash),
      'destination': serializer.toJson<String>(destination),
      'feeMsat': serializer.toJson<int>(feeMsat),
      'amountMsats': serializer.toJson<int>(amountMsats),
      'amountSentMsats': serializer.toJson<int>(amountSentMsats),
      'preimage': serializer.toJson<String>(preimage),
      'isKeySend': serializer.toJson<bool>(isKeySend),
      'pending': serializer.toJson<bool>(pending),
      'bolt11': serializer.toJson<String>(bolt11),
    };
  }

  OutgoingLightningPayment copyWith(
          {int? createdAt,
          String? paymentHash,
          String? destination,
          int? feeMsat,
          int? amountMsats,
          int? amountSentMsats,
          String? preimage,
          bool? isKeySend,
          bool? pending,
          String? bolt11}) =>
      OutgoingLightningPayment(
        createdAt: createdAt ?? this.createdAt,
        paymentHash: paymentHash ?? this.paymentHash,
        destination: destination ?? this.destination,
        feeMsat: feeMsat ?? this.feeMsat,
        amountMsats: amountMsats ?? this.amountMsats,
        amountSentMsats: amountSentMsats ?? this.amountSentMsats,
        preimage: preimage ?? this.preimage,
        isKeySend: isKeySend ?? this.isKeySend,
        pending: pending ?? this.pending,
        bolt11: bolt11 ?? this.bolt11,
      );
  @override
  String toString() {
    return (StringBuffer('OutgoingLightningPayment(')
          ..write('createdAt: $createdAt, ')
          ..write('paymentHash: $paymentHash, ')
          ..write('destination: $destination, ')
          ..write('feeMsat: $feeMsat, ')
          ..write('amountMsats: $amountMsats, ')
          ..write('amountSentMsats: $amountSentMsats, ')
          ..write('preimage: $preimage, ')
          ..write('isKeySend: $isKeySend, ')
          ..write('pending: $pending, ')
          ..write('bolt11: $bolt11')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(createdAt, paymentHash, destination, feeMsat,
      amountMsats, amountSentMsats, preimage, isKeySend, pending, bolt11);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutgoingLightningPayment &&
          other.createdAt == this.createdAt &&
          other.paymentHash == this.paymentHash &&
          other.destination == this.destination &&
          other.feeMsat == this.feeMsat &&
          other.amountMsats == this.amountMsats &&
          other.amountSentMsats == this.amountSentMsats &&
          other.preimage == this.preimage &&
          other.isKeySend == this.isKeySend &&
          other.pending == this.pending &&
          other.bolt11 == this.bolt11);
}

class OutgoingLightningPaymentsCompanion
    extends UpdateCompanion<OutgoingLightningPayment> {
  final Value<int> createdAt;
  final Value<String> paymentHash;
  final Value<String> destination;
  final Value<int> feeMsat;
  final Value<int> amountMsats;
  final Value<int> amountSentMsats;
  final Value<String> preimage;
  final Value<bool> isKeySend;
  final Value<bool> pending;
  final Value<String> bolt11;
  const OutgoingLightningPaymentsCompanion({
    this.createdAt = const Value.absent(),
    this.paymentHash = const Value.absent(),
    this.destination = const Value.absent(),
    this.feeMsat = const Value.absent(),
    this.amountMsats = const Value.absent(),
    this.amountSentMsats = const Value.absent(),
    this.preimage = const Value.absent(),
    this.isKeySend = const Value.absent(),
    this.pending = const Value.absent(),
    this.bolt11 = const Value.absent(),
  });
  OutgoingLightningPaymentsCompanion.insert({
    required int createdAt,
    required String paymentHash,
    required String destination,
    required int feeMsat,
    required int amountMsats,
    required int amountSentMsats,
    required String preimage,
    required bool isKeySend,
    required bool pending,
    required String bolt11,
  })  : createdAt = Value(createdAt),
        paymentHash = Value(paymentHash),
        destination = Value(destination),
        feeMsat = Value(feeMsat),
        amountMsats = Value(amountMsats),
        amountSentMsats = Value(amountSentMsats),
        preimage = Value(preimage),
        isKeySend = Value(isKeySend),
        pending = Value(pending),
        bolt11 = Value(bolt11);
  static Insertable<OutgoingLightningPayment> custom({
    Expression<int>? createdAt,
    Expression<String>? paymentHash,
    Expression<String>? destination,
    Expression<int>? feeMsat,
    Expression<int>? amountMsats,
    Expression<int>? amountSentMsats,
    Expression<String>? preimage,
    Expression<bool>? isKeySend,
    Expression<bool>? pending,
    Expression<String>? bolt11,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (paymentHash != null) 'payment_hash': paymentHash,
      if (destination != null) 'destination': destination,
      if (feeMsat != null) 'fee_msat': feeMsat,
      if (amountMsats != null) 'amount_msats': amountMsats,
      if (amountSentMsats != null) 'amount_sent_msats': amountSentMsats,
      if (preimage != null) 'preimage': preimage,
      if (isKeySend != null) 'is_key_send': isKeySend,
      if (pending != null) 'pending': pending,
      if (bolt11 != null) 'bolt11': bolt11,
    });
  }

  OutgoingLightningPaymentsCompanion copyWith(
      {Value<int>? createdAt,
      Value<String>? paymentHash,
      Value<String>? destination,
      Value<int>? feeMsat,
      Value<int>? amountMsats,
      Value<int>? amountSentMsats,
      Value<String>? preimage,
      Value<bool>? isKeySend,
      Value<bool>? pending,
      Value<String>? bolt11}) {
    return OutgoingLightningPaymentsCompanion(
      createdAt: createdAt ?? this.createdAt,
      paymentHash: paymentHash ?? this.paymentHash,
      destination: destination ?? this.destination,
      feeMsat: feeMsat ?? this.feeMsat,
      amountMsats: amountMsats ?? this.amountMsats,
      amountSentMsats: amountSentMsats ?? this.amountSentMsats,
      preimage: preimage ?? this.preimage,
      isKeySend: isKeySend ?? this.isKeySend,
      pending: pending ?? this.pending,
      bolt11: bolt11 ?? this.bolt11,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (paymentHash.present) {
      map['payment_hash'] = Variable<String>(paymentHash.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (feeMsat.present) {
      map['fee_msat'] = Variable<int>(feeMsat.value);
    }
    if (amountMsats.present) {
      map['amount_msats'] = Variable<int>(amountMsats.value);
    }
    if (amountSentMsats.present) {
      map['amount_sent_msats'] = Variable<int>(amountSentMsats.value);
    }
    if (preimage.present) {
      map['preimage'] = Variable<String>(preimage.value);
    }
    if (isKeySend.present) {
      map['is_key_send'] = Variable<bool>(isKeySend.value);
    }
    if (pending.present) {
      map['pending'] = Variable<bool>(pending.value);
    }
    if (bolt11.present) {
      map['bolt11'] = Variable<String>(bolt11.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutgoingLightningPaymentsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('paymentHash: $paymentHash, ')
          ..write('destination: $destination, ')
          ..write('feeMsat: $feeMsat, ')
          ..write('amountMsats: $amountMsats, ')
          ..write('amountSentMsats: $amountSentMsats, ')
          ..write('preimage: $preimage, ')
          ..write('isKeySend: $isKeySend, ')
          ..write('pending: $pending, ')
          ..write('bolt11: $bolt11')
          ..write(')'))
        .toString();
  }
}

class $OutgoingLightningPaymentsTable extends OutgoingLightningPayments
    with TableInfo<$OutgoingLightningPaymentsTable, OutgoingLightningPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutgoingLightningPaymentsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int?> createdAt = GeneratedColumn<int?>(
      'created_at', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _paymentHashMeta =
      const VerificationMeta('paymentHash');
  @override
  late final GeneratedColumn<String?> paymentHash = GeneratedColumn<String?>(
      'payment_hash', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _destinationMeta =
      const VerificationMeta('destination');
  @override
  late final GeneratedColumn<String?> destination = GeneratedColumn<String?>(
      'destination', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 66, maxTextLength: 66),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _feeMsatMeta = const VerificationMeta('feeMsat');
  @override
  late final GeneratedColumn<int?> feeMsat = GeneratedColumn<int?>(
      'fee_msat', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _amountMsatsMeta =
      const VerificationMeta('amountMsats');
  @override
  late final GeneratedColumn<int?> amountMsats = GeneratedColumn<int?>(
      'amount_msats', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _amountSentMsatsMeta =
      const VerificationMeta('amountSentMsats');
  @override
  late final GeneratedColumn<int?> amountSentMsats = GeneratedColumn<int?>(
      'amount_sent_msats', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _preimageMeta = const VerificationMeta('preimage');
  @override
  late final GeneratedColumn<String?> preimage = GeneratedColumn<String?>(
      'preimage', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _isKeySendMeta = const VerificationMeta('isKeySend');
  @override
  late final GeneratedColumn<bool?> isKeySend = GeneratedColumn<bool?>(
      'is_key_send', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_key_send IN (0, 1))');
  final VerificationMeta _pendingMeta = const VerificationMeta('pending');
  @override
  late final GeneratedColumn<bool?> pending = GeneratedColumn<bool?>(
      'pending', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (pending IN (0, 1))');
  final VerificationMeta _bolt11Meta = const VerificationMeta('bolt11');
  @override
  late final GeneratedColumn<String?> bolt11 = GeneratedColumn<String?>(
      'bolt11', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        createdAt,
        paymentHash,
        destination,
        feeMsat,
        amountMsats,
        amountSentMsats,
        preimage,
        isKeySend,
        pending,
        bolt11
      ];
  @override
  String get aliasedName => _alias ?? 'outgoing_lightning_payments';
  @override
  String get actualTableName => 'outgoing_lightning_payments';
  @override
  VerificationContext validateIntegrity(
      Insertable<OutgoingLightningPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('payment_hash')) {
      context.handle(
          _paymentHashMeta,
          paymentHash.isAcceptableOrUnknown(
              data['payment_hash']!, _paymentHashMeta));
    } else if (isInserting) {
      context.missing(_paymentHashMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
          _destinationMeta,
          destination.isAcceptableOrUnknown(
              data['destination']!, _destinationMeta));
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('fee_msat')) {
      context.handle(_feeMsatMeta,
          feeMsat.isAcceptableOrUnknown(data['fee_msat']!, _feeMsatMeta));
    } else if (isInserting) {
      context.missing(_feeMsatMeta);
    }
    if (data.containsKey('amount_msats')) {
      context.handle(
          _amountMsatsMeta,
          amountMsats.isAcceptableOrUnknown(
              data['amount_msats']!, _amountMsatsMeta));
    } else if (isInserting) {
      context.missing(_amountMsatsMeta);
    }
    if (data.containsKey('amount_sent_msats')) {
      context.handle(
          _amountSentMsatsMeta,
          amountSentMsats.isAcceptableOrUnknown(
              data['amount_sent_msats']!, _amountSentMsatsMeta));
    } else if (isInserting) {
      context.missing(_amountSentMsatsMeta);
    }
    if (data.containsKey('preimage')) {
      context.handle(_preimageMeta,
          preimage.isAcceptableOrUnknown(data['preimage']!, _preimageMeta));
    } else if (isInserting) {
      context.missing(_preimageMeta);
    }
    if (data.containsKey('is_key_send')) {
      context.handle(
          _isKeySendMeta,
          isKeySend.isAcceptableOrUnknown(
              data['is_key_send']!, _isKeySendMeta));
    } else if (isInserting) {
      context.missing(_isKeySendMeta);
    }
    if (data.containsKey('pending')) {
      context.handle(_pendingMeta,
          pending.isAcceptableOrUnknown(data['pending']!, _pendingMeta));
    } else if (isInserting) {
      context.missing(_pendingMeta);
    }
    if (data.containsKey('bolt11')) {
      context.handle(_bolt11Meta,
          bolt11.isAcceptableOrUnknown(data['bolt11']!, _bolt11Meta));
    } else if (isInserting) {
      context.missing(_bolt11Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  OutgoingLightningPayment map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    return OutgoingLightningPayment.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $OutgoingLightningPaymentsTable createAlias(String alias) {
    return $OutgoingLightningPaymentsTable(attachedDatabase, alias);
  }
}

class Peer extends DataClass implements Insertable<Peer> {
  final String peerId;
  final bool connected;
  final String features;
  Peer({required this.peerId, required this.connected, required this.features});
  factory Peer.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Peer(
      peerId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}peer_id'])!,
      connected: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}connected'])!,
      features: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}features'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['peer_id'] = Variable<String>(peerId);
    map['connected'] = Variable<bool>(connected);
    map['features'] = Variable<String>(features);
    return map;
  }

  PeersCompanion toCompanion(bool nullToAbsent) {
    return PeersCompanion(
      peerId: Value(peerId),
      connected: Value(connected),
      features: Value(features),
    );
  }

  factory Peer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Peer(
      peerId: serializer.fromJson<String>(json['peerId']),
      connected: serializer.fromJson<bool>(json['connected']),
      features: serializer.fromJson<String>(json['features']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'peerId': serializer.toJson<String>(peerId),
      'connected': serializer.toJson<bool>(connected),
      'features': serializer.toJson<String>(features),
    };
  }

  Peer copyWith({String? peerId, bool? connected, String? features}) => Peer(
        peerId: peerId ?? this.peerId,
        connected: connected ?? this.connected,
        features: features ?? this.features,
      );
  @override
  String toString() {
    return (StringBuffer('Peer(')
          ..write('peerId: $peerId, ')
          ..write('connected: $connected, ')
          ..write('features: $features')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(peerId, connected, features);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Peer &&
          other.peerId == this.peerId &&
          other.connected == this.connected &&
          other.features == this.features);
}

class PeersCompanion extends UpdateCompanion<Peer> {
  final Value<String> peerId;
  final Value<bool> connected;
  final Value<String> features;
  const PeersCompanion({
    this.peerId = const Value.absent(),
    this.connected = const Value.absent(),
    this.features = const Value.absent(),
  });
  PeersCompanion.insert({
    required String peerId,
    required bool connected,
    required String features,
  })  : peerId = Value(peerId),
        connected = Value(connected),
        features = Value(features);
  static Insertable<Peer> custom({
    Expression<String>? peerId,
    Expression<bool>? connected,
    Expression<String>? features,
  }) {
    return RawValuesInsertable({
      if (peerId != null) 'peer_id': peerId,
      if (connected != null) 'connected': connected,
      if (features != null) 'features': features,
    });
  }

  PeersCompanion copyWith(
      {Value<String>? peerId,
      Value<bool>? connected,
      Value<String>? features}) {
    return PeersCompanion(
      peerId: peerId ?? this.peerId,
      connected: connected ?? this.connected,
      features: features ?? this.features,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (peerId.present) {
      map['peer_id'] = Variable<String>(peerId.value);
    }
    if (connected.present) {
      map['connected'] = Variable<bool>(connected.value);
    }
    if (features.present) {
      map['features'] = Variable<String>(features.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeersCompanion(')
          ..write('peerId: $peerId, ')
          ..write('connected: $connected, ')
          ..write('features: $features')
          ..write(')'))
        .toString();
  }
}

class $PeersTable extends Peers with TableInfo<$PeersTable, Peer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _peerIdMeta = const VerificationMeta('peerId');
  @override
  late final GeneratedColumn<String?> peerId = GeneratedColumn<String?>(
      'peer_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 66, maxTextLength: 66),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _connectedMeta = const VerificationMeta('connected');
  @override
  late final GeneratedColumn<bool?> connected = GeneratedColumn<bool?>(
      'connected', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (connected IN (0, 1))');
  final VerificationMeta _featuresMeta = const VerificationMeta('features');
  @override
  late final GeneratedColumn<String?> features = GeneratedColumn<String?>(
      'features', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [peerId, connected, features];
  @override
  String get aliasedName => _alias ?? 'peers';
  @override
  String get actualTableName => 'peers';
  @override
  VerificationContext validateIntegrity(Insertable<Peer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('peer_id')) {
      context.handle(_peerIdMeta,
          peerId.isAcceptableOrUnknown(data['peer_id']!, _peerIdMeta));
    } else if (isInserting) {
      context.missing(_peerIdMeta);
    }
    if (data.containsKey('connected')) {
      context.handle(_connectedMeta,
          connected.isAcceptableOrUnknown(data['connected']!, _connectedMeta));
    } else if (isInserting) {
      context.missing(_connectedMeta);
    }
    if (data.containsKey('features')) {
      context.handle(_featuresMeta,
          features.isAcceptableOrUnknown(data['features']!, _featuresMeta));
    } else if (isInserting) {
      context.missing(_featuresMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {peerId};
  @override
  Peer map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Peer.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PeersTable createAlias(String alias) {
    return $PeersTable(attachedDatabase, alias);
  }
}

class Channel extends DataClass implements Insertable<Channel> {
  final int channelState;
  final String? shortChannelId;
  final int direction;
  final String channelId;
  final String fundingTxid;
  final String closeToAddr;
  final String closeTo;
  final bool private;
  final int totalMsat;
  final int dustLimitMsat;
  final int spendableMsat;
  final int receivableMsat;
  final int theirToSelfDelay;
  final int ourToSelfDelay;
  final String peerId;
  Channel(
      {required this.channelState,
      this.shortChannelId,
      required this.direction,
      required this.channelId,
      required this.fundingTxid,
      required this.closeToAddr,
      required this.closeTo,
      required this.private,
      required this.totalMsat,
      required this.dustLimitMsat,
      required this.spendableMsat,
      required this.receivableMsat,
      required this.theirToSelfDelay,
      required this.ourToSelfDelay,
      required this.peerId});
  factory Channel.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Channel(
      channelState: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_state'])!,
      shortChannelId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}short_channel_id']),
      direction: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}direction'])!,
      channelId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_id'])!,
      fundingTxid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}funding_txid'])!,
      closeToAddr: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}close_to_addr'])!,
      closeTo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}close_to'])!,
      private: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}private'])!,
      totalMsat: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total_msat'])!,
      dustLimitMsat: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dust_limit_msat'])!,
      spendableMsat: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}spendable_msat'])!,
      receivableMsat: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}receivable_msat'])!,
      theirToSelfDelay: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}their_to_self_delay'])!,
      ourToSelfDelay: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}our_to_self_delay'])!,
      peerId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}peer_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_state'] = Variable<int>(channelState);
    if (!nullToAbsent || shortChannelId != null) {
      map['short_channel_id'] = Variable<String?>(shortChannelId);
    }
    map['direction'] = Variable<int>(direction);
    map['channel_id'] = Variable<String>(channelId);
    map['funding_txid'] = Variable<String>(fundingTxid);
    map['close_to_addr'] = Variable<String>(closeToAddr);
    map['close_to'] = Variable<String>(closeTo);
    map['private'] = Variable<bool>(private);
    map['total_msat'] = Variable<int>(totalMsat);
    map['dust_limit_msat'] = Variable<int>(dustLimitMsat);
    map['spendable_msat'] = Variable<int>(spendableMsat);
    map['receivable_msat'] = Variable<int>(receivableMsat);
    map['their_to_self_delay'] = Variable<int>(theirToSelfDelay);
    map['our_to_self_delay'] = Variable<int>(ourToSelfDelay);
    map['peer_id'] = Variable<String>(peerId);
    return map;
  }

  ChannelsCompanion toCompanion(bool nullToAbsent) {
    return ChannelsCompanion(
      channelState: Value(channelState),
      shortChannelId: shortChannelId == null && nullToAbsent
          ? const Value.absent()
          : Value(shortChannelId),
      direction: Value(direction),
      channelId: Value(channelId),
      fundingTxid: Value(fundingTxid),
      closeToAddr: Value(closeToAddr),
      closeTo: Value(closeTo),
      private: Value(private),
      totalMsat: Value(totalMsat),
      dustLimitMsat: Value(dustLimitMsat),
      spendableMsat: Value(spendableMsat),
      receivableMsat: Value(receivableMsat),
      theirToSelfDelay: Value(theirToSelfDelay),
      ourToSelfDelay: Value(ourToSelfDelay),
      peerId: Value(peerId),
    );
  }

  factory Channel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Channel(
      channelState: serializer.fromJson<int>(json['channelState']),
      shortChannelId: serializer.fromJson<String?>(json['shortChannelId']),
      direction: serializer.fromJson<int>(json['direction']),
      channelId: serializer.fromJson<String>(json['channelId']),
      fundingTxid: serializer.fromJson<String>(json['fundingTxid']),
      closeToAddr: serializer.fromJson<String>(json['closeToAddr']),
      closeTo: serializer.fromJson<String>(json['closeTo']),
      private: serializer.fromJson<bool>(json['private']),
      totalMsat: serializer.fromJson<int>(json['totalMsat']),
      dustLimitMsat: serializer.fromJson<int>(json['dustLimitMsat']),
      spendableMsat: serializer.fromJson<int>(json['spendableMsat']),
      receivableMsat: serializer.fromJson<int>(json['receivableMsat']),
      theirToSelfDelay: serializer.fromJson<int>(json['theirToSelfDelay']),
      ourToSelfDelay: serializer.fromJson<int>(json['ourToSelfDelay']),
      peerId: serializer.fromJson<String>(json['peerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelState': serializer.toJson<int>(channelState),
      'shortChannelId': serializer.toJson<String?>(shortChannelId),
      'direction': serializer.toJson<int>(direction),
      'channelId': serializer.toJson<String>(channelId),
      'fundingTxid': serializer.toJson<String>(fundingTxid),
      'closeToAddr': serializer.toJson<String>(closeToAddr),
      'closeTo': serializer.toJson<String>(closeTo),
      'private': serializer.toJson<bool>(private),
      'totalMsat': serializer.toJson<int>(totalMsat),
      'dustLimitMsat': serializer.toJson<int>(dustLimitMsat),
      'spendableMsat': serializer.toJson<int>(spendableMsat),
      'receivableMsat': serializer.toJson<int>(receivableMsat),
      'theirToSelfDelay': serializer.toJson<int>(theirToSelfDelay),
      'ourToSelfDelay': serializer.toJson<int>(ourToSelfDelay),
      'peerId': serializer.toJson<String>(peerId),
    };
  }

  Channel copyWith(
          {int? channelState,
          String? shortChannelId,
          int? direction,
          String? channelId,
          String? fundingTxid,
          String? closeToAddr,
          String? closeTo,
          bool? private,
          int? totalMsat,
          int? dustLimitMsat,
          int? spendableMsat,
          int? receivableMsat,
          int? theirToSelfDelay,
          int? ourToSelfDelay,
          String? peerId}) =>
      Channel(
        channelState: channelState ?? this.channelState,
        shortChannelId: shortChannelId ?? this.shortChannelId,
        direction: direction ?? this.direction,
        channelId: channelId ?? this.channelId,
        fundingTxid: fundingTxid ?? this.fundingTxid,
        closeToAddr: closeToAddr ?? this.closeToAddr,
        closeTo: closeTo ?? this.closeTo,
        private: private ?? this.private,
        totalMsat: totalMsat ?? this.totalMsat,
        dustLimitMsat: dustLimitMsat ?? this.dustLimitMsat,
        spendableMsat: spendableMsat ?? this.spendableMsat,
        receivableMsat: receivableMsat ?? this.receivableMsat,
        theirToSelfDelay: theirToSelfDelay ?? this.theirToSelfDelay,
        ourToSelfDelay: ourToSelfDelay ?? this.ourToSelfDelay,
        peerId: peerId ?? this.peerId,
      );
  @override
  String toString() {
    return (StringBuffer('Channel(')
          ..write('channelState: $channelState, ')
          ..write('shortChannelId: $shortChannelId, ')
          ..write('direction: $direction, ')
          ..write('channelId: $channelId, ')
          ..write('fundingTxid: $fundingTxid, ')
          ..write('closeToAddr: $closeToAddr, ')
          ..write('closeTo: $closeTo, ')
          ..write('private: $private, ')
          ..write('totalMsat: $totalMsat, ')
          ..write('dustLimitMsat: $dustLimitMsat, ')
          ..write('spendableMsat: $spendableMsat, ')
          ..write('receivableMsat: $receivableMsat, ')
          ..write('theirToSelfDelay: $theirToSelfDelay, ')
          ..write('ourToSelfDelay: $ourToSelfDelay, ')
          ..write('peerId: $peerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      channelState,
      shortChannelId,
      direction,
      channelId,
      fundingTxid,
      closeToAddr,
      closeTo,
      private,
      totalMsat,
      dustLimitMsat,
      spendableMsat,
      receivableMsat,
      theirToSelfDelay,
      ourToSelfDelay,
      peerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Channel &&
          other.channelState == this.channelState &&
          other.shortChannelId == this.shortChannelId &&
          other.direction == this.direction &&
          other.channelId == this.channelId &&
          other.fundingTxid == this.fundingTxid &&
          other.closeToAddr == this.closeToAddr &&
          other.closeTo == this.closeTo &&
          other.private == this.private &&
          other.totalMsat == this.totalMsat &&
          other.dustLimitMsat == this.dustLimitMsat &&
          other.spendableMsat == this.spendableMsat &&
          other.receivableMsat == this.receivableMsat &&
          other.theirToSelfDelay == this.theirToSelfDelay &&
          other.ourToSelfDelay == this.ourToSelfDelay &&
          other.peerId == this.peerId);
}

class ChannelsCompanion extends UpdateCompanion<Channel> {
  final Value<int> channelState;
  final Value<String?> shortChannelId;
  final Value<int> direction;
  final Value<String> channelId;
  final Value<String> fundingTxid;
  final Value<String> closeToAddr;
  final Value<String> closeTo;
  final Value<bool> private;
  final Value<int> totalMsat;
  final Value<int> dustLimitMsat;
  final Value<int> spendableMsat;
  final Value<int> receivableMsat;
  final Value<int> theirToSelfDelay;
  final Value<int> ourToSelfDelay;
  final Value<String> peerId;
  const ChannelsCompanion({
    this.channelState = const Value.absent(),
    this.shortChannelId = const Value.absent(),
    this.direction = const Value.absent(),
    this.channelId = const Value.absent(),
    this.fundingTxid = const Value.absent(),
    this.closeToAddr = const Value.absent(),
    this.closeTo = const Value.absent(),
    this.private = const Value.absent(),
    this.totalMsat = const Value.absent(),
    this.dustLimitMsat = const Value.absent(),
    this.spendableMsat = const Value.absent(),
    this.receivableMsat = const Value.absent(),
    this.theirToSelfDelay = const Value.absent(),
    this.ourToSelfDelay = const Value.absent(),
    this.peerId = const Value.absent(),
  });
  ChannelsCompanion.insert({
    required int channelState,
    this.shortChannelId = const Value.absent(),
    required int direction,
    required String channelId,
    required String fundingTxid,
    required String closeToAddr,
    required String closeTo,
    required bool private,
    required int totalMsat,
    required int dustLimitMsat,
    required int spendableMsat,
    required int receivableMsat,
    required int theirToSelfDelay,
    required int ourToSelfDelay,
    required String peerId,
  })  : channelState = Value(channelState),
        direction = Value(direction),
        channelId = Value(channelId),
        fundingTxid = Value(fundingTxid),
        closeToAddr = Value(closeToAddr),
        closeTo = Value(closeTo),
        private = Value(private),
        totalMsat = Value(totalMsat),
        dustLimitMsat = Value(dustLimitMsat),
        spendableMsat = Value(spendableMsat),
        receivableMsat = Value(receivableMsat),
        theirToSelfDelay = Value(theirToSelfDelay),
        ourToSelfDelay = Value(ourToSelfDelay),
        peerId = Value(peerId);
  static Insertable<Channel> custom({
    Expression<int>? channelState,
    Expression<String?>? shortChannelId,
    Expression<int>? direction,
    Expression<String>? channelId,
    Expression<String>? fundingTxid,
    Expression<String>? closeToAddr,
    Expression<String>? closeTo,
    Expression<bool>? private,
    Expression<int>? totalMsat,
    Expression<int>? dustLimitMsat,
    Expression<int>? spendableMsat,
    Expression<int>? receivableMsat,
    Expression<int>? theirToSelfDelay,
    Expression<int>? ourToSelfDelay,
    Expression<String>? peerId,
  }) {
    return RawValuesInsertable({
      if (channelState != null) 'channel_state': channelState,
      if (shortChannelId != null) 'short_channel_id': shortChannelId,
      if (direction != null) 'direction': direction,
      if (channelId != null) 'channel_id': channelId,
      if (fundingTxid != null) 'funding_txid': fundingTxid,
      if (closeToAddr != null) 'close_to_addr': closeToAddr,
      if (closeTo != null) 'close_to': closeTo,
      if (private != null) 'private': private,
      if (totalMsat != null) 'total_msat': totalMsat,
      if (dustLimitMsat != null) 'dust_limit_msat': dustLimitMsat,
      if (spendableMsat != null) 'spendable_msat': spendableMsat,
      if (receivableMsat != null) 'receivable_msat': receivableMsat,
      if (theirToSelfDelay != null) 'their_to_self_delay': theirToSelfDelay,
      if (ourToSelfDelay != null) 'our_to_self_delay': ourToSelfDelay,
      if (peerId != null) 'peer_id': peerId,
    });
  }

  ChannelsCompanion copyWith(
      {Value<int>? channelState,
      Value<String?>? shortChannelId,
      Value<int>? direction,
      Value<String>? channelId,
      Value<String>? fundingTxid,
      Value<String>? closeToAddr,
      Value<String>? closeTo,
      Value<bool>? private,
      Value<int>? totalMsat,
      Value<int>? dustLimitMsat,
      Value<int>? spendableMsat,
      Value<int>? receivableMsat,
      Value<int>? theirToSelfDelay,
      Value<int>? ourToSelfDelay,
      Value<String>? peerId}) {
    return ChannelsCompanion(
      channelState: channelState ?? this.channelState,
      shortChannelId: shortChannelId ?? this.shortChannelId,
      direction: direction ?? this.direction,
      channelId: channelId ?? this.channelId,
      fundingTxid: fundingTxid ?? this.fundingTxid,
      closeToAddr: closeToAddr ?? this.closeToAddr,
      closeTo: closeTo ?? this.closeTo,
      private: private ?? this.private,
      totalMsat: totalMsat ?? this.totalMsat,
      dustLimitMsat: dustLimitMsat ?? this.dustLimitMsat,
      spendableMsat: spendableMsat ?? this.spendableMsat,
      receivableMsat: receivableMsat ?? this.receivableMsat,
      theirToSelfDelay: theirToSelfDelay ?? this.theirToSelfDelay,
      ourToSelfDelay: ourToSelfDelay ?? this.ourToSelfDelay,
      peerId: peerId ?? this.peerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelState.present) {
      map['channel_state'] = Variable<int>(channelState.value);
    }
    if (shortChannelId.present) {
      map['short_channel_id'] = Variable<String?>(shortChannelId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<int>(direction.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (fundingTxid.present) {
      map['funding_txid'] = Variable<String>(fundingTxid.value);
    }
    if (closeToAddr.present) {
      map['close_to_addr'] = Variable<String>(closeToAddr.value);
    }
    if (closeTo.present) {
      map['close_to'] = Variable<String>(closeTo.value);
    }
    if (private.present) {
      map['private'] = Variable<bool>(private.value);
    }
    if (totalMsat.present) {
      map['total_msat'] = Variable<int>(totalMsat.value);
    }
    if (dustLimitMsat.present) {
      map['dust_limit_msat'] = Variable<int>(dustLimitMsat.value);
    }
    if (spendableMsat.present) {
      map['spendable_msat'] = Variable<int>(spendableMsat.value);
    }
    if (receivableMsat.present) {
      map['receivable_msat'] = Variable<int>(receivableMsat.value);
    }
    if (theirToSelfDelay.present) {
      map['their_to_self_delay'] = Variable<int>(theirToSelfDelay.value);
    }
    if (ourToSelfDelay.present) {
      map['our_to_self_delay'] = Variable<int>(ourToSelfDelay.value);
    }
    if (peerId.present) {
      map['peer_id'] = Variable<String>(peerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelsCompanion(')
          ..write('channelState: $channelState, ')
          ..write('shortChannelId: $shortChannelId, ')
          ..write('direction: $direction, ')
          ..write('channelId: $channelId, ')
          ..write('fundingTxid: $fundingTxid, ')
          ..write('closeToAddr: $closeToAddr, ')
          ..write('closeTo: $closeTo, ')
          ..write('private: $private, ')
          ..write('totalMsat: $totalMsat, ')
          ..write('dustLimitMsat: $dustLimitMsat, ')
          ..write('spendableMsat: $spendableMsat, ')
          ..write('receivableMsat: $receivableMsat, ')
          ..write('theirToSelfDelay: $theirToSelfDelay, ')
          ..write('ourToSelfDelay: $ourToSelfDelay, ')
          ..write('peerId: $peerId')
          ..write(')'))
        .toString();
  }
}

class $ChannelsTable extends Channels with TableInfo<$ChannelsTable, Channel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _channelStateMeta =
      const VerificationMeta('channelState');
  @override
  late final GeneratedColumn<int?> channelState = GeneratedColumn<int?>(
      'channel_state', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _shortChannelIdMeta =
      const VerificationMeta('shortChannelId');
  @override
  late final GeneratedColumn<String?> shortChannelId = GeneratedColumn<String?>(
      'short_channel_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _directionMeta = const VerificationMeta('direction');
  @override
  late final GeneratedColumn<int?> direction = GeneratedColumn<int?>(
      'direction', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _channelIdMeta = const VerificationMeta('channelId');
  @override
  late final GeneratedColumn<String?> channelId = GeneratedColumn<String?>(
      'channel_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _fundingTxidMeta =
      const VerificationMeta('fundingTxid');
  @override
  late final GeneratedColumn<String?> fundingTxid = GeneratedColumn<String?>(
      'funding_txid', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _closeToAddrMeta =
      const VerificationMeta('closeToAddr');
  @override
  late final GeneratedColumn<String?> closeToAddr = GeneratedColumn<String?>(
      'close_to_addr', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _closeToMeta = const VerificationMeta('closeTo');
  @override
  late final GeneratedColumn<String?> closeTo = GeneratedColumn<String?>(
      'close_to', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _privateMeta = const VerificationMeta('private');
  @override
  late final GeneratedColumn<bool?> private = GeneratedColumn<bool?>(
      'private', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (private IN (0, 1))');
  final VerificationMeta _totalMsatMeta = const VerificationMeta('totalMsat');
  @override
  late final GeneratedColumn<int?> totalMsat = GeneratedColumn<int?>(
      'total_msat', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dustLimitMsatMeta =
      const VerificationMeta('dustLimitMsat');
  @override
  late final GeneratedColumn<int?> dustLimitMsat = GeneratedColumn<int?>(
      'dust_limit_msat', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _spendableMsatMeta =
      const VerificationMeta('spendableMsat');
  @override
  late final GeneratedColumn<int?> spendableMsat = GeneratedColumn<int?>(
      'spendable_msat', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _receivableMsatMeta =
      const VerificationMeta('receivableMsat');
  @override
  late final GeneratedColumn<int?> receivableMsat = GeneratedColumn<int?>(
      'receivable_msat', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _theirToSelfDelayMeta =
      const VerificationMeta('theirToSelfDelay');
  @override
  late final GeneratedColumn<int?> theirToSelfDelay = GeneratedColumn<int?>(
      'their_to_self_delay', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _ourToSelfDelayMeta =
      const VerificationMeta('ourToSelfDelay');
  @override
  late final GeneratedColumn<int?> ourToSelfDelay = GeneratedColumn<int?>(
      'our_to_self_delay', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _peerIdMeta = const VerificationMeta('peerId');
  @override
  late final GeneratedColumn<String?> peerId = GeneratedColumn<String?>(
      'peer_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 66, maxTextLength: 66),
      type: const StringType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES peers (peer_id)');
  @override
  List<GeneratedColumn> get $columns => [
        channelState,
        shortChannelId,
        direction,
        channelId,
        fundingTxid,
        closeToAddr,
        closeTo,
        private,
        totalMsat,
        dustLimitMsat,
        spendableMsat,
        receivableMsat,
        theirToSelfDelay,
        ourToSelfDelay,
        peerId
      ];
  @override
  String get aliasedName => _alias ?? 'channels';
  @override
  String get actualTableName => 'channels';
  @override
  VerificationContext validateIntegrity(Insertable<Channel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('channel_state')) {
      context.handle(
          _channelStateMeta,
          channelState.isAcceptableOrUnknown(
              data['channel_state']!, _channelStateMeta));
    } else if (isInserting) {
      context.missing(_channelStateMeta);
    }
    if (data.containsKey('short_channel_id')) {
      context.handle(
          _shortChannelIdMeta,
          shortChannelId.isAcceptableOrUnknown(
              data['short_channel_id']!, _shortChannelIdMeta));
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('funding_txid')) {
      context.handle(
          _fundingTxidMeta,
          fundingTxid.isAcceptableOrUnknown(
              data['funding_txid']!, _fundingTxidMeta));
    } else if (isInserting) {
      context.missing(_fundingTxidMeta);
    }
    if (data.containsKey('close_to_addr')) {
      context.handle(
          _closeToAddrMeta,
          closeToAddr.isAcceptableOrUnknown(
              data['close_to_addr']!, _closeToAddrMeta));
    } else if (isInserting) {
      context.missing(_closeToAddrMeta);
    }
    if (data.containsKey('close_to')) {
      context.handle(_closeToMeta,
          closeTo.isAcceptableOrUnknown(data['close_to']!, _closeToMeta));
    } else if (isInserting) {
      context.missing(_closeToMeta);
    }
    if (data.containsKey('private')) {
      context.handle(_privateMeta,
          private.isAcceptableOrUnknown(data['private']!, _privateMeta));
    } else if (isInserting) {
      context.missing(_privateMeta);
    }
    if (data.containsKey('total_msat')) {
      context.handle(_totalMsatMeta,
          totalMsat.isAcceptableOrUnknown(data['total_msat']!, _totalMsatMeta));
    } else if (isInserting) {
      context.missing(_totalMsatMeta);
    }
    if (data.containsKey('dust_limit_msat')) {
      context.handle(
          _dustLimitMsatMeta,
          dustLimitMsat.isAcceptableOrUnknown(
              data['dust_limit_msat']!, _dustLimitMsatMeta));
    } else if (isInserting) {
      context.missing(_dustLimitMsatMeta);
    }
    if (data.containsKey('spendable_msat')) {
      context.handle(
          _spendableMsatMeta,
          spendableMsat.isAcceptableOrUnknown(
              data['spendable_msat']!, _spendableMsatMeta));
    } else if (isInserting) {
      context.missing(_spendableMsatMeta);
    }
    if (data.containsKey('receivable_msat')) {
      context.handle(
          _receivableMsatMeta,
          receivableMsat.isAcceptableOrUnknown(
              data['receivable_msat']!, _receivableMsatMeta));
    } else if (isInserting) {
      context.missing(_receivableMsatMeta);
    }
    if (data.containsKey('their_to_self_delay')) {
      context.handle(
          _theirToSelfDelayMeta,
          theirToSelfDelay.isAcceptableOrUnknown(
              data['their_to_self_delay']!, _theirToSelfDelayMeta));
    } else if (isInserting) {
      context.missing(_theirToSelfDelayMeta);
    }
    if (data.containsKey('our_to_self_delay')) {
      context.handle(
          _ourToSelfDelayMeta,
          ourToSelfDelay.isAcceptableOrUnknown(
              data['our_to_self_delay']!, _ourToSelfDelayMeta));
    } else if (isInserting) {
      context.missing(_ourToSelfDelayMeta);
    }
    if (data.containsKey('peer_id')) {
      context.handle(_peerIdMeta,
          peerId.isAcceptableOrUnknown(data['peer_id']!, _peerIdMeta));
    } else if (isInserting) {
      context.missing(_peerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Channel map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Channel.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChannelsTable createAlias(String alias) {
    return $ChannelsTable(attachedDatabase, alias);
  }
}

class Htlc extends DataClass implements Insertable<Htlc> {
  final int direction;
  final int id;
  final int amountMsat;
  final int expiry;
  final String paymentHash;
  final String state;
  final bool localTrimmed;
  final String channelId;
  Htlc(
      {required this.direction,
      required this.id,
      required this.amountMsat,
      required this.expiry,
      required this.paymentHash,
      required this.state,
      required this.localTrimmed,
      required this.channelId});
  factory Htlc.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Htlc(
      direction: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}direction'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      amountMsat: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount_msat'])!,
      expiry: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}expiry'])!,
      paymentHash: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payment_hash'])!,
      state: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}state'])!,
      localTrimmed: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}local_trimmed'])!,
      channelId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['direction'] = Variable<int>(direction);
    map['id'] = Variable<int>(id);
    map['amount_msat'] = Variable<int>(amountMsat);
    map['expiry'] = Variable<int>(expiry);
    map['payment_hash'] = Variable<String>(paymentHash);
    map['state'] = Variable<String>(state);
    map['local_trimmed'] = Variable<bool>(localTrimmed);
    map['channel_id'] = Variable<String>(channelId);
    return map;
  }

  HtlcsCompanion toCompanion(bool nullToAbsent) {
    return HtlcsCompanion(
      direction: Value(direction),
      id: Value(id),
      amountMsat: Value(amountMsat),
      expiry: Value(expiry),
      paymentHash: Value(paymentHash),
      state: Value(state),
      localTrimmed: Value(localTrimmed),
      channelId: Value(channelId),
    );
  }

  factory Htlc.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Htlc(
      direction: serializer.fromJson<int>(json['direction']),
      id: serializer.fromJson<int>(json['id']),
      amountMsat: serializer.fromJson<int>(json['amountMsat']),
      expiry: serializer.fromJson<int>(json['expiry']),
      paymentHash: serializer.fromJson<String>(json['paymentHash']),
      state: serializer.fromJson<String>(json['state']),
      localTrimmed: serializer.fromJson<bool>(json['localTrimmed']),
      channelId: serializer.fromJson<String>(json['channelId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'direction': serializer.toJson<int>(direction),
      'id': serializer.toJson<int>(id),
      'amountMsat': serializer.toJson<int>(amountMsat),
      'expiry': serializer.toJson<int>(expiry),
      'paymentHash': serializer.toJson<String>(paymentHash),
      'state': serializer.toJson<String>(state),
      'localTrimmed': serializer.toJson<bool>(localTrimmed),
      'channelId': serializer.toJson<String>(channelId),
    };
  }

  Htlc copyWith(
          {int? direction,
          int? id,
          int? amountMsat,
          int? expiry,
          String? paymentHash,
          String? state,
          bool? localTrimmed,
          String? channelId}) =>
      Htlc(
        direction: direction ?? this.direction,
        id: id ?? this.id,
        amountMsat: amountMsat ?? this.amountMsat,
        expiry: expiry ?? this.expiry,
        paymentHash: paymentHash ?? this.paymentHash,
        state: state ?? this.state,
        localTrimmed: localTrimmed ?? this.localTrimmed,
        channelId: channelId ?? this.channelId,
      );
  @override
  String toString() {
    return (StringBuffer('Htlc(')
          ..write('direction: $direction, ')
          ..write('id: $id, ')
          ..write('amountMsat: $amountMsat, ')
          ..write('expiry: $expiry, ')
          ..write('paymentHash: $paymentHash, ')
          ..write('state: $state, ')
          ..write('localTrimmed: $localTrimmed, ')
          ..write('channelId: $channelId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(direction, id, amountMsat, expiry,
      paymentHash, state, localTrimmed, channelId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Htlc &&
          other.direction == this.direction &&
          other.id == this.id &&
          other.amountMsat == this.amountMsat &&
          other.expiry == this.expiry &&
          other.paymentHash == this.paymentHash &&
          other.state == this.state &&
          other.localTrimmed == this.localTrimmed &&
          other.channelId == this.channelId);
}

class HtlcsCompanion extends UpdateCompanion<Htlc> {
  final Value<int> direction;
  final Value<int> id;
  final Value<int> amountMsat;
  final Value<int> expiry;
  final Value<String> paymentHash;
  final Value<String> state;
  final Value<bool> localTrimmed;
  final Value<String> channelId;
  const HtlcsCompanion({
    this.direction = const Value.absent(),
    this.id = const Value.absent(),
    this.amountMsat = const Value.absent(),
    this.expiry = const Value.absent(),
    this.paymentHash = const Value.absent(),
    this.state = const Value.absent(),
    this.localTrimmed = const Value.absent(),
    this.channelId = const Value.absent(),
  });
  HtlcsCompanion.insert({
    required int direction,
    required int id,
    required int amountMsat,
    required int expiry,
    required String paymentHash,
    required String state,
    required bool localTrimmed,
    required String channelId,
  })  : direction = Value(direction),
        id = Value(id),
        amountMsat = Value(amountMsat),
        expiry = Value(expiry),
        paymentHash = Value(paymentHash),
        state = Value(state),
        localTrimmed = Value(localTrimmed),
        channelId = Value(channelId);
  static Insertable<Htlc> custom({
    Expression<int>? direction,
    Expression<int>? id,
    Expression<int>? amountMsat,
    Expression<int>? expiry,
    Expression<String>? paymentHash,
    Expression<String>? state,
    Expression<bool>? localTrimmed,
    Expression<String>? channelId,
  }) {
    return RawValuesInsertable({
      if (direction != null) 'direction': direction,
      if (id != null) 'id': id,
      if (amountMsat != null) 'amount_msat': amountMsat,
      if (expiry != null) 'expiry': expiry,
      if (paymentHash != null) 'payment_hash': paymentHash,
      if (state != null) 'state': state,
      if (localTrimmed != null) 'local_trimmed': localTrimmed,
      if (channelId != null) 'channel_id': channelId,
    });
  }

  HtlcsCompanion copyWith(
      {Value<int>? direction,
      Value<int>? id,
      Value<int>? amountMsat,
      Value<int>? expiry,
      Value<String>? paymentHash,
      Value<String>? state,
      Value<bool>? localTrimmed,
      Value<String>? channelId}) {
    return HtlcsCompanion(
      direction: direction ?? this.direction,
      id: id ?? this.id,
      amountMsat: amountMsat ?? this.amountMsat,
      expiry: expiry ?? this.expiry,
      paymentHash: paymentHash ?? this.paymentHash,
      state: state ?? this.state,
      localTrimmed: localTrimmed ?? this.localTrimmed,
      channelId: channelId ?? this.channelId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (direction.present) {
      map['direction'] = Variable<int>(direction.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountMsat.present) {
      map['amount_msat'] = Variable<int>(amountMsat.value);
    }
    if (expiry.present) {
      map['expiry'] = Variable<int>(expiry.value);
    }
    if (paymentHash.present) {
      map['payment_hash'] = Variable<String>(paymentHash.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (localTrimmed.present) {
      map['local_trimmed'] = Variable<bool>(localTrimmed.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HtlcsCompanion(')
          ..write('direction: $direction, ')
          ..write('id: $id, ')
          ..write('amountMsat: $amountMsat, ')
          ..write('expiry: $expiry, ')
          ..write('paymentHash: $paymentHash, ')
          ..write('state: $state, ')
          ..write('localTrimmed: $localTrimmed, ')
          ..write('channelId: $channelId')
          ..write(')'))
        .toString();
  }
}

class $HtlcsTable extends Htlcs with TableInfo<$HtlcsTable, Htlc> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HtlcsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _directionMeta = const VerificationMeta('direction');
  @override
  late final GeneratedColumn<int?> direction = GeneratedColumn<int?>(
      'direction', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _amountMsatMeta = const VerificationMeta('amountMsat');
  @override
  late final GeneratedColumn<int?> amountMsat = GeneratedColumn<int?>(
      'amount_msat', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _expiryMeta = const VerificationMeta('expiry');
  @override
  late final GeneratedColumn<int?> expiry = GeneratedColumn<int?>(
      'expiry', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _paymentHashMeta =
      const VerificationMeta('paymentHash');
  @override
  late final GeneratedColumn<String?> paymentHash = GeneratedColumn<String?>(
      'payment_hash', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String?> state = GeneratedColumn<String?>(
      'state', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _localTrimmedMeta =
      const VerificationMeta('localTrimmed');
  @override
  late final GeneratedColumn<bool?> localTrimmed = GeneratedColumn<bool?>(
      'local_trimmed', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (local_trimmed IN (0, 1))');
  final VerificationMeta _channelIdMeta = const VerificationMeta('channelId');
  @override
  late final GeneratedColumn<String?> channelId = GeneratedColumn<String?>(
      'channel_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES channels (channel_id)');
  @override
  List<GeneratedColumn> get $columns => [
        direction,
        id,
        amountMsat,
        expiry,
        paymentHash,
        state,
        localTrimmed,
        channelId
      ];
  @override
  String get aliasedName => _alias ?? 'htlcs';
  @override
  String get actualTableName => 'htlcs';
  @override
  VerificationContext validateIntegrity(Insertable<Htlc> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_msat')) {
      context.handle(
          _amountMsatMeta,
          amountMsat.isAcceptableOrUnknown(
              data['amount_msat']!, _amountMsatMeta));
    } else if (isInserting) {
      context.missing(_amountMsatMeta);
    }
    if (data.containsKey('expiry')) {
      context.handle(_expiryMeta,
          expiry.isAcceptableOrUnknown(data['expiry']!, _expiryMeta));
    } else if (isInserting) {
      context.missing(_expiryMeta);
    }
    if (data.containsKey('payment_hash')) {
      context.handle(
          _paymentHashMeta,
          paymentHash.isAcceptableOrUnknown(
              data['payment_hash']!, _paymentHashMeta));
    } else if (isInserting) {
      context.missing(_paymentHashMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('local_trimmed')) {
      context.handle(
          _localTrimmedMeta,
          localTrimmed.isAcceptableOrUnknown(
              data['local_trimmed']!, _localTrimmedMeta));
    } else if (isInserting) {
      context.missing(_localTrimmedMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Htlc map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Htlc.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $HtlcsTable createAlias(String alias) {
    return $HtlcsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  Setting({required this.key, required this.value});
  factory Setting.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Setting(
      key: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}key'])!,
      value: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}value'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  SettingsCompanion copyWith({Value<String>? key, Value<String>? value}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String?> key = GeneratedColumn<String?>(
      'key', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String?> value = GeneratedColumn<String?>(
      'value', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? 'settings';
  @override
  String get actualTableName => 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Setting.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $NodeStatesTable nodeStates = $NodeStatesTable(this);
  late final $NodeAddressesTable nodeAddresses = $NodeAddressesTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $OutgoingLightningPaymentsTable outgoingLightningPayments =
      $OutgoingLightningPaymentsTable(this);
  late final $PeersTable peers = $PeersTable(this);
  late final $ChannelsTable channels = $ChannelsTable(this);
  late final $HtlcsTable htlcs = $HtlcsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final PaymentsDao paymentsDao = PaymentsDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final PeersDao peersDao = PeersDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        nodeStates,
        nodeAddresses,
        invoices,
        outgoingLightningPayments,
        peers,
        channels,
        htlcs,
        settings
      ];
}
