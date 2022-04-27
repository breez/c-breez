import 'dart:io';

import 'package:c_breez/repositorires/app_storage.dart';
import 'package:c_breez/repositorires/dao/funds_dao.dart';
import 'package:c_breez/repositorires/dao/node_info_dao.dart';
import 'package:c_breez/repositorires/dao/payments_dao.dart';
import 'package:c_breez/repositorires/dao/peers_dao.dart';
import 'package:c_breez/repositorires/dao/settings_dao.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'db.g.dart';

enum ChannelState { PENDING_OPEN, OPEN, PENDING_CLOSED, CLOSED }

class OutgoingLightningPayments extends Table {
  IntColumn get createdAt => integer()();
  TextColumn get paymentHash => text()();
  TextColumn get destination => text().withLength(min: 66, max: 66)();
  IntColumn get feeMsat => integer()();
  IntColumn get amount => integer()();
  IntColumn get amountSent => integer()();
  TextColumn get preimage => text()();
  BoolColumn get isKeySend => boolean()();
  BoolColumn get pending => boolean()();
  TextColumn get bolt11 => text()();
}

class NodeAddresses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => integer()();
  TextColumn get addr => text()();
  IntColumn get port => integer()();
  TextColumn get nodeId => text().withLength(min: 66, max: 66)();
}

class NodeInfo {
  final Node node;
  final List<NodeAddresse> addresses;

  NodeInfo(this.node, this.addresses);
}

class Nodes extends Table {
  TextColumn get nodeID => text().withLength(min: 66, max: 66)();
  TextColumn get nodeAlias => text()();
  IntColumn get numPeers => integer()();
  TextColumn get version => text()();
  IntColumn get blockheight => integer()();
  TextColumn get network => text()();

  @override
  Set<Column> get primaryKey => {nodeID};
}

class OnChainFunds extends Table {
  TextColumn get txid => text()();
  IntColumn get outnum => integer()();
  IntColumn get amountMsat => integer()();
  TextColumn get address => text()();
  IntColumn get outputStatus => integer()();
}

class OffChainFunds extends Table {
  TextColumn get peerId =>
      text().withLength(min: 66, max: 66).references(Nodes, #nodeID)();
  BoolColumn get connected => boolean()();
  IntColumn get shortChannelId => integer()();
  IntColumn get ourAmountMsat => integer()();
  IntColumn get amountMsat => integer()();
  TextColumn get fundingTxid => text()();
  IntColumn get fundingOutput => integer()();
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
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [
  Nodes,
  NodeAddresses,
  Invoices,
  OutgoingLightningPayments,
  OnChainFunds,
  OffChainFunds,
  Htlcs,
  Channels,
  Peers,
  Settings
], daos: [
  NodesDao,
  PaymentsDao,
  SettingsDao,
  PeersDao,
  FundsDao
])
class AppDatabase extends _$AppDatabase implements AppStorage {
  // we tell the database where to store the data with this constructor
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 3;

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
      },
    );
  }

  @override
  Future setNodeInfo(NodeInfo nodeInfo) {
    return nodesDao.setNodeInfo(nodeInfo);
  }

  @override
  Stream<NodeInfo?> watchNodeInfo() {
    return nodesDao.watchNodeInfo();
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
  Future addIncomingPayments(List<Invoice> settledInvoices) {
    return paymentsDao.addIncomingPayments(settledInvoices);
  }

  @override
  Stream<List<Invoice>> watchIncomingPayments() {
    return paymentsDao.watchIncomingPayments();
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
  Future setOffchainFunds(List<OffChainFund> offchainFundsEntries) async {
    return fundsDao.setOffchainFunds(offchainFundsEntries);
  }

  @override
  Stream<List<OffChainFund>> watchOffchainFunds() {
    return fundsDao.watchOffchainFunds();
  }

  @override
  Future setOnchainFunds(List<OnChainFund> onchainFundsEntries) async {
    return fundsDao.setOnchainFunds(onchainFundsEntries);
  }

  @override
  Stream<List<OnChainFund>> watchOnchainFunds() {
    return fundsDao.watchOnchainFunds();
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
  Future<Setting> readSettings(String key) {
    return settingsDao.readSettings(key);
  }

  @override
  Future<List<Setting>> readAllSettings() {
    return settingsDao.readAllSettings();
  }
}
