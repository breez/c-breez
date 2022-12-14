
import breez_sdk.BreezEvent

class SDKListener: breez_sdk.EventListener {
    override fun onEvent(e: BreezEvent) {
        println(e.toString());
    }
}

try {
    var seed = breez_sdk.mnemonicToSeed("cruise clever syrup coil cute execute laundry general cover prevent law sheriff");
    var credentials = breez_sdk.recoverNode(breez_sdk.Network.BITCOIN, seed, null);
    var sdk_services = breez_sdk.start(null, seed, credentials, SDKListener());
    var nodeInfo = sdk_services.nodeInfo();
    //assert(nodeInfo?.id.equals("0352a918bdba7d7a69893a7d52a449f3e6df8e15a0edcc7fe59060be70d6f416f0"));
}catch (ex: Exception) {
    throw RuntimeException("Should have not thrown!")
}