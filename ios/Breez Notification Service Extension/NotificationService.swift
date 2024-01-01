import UserNotifications
import XCGLogger
import Combine
import os.log
import notify

protocol SDKBackgroundTask : EventListener {
    func onShutdown()
}

class NotificationService: UNNotificationServiceExtension {
        
    private var logger: XCGLogger = {
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
        logger.info("Notification received")
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let currentTask = self.getTaskFromNotification() {
            self.currentTask = currentTask
            DispatchQueue.main.async {
                do {
                    self.logger.info("Breez SDK is not connected, connecting....")
                    try setLogStream(logStream: SDKLogListener(logger: self.logger))
                    self.breezSDK = try connectSDK(eventListener: currentTask)
                    self.logger.info("Breez SDK connected successfully")
                } catch {
                    self.logger.info("Breez SDK connections failed \(error)")
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
                self.logger.info("creating task for payment received")
                return PaymentReceiver(logger: self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
            default:
                return nil
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        self.logger.info("serviceExtensionTimeWillExpire()")
        
        // iOS calls this function just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content,
        // otherwise the original push payload will be used.
        self.shutdown()
    }
    
    private func shutdown() -> Void {
        self.logger.info("shutting down...")
        try? self.breezSDK?.disconnect()
        self.logger.info("breez sdk disconnected")
        self.currentTask?.onShutdown()
    }
}

class PaymentReceiver : SDKBackgroundTask {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    private var logger: XCGLogger
    
    init(logger: XCGLogger, contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.logger = logger
    }
    
    func onShutdown() {
        self.displayPushNotification(title: "Receive payment failed")
    }
    
    func onEvent(e: BreezEvent) {
        switch e {
        case .invoicePaid(details: let details):
            self.logger.info("Received payment. Bolt11: \(details.bolt11)\nPayment Hash:\(details.paymentHash)")
            if details.payment != nil {
                self.displayPushNotification(title: "Received \(details.payment!.amountMsat/1000) sats")
            }
            return
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
