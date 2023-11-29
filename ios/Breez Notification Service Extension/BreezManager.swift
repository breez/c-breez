import Foundation
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
    
    public func connectSDK() throws -> BlockingBreezServices? {
        log.trace("connectSDK()")
        
        // Create the default config
        log.trace("API_KEY: .\(Environment.glApiKey)")
        let config = defaultConfig(envType: EnvironmentType.production, apiKey: Environment.glApiKey,
                                   nodeConfig: NodeConfig.greenlight(
                                    config: GreenlightNodeConfig(partnerCredentials: nil, inviteCode: nil)))
        
        // Construct the seed
        let mnemonic = CredentialsManager.shared.restoreMnemonic() ?? ""
        log.trace("mnemonic: .\(mnemonic)")
        let seed = try? mnemonicToSeed(phrase: mnemonic)
        
        // Connect to the Breez SDK make it ready for use
        guard seed != nil else {
            return nil
        }
        log.trace("Connecting to Breez SDK")
        breezSDK = try? connect(config: config, seed: seed!, listener: SDKListener())
        log.trace("Connected to Breez SDK")
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
