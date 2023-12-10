import UserNotifications
import XCGLogger
import Combine
import os.log
import notify

#if DEBUG && true
fileprivate var log = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: "NotificationService"
)
#else
fileprivate var log = Logger(OSLog.disabled)
#endif

class NotificationService: UNNotificationServiceExtension {
        
    private var logger: XCGLogger = {
        let logsDir = FileManager
            .default.containerURL(forSecurityApplicationGroupIdentifier: "group.F7R2LZH3W5.com.cBreez.client")!.appendingPathComponent("logs")
        let extensionLogFile = logsDir.appendingPathComponent("extension.log")
        let log = XCGLogger.default
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: extensionLogFile.path)
        return log
    }()
    
    private var breezSDK: BlockingBreezServices?
    private var paymentReceivers: [PaymentReceiver] = []
    private var paymentHashPollerTimer: Timer?
    
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        logger.info("Notification received")
        guard let bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent else {
            return
        }
        guard let paymentHash = bestAttemptContent.userInfo["payment_hash"] as? String else {
            contentHandler(bestAttemptContent)
            return
        }
        
        let paymentReciever = PaymentReceiver(logger: self.logger, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent, paymentHash: paymentHash)
        
        DispatchQueue.main.async {
            self.paymentReceivers.append(paymentReciever)
            if self.breezSDK == nil {
                do {
                    self.logger.info("Breez SDK is not connected, connecting....")
                    try setLogStream(logStream: SDKLogListener(logger: self.logger))
                    self.breezSDK = try connectSDK(paymentListener: {[weak self](payment: Payment) in
                        DispatchQueue.main.async {
                            self?.onPaymentReceived(payment: payment)
                        }
                    })
                    self.logger.info("Breez SDK connected successfully")
                } catch {
                    self.logger.info("Breez SDK connections failed \(error)")
                    self.shutdown()
                }
            }
            self.startPaymentHashPollerTimer()
        }
    }
    
    private func startPaymentHashPollerTimer() {
        self.logger.info("startPaymentHashPollerTimer()")

        paymentHashPollerTimer = Timer.scheduledTimer(
            withTimeInterval : 1.0,
            repeats          : true
        ) {[weak self](_: Timer) in

            if let self = self {
                self.logger.info("paymentHashPollerTimer.fire()")
                for r in self.paymentReceivers {
                    if let payment = try? self.breezSDK!.paymentByHash(hash: r.paymentHash) {
                        if payment.status == PaymentStatus.complete {
                            self.onPaymentReceived(payment: payment)
                        }
                    }
                }
            }
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
        self.logger.info("shutding down with \(self.paymentReceivers.count) tasks")
        for r in self.paymentReceivers {
            r.displayPushNotification(title: "Receive payment failed")
        }
        self.paymentReceivers = []
        self.paymentHashPollerTimer?.invalidate()
    }
    
    private func onPaymentReceived(payment: Payment) -> Void {
        self.logger.info("onPaymentReceived for \(payment.amountMsat) sats")
        guard case .ln(let data) = payment.details else {
            return
        }
        for r in self.paymentReceivers {
            if r.paymentHash == data.paymentHash {
                r.displayPushNotification(title: "Received \(payment.amountMsat/1000) sats")
            }
        }
        self.paymentReceivers.removeAll(where: {$0.paymentHash == data.paymentHash})
    }
}

class PaymentReceiver {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    private var logger: XCGLogger
    public var paymentHash: String
    
    init(logger: XCGLogger, contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil, paymentHash: String) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.paymentHash = paymentHash
        self.logger = logger
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
