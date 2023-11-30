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
            paymentListener(details.paymentHash)
            return
        default:
            break
        }
    }
}

func connectSDK(paymentListener: @escaping PaymentListener) throws -> BlockingBreezServices? {
    log.trace("connectSDK()")
    
    // Create the default config
    let apiKey = try Environment.glApiKey()
    log.trace("API_KEY: .\(apiKey)")
    let config = defaultConfig(envType: EnvironmentType.production, apiKey: apiKey,
                               nodeConfig: NodeConfig.greenlight(
                                config: GreenlightNodeConfig(partnerCredentials: nil, inviteCode: nil)))
    // Construct the seed
    let mnemonic = CredentialsManager.shared.restoreMnemonic() ?? ""
    log.trace("mnemonic: .\(mnemonic)")
    let seed = try? mnemonicToSeed(phrase: mnemonic)
    // Connect to the Breez SDK make it ready for use
    guard seed != nil else {
        throw SdkError.Generic(message: "seed not found")
    }
    log.trace("Connecting to Breez SDK")
    let breezSDK = try? connect(config: config, seed: seed!, listener: SDKListener(paymentListener: paymentListener))
    log.trace("Connected to Breez SDK")
    return breezSDK
}

typealias PaymentListener = (String) -> Void
