import Foundation
import os.log
import KeychainAccess

#if DEBUG && true
fileprivate var log = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: "CredenetialsManager"
)
#else
fileprivate var log = Logger(OSLog.disabled)
#endif

let accountMnemonic: String = "account_mnemonic"

class CredentialsManager {
    
    public static let shared = CredentialsManager()

    private init() {/* must use shared instance */}
    
    func restoreMnemonic() -> String? {
        log.trace("restoreMnemonic")
        let keychain = Keychain(service: "flutter_secure_storage_service", accessGroup: "group.F7R2LZH3W5.com.cBreez.client")
        do {
            return try keychain.getString(accountMnemonic)
        } catch let error {
            log.error("Failed to restore mnemonic from keychain. Error: \(error)")
        }
        
        return nil
    }
}
