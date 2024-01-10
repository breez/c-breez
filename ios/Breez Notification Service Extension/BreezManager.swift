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

class BreezManager {
    private static var breezSDK: BlockingBreezServices? = nil
    fileprivate static var queue = DispatchQueue(label: "BreezManager")
    fileprivate static var sdkListener: EventListener? = nil
    
    static func register(listener: EventListener) throws -> BlockingBreezServices? {
        try BreezManager.queue.sync { [] in
            BreezManager.sdkListener = listener
            if BreezManager.breezSDK == nil {
                BreezManager.breezSDK = try BreezManager.connectSDK()
            }
            return BreezManager.breezSDK
        }
    }
    
    static func unregister() {
        BreezManager.queue.sync { [] in
            BreezManager.sdkListener = nil            
        }
    }
    
    static func connectSDK() throws -> BlockingBreezServices? {
        log.trace("connectSDK()")
        try setLogStream(logStream: SDKLogListener(logger: NotificationService.logger))
        
        // Create the default config
        guard let apiKey = CredentialsManager.shared.restoreApiKey() else {
            throw SdkError.Generic(message: "api key not found")
        }
        log.trace("API_KEY: .\(apiKey)")
        var config = defaultConfig(envType: EnvironmentType.production, apiKey: apiKey,
                                   nodeConfig: NodeConfig.greenlight(
                                    config: GreenlightNodeConfig(partnerCredentials: nil, inviteCode: nil)))
        
        config.workingDir = FileManager
            .default.containerURL(forSecurityApplicationGroupIdentifier: "group.F7R2LZH3W5.com.cBreez.client")!
            .absoluteString
        
        // Construct the seed
        guard let mnemonic = CredentialsManager.shared.restoreMnemonic() else {
            throw SdkError.Generic(message: "mnemonic not found")
        }        
        guard let seed = try? mnemonicToSeed(phrase: mnemonic) else {
            throw SdkError.Generic(message: "seed not found")
        }
        // Connect to the Breez SDK make it ready for use
        log.trace("Connecting to Breez SDK")
        let breezSDK = try connect(config: config, seed: seed, listener: BreezManagerListener())
        log.trace("Connected to Breez SDK")
        return breezSDK
    }
}

class BreezManagerListener: EventListener {
    
    func onEvent(e: BreezEvent) {
        BreezManager.queue.async { [] in
            BreezManager.sdkListener?.onEvent(e: e)
        }
    }
    
    
}
