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
    
    var paymentListener : PaymentListener
    
    init(paymentListener: @escaping PaymentListener) {
        self.paymentListener = paymentListener
    }
    
    func onEvent(e: BreezEvent) {
        switch e {
        case .invoicePaid(details: let details):
            log.info("Received payment. Bolt11: \(details.bolt11)\nPayment Hash:\(details.paymentHash)")
            paymentListener(details.payment ?? nil)
            return
        default:
            break
        }
    }
}

typealias PaymentListener = (Payment?) -> Void

class BreezManager {
    public var breezSDK: BlockingBreezServices?
    
    private var paymentListener: PaymentListener? = nil
    
    public init() {}
    
    public func connectSDK(paymentListener: @escaping PaymentListener) throws -> BlockingBreezServices? {
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
        breezSDK = try? connect(config: config, seed: seed!, listener: SDKListener(paymentListener: paymentListener))
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
