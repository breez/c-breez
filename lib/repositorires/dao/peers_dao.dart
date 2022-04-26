import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import './db.dart';
part 'peers_dao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [Peers, Channels])
class PeersDao extends DatabaseAccessor<AppDatabase> with _$PeersDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  PeersDao(AppDatabase db) : super(db);

  Future setPeers(List<PeerWithChannels> peersWithChannels) async {
    return transaction(() async {
      for (var peerWithChannel in peersWithChannels) {
        await peers.insertOnConflictUpdate(peerWithChannel.peer);
        await channels
            .deleteWhere((c) => c.peerId.equals(peerWithChannel.peer.peerId));
        await batch((batch) {
          return batch.insertAll(channels, peerWithChannel.channels);
        });
      }
    });
  }

  Stream<List<PeerWithChannels>> watchPeers() {
    return Rx.combineLatest2(select(peers).watch(), select(channels).watch(),
        (List<Peer> fetchedPeers, List<Channel> fetchedChannels) {
      return fetchedPeers.map((e) {
        var peersChannels =
            fetchedChannels.where((c) => c.peerId == e.peerId).toList();
        return PeerWithChannels(e, peersChannels);
      }).toList();
    });
  }
}
