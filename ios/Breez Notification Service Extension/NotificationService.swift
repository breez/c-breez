import UserNotifications
import XCGLogger

let accessGroup = "group.F7R2LZH3W5.com.cBreez.client"

class NotificationService: SDKNotificationService {
    private let accountMnemonic: String = "account_mnemonic"
    private let accountApiKey: String = "account_api_key"
    
    override init() {
        let logsDir = FileManager
            .default.containerURL(forSecurityApplicationGroupIdentifier: accessGroup)!.appendingPathComponent("logs")
        let extensionLogFile = logsDir.appendingPathComponent("\(Date().timeIntervalSince1970).ios-extension.log")
        
        super.init()
        self.logger.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: extensionLogFile.path)
    }
    
    override func getConnectRequest() -> ConnectRequest? {
        guard let apiKey = KeychainHelper.shared.getFlutterString(accessGroup: accessGroup, key: accountApiKey) else {
            logger.error("API key not found")
            return nil
        }
        logger.verbose("API_KEY: \(apiKey)")
        var config = defaultConfig(envType: EnvironmentType.production, apiKey: apiKey,
                                   nodeConfig: NodeConfig.greenlight(
                                    config: GreenlightNodeConfig(partnerCredentials: nil, inviteCode: nil)))
        config.workingDir = FileManager
            .default.containerURL(forSecurityApplicationGroupIdentifier: accessGroup)!
            .absoluteString
        
        // Construct the seed
        guard let mnemonic = KeychainHelper.shared.getFlutterString(accessGroup: accessGroup, key: accountMnemonic) else {
            logger.error("Mnemonic not found")
            return nil
        }
        guard let seed = try? mnemonicToSeed(phrase: mnemonic) else {
            logger.error("Invalid seed")
            return nil
        }
        return ConnectRequest(config: config, seed: seed)
    }
}
