import UserNotifications
import XCGLogger
import Combine
import os.log
import notify

struct AddressTxsConfirmedMessage: Codable {
    let address: String
}

struct LnurlInfoMessage: Codable {
    let callback_url: String
    let reply_url: String
}

struct LnurlInvoiceMessage: Codable {
    let reply_url: String
    let amount: UInt64
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
        case "address_txs_confirmed":
            guard let messageData = content.userInfo["notification_payload"] as? String else {
                contentHandler!(content)
                return nil
            }
            Self.logger.info("address_txs_confirmed data string: \(messageData)")
            let jsonData = messageData.data(using: .utf8)!
            do {
                let addressTxsConfirmedMessage: AddressTxsConfirmedMessage = try JSONDecoder().decode(AddressTxsConfirmedMessage.self, from: jsonData)
                
                Self.logger.info("creating redeem swap task, payload: \(addressTxsConfirmedMessage)")
                return RedeemSwap(message: addressTxsConfirmedMessage, logger: Self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
            } catch let e {
                Self.logger.info("Error in parsing request: \(e)")
                return nil
            }
        case "payment_received":
            Self.logger.info("creating task for payment received")
            return PaymentReceiver(logger: Self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
        case "lnurlpay_info":
            guard let messageData = content.userInfo["notification_payload"] as? String else {
                contentHandler!(content)
                return nil
            }
            Self.logger.info("lnurlpay_info data string: \(messageData)")
            let jsonData = messageData.data(using: .utf8)!
            do {
                let lnurlInfoMessage: LnurlInfoMessage = try JSONDecoder().decode(LnurlInfoMessage.self, from: jsonData)
                
                Self.logger.info("creating lnurl pay task, payload: \(lnurlInfoMessage)")
                return LnurlPayInfo(message: lnurlInfoMessage, logger: Self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
            } catch let e {
                Self.logger.info("Error in parsing request: \(e)")
                return nil
            }
        case "lnurlpay_invoice":
            guard let messageData = content.userInfo["notification_payload"] as? String else {
                contentHandler!(content)
                return nil
            }
            Self.logger.info("lnurlpay_invoice data string: \(messageData)")
            let jsonData = messageData.data(using: .utf8)!
            do {
                let lnurlInvoiceMessage: LnurlInvoiceMessage = try JSONDecoder().decode(LnurlInvoiceMessage.self, from: jsonData)
                
                Self.logger.info("creating lnurl pay task, payload: \(lnurlInvoiceMessage)")
                return LnurlPayInvoice(message: lnurlInvoiceMessage, logger: Self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
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
