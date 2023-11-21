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
        
        //let info = KeyChainAccessGroupHelper.getAccessGroupInfo()
        //let accessGroup = String(format: "%@.SharedKeychain", info?.prefix ?? "")
        let accessGroup = kSecAttrAccessGroup as String
        log.trace("Accessing shared keychain access group. \(accessGroup)")
        let keychain = Keychain(service: Bundle.main.bundleIdentifier!, accessGroup: accessGroup)
        do {
            return try keychain.getString(accountMnemonic)
        } catch let error {
            log.error("Failed to restore mnemonic from keychain. Error: \(error)")
        }
        
        return nil
    }
}
