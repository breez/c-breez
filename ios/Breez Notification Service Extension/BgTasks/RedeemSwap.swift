import UserNotifications
import XCGLogger
import Combine
import os.log
import notify
import Foundation

class RedeemSwap : SDKBackgroundTask {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    private var logger: XCGLogger
    private var message: AddressTxsConfirmedMessage
    
    init(message: AddressTxsConfirmedMessage, logger: XCGLogger, contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil) {
        self.message = message
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.logger = logger
    }
    
    func start(breezSDK: BlockingBreezServices) {
        do {
            try breezSDK.redeemSwap(message.address)
            self.logger.debug("Found swap for \(message.address)")
            self.displayPushNotification(title: "Swap Confirmed")
        } catch let e {
            self.logger.error("Failed to process swap notification: \(e)")
            self.displayPushNotification(title: "Redeem Swap Failed")
        }
    }
    
    func onShutdown() {
        self.displayPushNotification(title: "Redeem Swap Failed")
    }
    
    func onEvent(e: BreezEvent) {}
    
    public func displayPushNotification(title: String) {
        self.logger.info("displayPushNotification \(title)")
        
        guard
            let contentHandler = contentHandler,
            let bestAttemptContent = bestAttemptContent
        else {
            return
        }
        
        bestAttemptContent.title = title
        contentHandler(bestAttemptContent)
    }
}
