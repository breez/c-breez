import UserNotifications
import XCGLogger
import Combine
import os.log
import notify

enum PayloadData: Codable {
    case lnurlpay_info(callback_url: String)
    case lnurlpay_invoice(amount: UInt64)
}

struct MessagePayload: Decodable {
    let template: String
    let data: PayloadData
}

protocol SDKBackgroundTask : EventListener {
    func start(breezSDK: BlockingBreezServices)
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
                    currentTask.start(breezSDK: self.breezSDK!)
                } catch {
                    Self.logger.error("Breez SDK connection failed \(error)")
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
        Self.logger.info("Notification payload: \(content.userInfo)")
        Self.logger.info("Notification type: \(notificationType)")
        switch(notificationType) {
            case "payment_received":
            Self.logger.info("creating task for payment received")
            return PaymentReceiver(logger: Self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
        case "webhook_callback_message":
            guard let callbackUrlString = content.userInfo["callback_url"] as? String else {
                contentHandler!(content)
                return nil
            }
            Self.logger.info("callback_url string: \(callbackUrlString)")
            guard let callbackUrl = URL(string: callbackUrlString) else {
                contentHandler!(content)
                return nil
            }
            Self.logger.info("callback_url: \(callbackUrl)")
            guard let payloadData = content.userInfo["message_payload"] as? String else {
                contentHandler!(content)
                return nil
            }
            Self.logger.info("message_payload: \(payloadData)")
            
            let jsonData = payloadData.data(using: .utf8)!
            do {
                let messagePayload: MessagePayload = try JSONDecoder().decode(MessagePayload.self, from: jsonData)
                
                Self.logger.info("creting lnurl pay task, payload: \(messagePayload), callbackUrl:\(callbackUrl)")
                return LnurlPay(payload: messagePayload.data, serverReplyURL: callbackUrl, logger: Self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
            } catch let e {
                Self.logger.info("Error in parsing request: \(e)")
                return nil
            }
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
