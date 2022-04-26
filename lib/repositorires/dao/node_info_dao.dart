import 'package:drift/drift.dart';
import './db.dart';
part 'node_info_dao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [Nodes, NodeAddresses])
class NodesDao extends DatabaseAccessor<AppDatabase> with _$NodesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  NodesDao(AppDatabase db) : super(db);

  Future setNodeInfo(NodeInfo nodeInfo) async {
    return transaction(() async {
      await nodes.insertOnConflictUpdate(nodeInfo.node);
      await nodeAddresses.deleteWhere((tbl) => tbl.nodeId.equals(nodeInfo.node.nodeID));
      await batch((batch) {
        return batch.insertAll(nodeAddresses, nodeInfo.addresses);
      });
    });
  }

  Stream<NodeInfo?> watchNodeInfo() {
    return select(nodes).watch().asyncMap((nodes) async { 
      if (nodes.isEmpty) {
        return null;
      }
      var node = nodes[0];
      var q = select(nodeAddresses)..where((addr) => addr.nodeId.equals(node.nodeID));
      var addresses = await q.get();      
      return NodeInfo(
        Node(
          network: node.network,
          nodeID: node.nodeID,
          nodeAlias: node.nodeAlias,
          numPeers: node.numPeers,
          version: node.version,
          blockheight: node.blockheight
        ),
        addresses
      );
    });    
  }
}