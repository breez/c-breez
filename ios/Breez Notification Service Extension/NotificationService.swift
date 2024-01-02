import UserNotifications
import XCGLogger
import Combine
import os.log
import notify

protocol SDKBackgroundTask : EventListener {
    func onShutdown()
}

class NotificationService: UNNotificationServiceExtension {
        
    static var logger: XCGLogger = {
        let logsDir = FileManager
            .default.containerURL(forSecurityApplicationGroupIdentifier: "group.F7R2LZH3W5.com.cBreez.client")!.appendingPathComponent("logs")
        let extensionLogFile = logsDir.appendingPathComponent("\(Date().timeIntervalSince1970).ios-extension.log")
        let log = XCGLogger.default
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: extensionLogFile.path)
        return log
    }()
    
    private var breezSDK: BlockingBreezServices? = nil
    
    private var contentHandler: ((UNNotificationContent) -> Void)? = nil
    private var bestAttemptContent: UNMutableNotificationContent? = nil
    private var currentTask: SDKBackgroundTask? = nil
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        Self.logger.info("Notification received")
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let currentTask = self.getTaskFromNotification() {
            self.currentTask = currentTask
            
            DispatchQueue.main.async {
                do {
                    Self.logger.info("Breez SDK is not connected, connecting....")
                    self.breezSDK = try BreezManager.register(listener: currentTask)
                    Self.logger.info("Breez SDK connected successfully")
                } catch {
                    Self.logger.info("Breez SDK connections failed \(error)")
                    self.shutdown()
                }
            }
        }
    }
    
    func getTaskFromNotification() -> SDKBackgroundTask? {
        guard let content = bestAttemptContent else {
            return nil
        }
        guard let notificationType = content.userInfo["notification_type"] as? String else {
            return nil
        }
        switch(notificationType) {
            case "payment_received":
            Self.logger.info("creating task for payment received")
                return PaymentReceiver(logger: Self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
            default:
                return nil
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        Self.logger.info("serviceExtensionTimeWillExpire()")
        
        // iOS calls this function just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content,
        // otherwise the original push payload will be used.
        self.shutdown()
    }
    
    private func shutdown() -> Void {
        Self.logger.info("shutting down...")
        BreezManager.unregister()
        Self.logger.info("task unregistered")
        self.currentTask?.onShutdown()
    }
}

class PaymentReceiver : SDKBackgroundTask {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    private var logger: XCGLogger
    private var receivedPayment: Payment? = nil
    
    init(logger: XCGLogger, contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.logger = logger
    }
    
    func onShutdown() {
        let title = self.receivedPayment != nil ? "Received \(self.receivedPayment!.amountMsat/1000) sats" :  "Receive payment failed"
        self.displayPushNotification(title: title)
    }
    
    func onEvent(e: BreezEvent) {
        switch e {
        case .invoicePaid(details: let details):
            self.logger.info("Received payment. Bolt11: \(details.bolt11)\nPayment Hash:\(details.paymentHash)")
            receivedPayment = details.payment
            break
        case .synced:
            self.logger.info("got synced event")
            if let p =  self.receivedPayment {
                self.onShutdown()
            }
            break
        default:
            break
        }
    }
    
    
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

class SDKLogListener : LogStream {
    private var logger: XCGLogger
    
    init(logger: XCGLogger) {
        self.logger = logger
    }
    
    func log(l: LogEntry) {
        if l.level != "TRACE" {            
            logger.debug("greenlight: [\(l.level)] \(l.line)")
        }
    }
}
