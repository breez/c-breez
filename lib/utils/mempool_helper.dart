import 'package:c_breez/config.dart';
import 'package:c_breez/services/injector.dart';

class MempoolHelper {
  String formatTransactionUrl({required String txid, required String blockexplorer}) {
    return "$blockexplorer/tx/$txid";
  }

  Future<String> get blockexplorer async {
    String? blockexplorer = await ServiceInjector().preferences.getMempoolSpaceUrl();
    if (blockexplorer == null) {
      final config = await Config.instance();
      blockexplorer = config.defaultMempoolUrl;
    }
    return blockexplorer;
  }
}
