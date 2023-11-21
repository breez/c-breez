import Foundation
import BreezSDK
import Combine
import os.log

#if DEBUG && true
fileprivate var log = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: "BreezManager"
)
#else
fileprivate var log = Logger(OSLog.disabled)
#endif

// SDK events listener
class SDKListener: EventListener {
    func onEvent(e: BreezEvent) {
        print("received event ", e)
    }
}

class BreezManager {
    
    public static let shared = BreezManager()
    
    public var breezSDK: BlockingBreezServices?
    
    private init() {/* must use shared instance */}
    
    public func connect() throws -> BlockingBreezServices? {
        log.trace("connect()")
        
        // Create the default config
        let deviceKey = [UInt8](Data(base64Encoded: Environment.glKey) ?? Data())
        let deviceCert = [UInt8](Data(base64Encoded: Environment.glCert) ?? Data())
        let partnerCredentials = GreenlightCredentials(deviceKey: deviceKey, deviceCert: deviceCert)
        var config = defaultConfig(envType: EnvironmentType.production, apiKey: Environment.glApiKey,
                                   nodeConfig: NodeConfig.greenlight(
                                    config: GreenlightNodeConfig(partnerCredentials: partnerCredentials, inviteCode: nil)))
        
        // Construct the seed
        let mnemonic = CredentialsManager.shared.restoreMnemonic() ?? ""
        let seed = try? mnemonicToSeed(phrase: mnemonic)
        
        // Connect to the Breez SDK make it ready for use
        guard seed != nil else {
            return nil
        }
        breezSDK = try? BreezSDK.connect(config: config, seed: seed!, listener: SDKListener())
        
        return breezSDK
    }
    
    public func disconnect() throws {
        log.trace("disconnect()")
        try? breezSDK?.disconnect()
    }
    
    public func paymentByHash(hash: String) -> Payment? {
        log.trace("paymentByHash()")
        return try? breezSDK?.paymentByHash(hash: hash)
    }
}
