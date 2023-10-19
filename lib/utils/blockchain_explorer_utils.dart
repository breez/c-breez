class BlockChainExplorerUtils {
  String formatTransactionUrl({required String txid, required String mempoolInstance}) {
    return "$mempoolInstance/tx/$txid";
  }

  String formatRecommendedFeesUrl({required String mempoolInstance}) {
    return "$mempoolInstance/api/v1/fees/recommended";
  }
}
