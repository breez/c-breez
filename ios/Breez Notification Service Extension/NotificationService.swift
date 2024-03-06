import UserNotifications
import XCGLogger

let accessGroup = "group.F7R2LZH3W5.com.cBreez.client"

class NotificationService: SDKNotificationService {
    fileprivate let TAG = "NotificationService"
    private let accountMnemonic: String = "account_mnemonic"
    private let accountApiKey: String = "account_api_key"
    
    private let xcgLogger: XCGLogger
    
    init() {
        let logsDir = FileManager
            .default.containerURL(forSecurityApplicationGroupIdentifier: accessGroup)!.appendingPathComponent("logs")
        let extensionLogFile = logsDir.appendingPathComponent("\(Date().timeIntervalSince1970).ios-extension.log")
        
        xcgLogger = {
            let log = XCGLogger.default
            log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: extensionLogFile.path)
            return log
            
        }()
        let serviceLogger = ServiceLogger(logStream: SdkLogListener(logger: xcgLogger))
        super.init(logger: serviceLogger)
    }
    
    override func getConnectRequest() -> ConnectRequest? {
        guard let apiKey = KeychainHelper.shared.getFlutterString(accessGroup: accessGroup, key: accountApiKey) else {
            self.logger.log(tag: TAG, line: "API key not found", level: "ERROR")
            return nil
        }
        self.logger.log(tag: TAG, line: "API_KEY: \(apiKey)", level: "TRACE")
        var config = defaultConfig(envType: EnvironmentType.production, apiKey: apiKey,
                                   nodeConfig: NodeConfig.greenlight(
                                    config: GreenlightNodeConfig(partnerCredentials: nil, inviteCode: nil)))
        config.workingDir = FileManager
            .default.containerURL(forSecurityApplicationGroupIdentifier: accessGroup)!
            .absoluteString
        
        // Construct the seed
        guard let mnemonic = KeychainHelper.shared.getFlutterString(accessGroup: accessGroup, key: accountMnemonic) else {
            self.logger.log(tag: TAG, line: "Mnemonic not found", level: "ERROR")
            return nil
        }
        guard let seed = try? mnemonicToSeed(phrase: mnemonic) else {
            self.logger.log(tag: TAG, line: "Invalid seed", level: "ERROR")
            return nil
        }
        return ConnectRequest(config: config, seed: seed)
    }
}
