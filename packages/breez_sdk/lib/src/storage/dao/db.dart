import 'dart:io';
import 'package:breez_sdk/src/storage/storage.dart';
import 'package:breez_sdk/src/storage/dao/payments_dao.dart';
import 'package:breez_sdk/src/storage/dao/peers_dao.dart';
import 'package:breez_sdk/src/storage/dao/settings_dao.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';

enum ChannelState { PENDING_OPEN, OPEN, PENDING_CLOSED, CLOSED }

class OutgoingLightningPayments extends Table {
  IntColumn get createdAt => integer()();
  TextColumn get paymentHash => text()();
  TextColumn get destination => text().withLength(min: 66, max: 66)();
  IntColumn get feeMsat => integer()();
  IntColumn get amountMsats => integer()();
  IntColumn get amountSentMsats => integer()();
  TextColumn get preimage => text()();
  BoolColumn get isKeySend => boolean()();
  BoolColumn get pending => boolean()();
  TextColumn get bolt11 => text()();
  TextColumn get description => text()();
}

class NodeAddresses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => integer()();
  TextColumn get addr => text()();
  IntColumn get port => integer()();
  TextColumn get nodeId => text().withLength(min: 66, max: 66)();
}

class NodeStates extends Table {  
  TextColumn get nodeID => text().withLength(min: 66, max: 66)();
  IntColumn get channelsBalanceMsats => integer()();
  IntColumn get onchainBalanceMsats => integer()();  
  IntColumn get blockHeight => integer()();
  IntColumn get connectionStatus => integer()();
  IntColumn get maxAllowedToPayMsats => integer()();
  IntColumn get maxAllowedToReceiveMsats => integer()();
  IntColumn get maxPaymentAmountMsats => integer()();
  IntColumn get maxChanReserveMsats => integer()();
  TextColumn get connectedPeers => text()();
  IntColumn get maxInboundLiquidityMsats => integer()();
  IntColumn get onChainFeeRate => integer()();

  @override
  Set<Column> get primaryKey => {nodeID};
}

class Htlcs extends Table {
  IntColumn get direction => integer()();
  IntColumn get id => integer()();
  IntColumn get amountMsat => integer()();
  IntColumn get expiry => integer()();
  TextColumn get paymentHash => text()();
  TextColumn get state => text()();
  BoolColumn get localTrimmed => boolean()();
  TextColumn get channelId => text().references(Channels, #channelId)();
}

class Channels extends Table {
  IntColumn get channelState => integer()();
  TextColumn get shortChannelId => text().nullable()();
  IntColumn get direction => integer()();
  TextColumn get channelId => text()();
  TextColumn get fundingTxid => text()();
  TextColumn get closeToAddr => text()();
  TextColumn get closeTo => text()();
  BoolColumn get private => boolean()();
  IntColumn get totalMsat => integer()();
  IntColumn get dustLimitMsat => integer()();
  IntColumn get spendableMsat => integer()();
  IntColumn get receivableMsat => integer()();
  IntColumn get theirToSelfDelay => integer()();
  IntColumn get ourToSelfDelay => integer()();
  TextColumn get peerId =>
      text().withLength(min: 66, max: 66).references(Peers, #peerId)();
}

class LSPs extends Table {
  TextColumn get lspId => text()();
  TextColumn get peerId => text().withLength(min: 66, max: 66)();
  BoolColumn get connected => boolean()();
}

class PeerWithChannels {
  final Peer peer;
  final List<Channel> channels;

  PeerWithChannels(this.peer, this.channels);
}

class Peers extends Table {
  TextColumn get peerId => text().withLength(min: 66, max: 66)();
  BoolColumn get connected => boolean()();
  TextColumn get features => text()();
  @override
  Set<Column> get primaryKey => {peerId};
}

class Invoices extends Table {
  TextColumn get label => text()();
  IntColumn get amountMsat => integer()();
  IntColumn get receivedMsat => integer()();
  IntColumn get status => integer()();
  IntColumn get paymentTime => integer()();
  IntColumn get expiryTime => integer()();
  TextColumn get bolt11 => text()();
  TextColumn get paymentPreimage => text()();
  TextColumn get paymentHash => text()();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    final folder = await getApplicationDocumentsDirectory();
    final file = File(p.join(folder.path, 'breez_sdk.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [  
  NodeStates,
  NodeAddresses,
  Invoices,
  OutgoingLightningPayments,  
  Htlcs,
  Channels,
  Peers,
  Settings
], daos: [  
  PaymentsDao,
  SettingsDao,
  PeersDao,  
])
class AppDatabase extends _$AppDatabase implements Storage {
  // we tell the database where to store the data with this constructor
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.alterTable(TableMigration(peers));
          await m.alterTable(TableMigration(channels));
        }
        if (from < 3) {
          await m.alterTable(TableMigration(channels));
        }
        if (from < 4) {
          await m.alterTable(
            TableMigration(
              outgoingLightningPayments,
              columnTransformer: {
                outgoingLightningPayments.amountMsats: const CustomExpression('amount'),
                outgoingLightningPayments.amountSentMsats: const CustomExpression('amount_sent')
              },
            )
          );          
        }
        if (from < 6) {
          await m.createTable(nodeStates);
        }
        if (from < 7) {
          await m.addColumn(outgoingLightningPayments, outgoingLightningPayments.description);
        }
      },
    );
  }

  @override
  Future setNodeState(NodeState nodeState) async {
    await nodeStates.insertOnConflictUpdate(nodeState);    
  }

  @override
  Stream<NodeState?> watchNodeState() {
    return select(nodeStates).watch().map((event) => event.isEmpty ? null : event.first);    
  }

  @override
  addOutgoingPayments(List<OutgoingLightningPayment> payments) async {
    return paymentsDao.addOutgoingPayments(payments);
  }

  @override
  Stream<List<OutgoingLightningPayment>> watchOutgoingPayments() {
    return paymentsDao.watchOutgoingPayments();
  }

  @override
  Future<List<OutgoingLightningPayment>> listOutgoingPayments() {
    return paymentsDao.listOutgoingPayments();
  }

  @override
  Future addIncomingPayments(List<Invoice> settledInvoices) {
    return paymentsDao.addIncomingPayments(settledInvoices);
  }

  @override
  Stream<List<Invoice>> watchIncomingPayments() {
    return paymentsDao.watchIncomingPayments();
  }

  @override
  Future<List<Invoice>> listIncomingPayments() {
    return paymentsDao.listIncomingPayments();
  }

  @override
  Future setPeers(List<PeerWithChannels> peersWithChannels) async {
    return peersDao.setPeers(peersWithChannels);
  }

  @override
  Stream<List<PeerWithChannels>> watchPeers() {
    return peersDao.watchPeers();
  }

  @override
  Stream<Setting?> watchSetting(String key) {
    return settingsDao.watchSetting(key);
  }

  @override
  Future<int> updateSettings(String key, String value) {
    return settingsDao.updateSettings(key, value);
  }

  @override
  Future<Setting?> readSettings(String key) {
    return settingsDao.readSettings(key);
  }

  @override
  Future<List<Setting>> readAllSettings() {
    return settingsDao.readAllSettings();
  }
}
