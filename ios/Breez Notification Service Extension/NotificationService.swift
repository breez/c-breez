import UserNotifications
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
    
    private var breezSDK: BlockingBreezServices?
    private var paymentReceivers: [PaymentReceiver] = []

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        guard let bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent else {
            return
        }
        guard let paymentHash = bestAttemptContent.userInfo["payment_hash"] as? String else {
            contentHandler(bestAttemptContent)
            return
        }
        let paymentReciever = PaymentReceiver(contentHandler: contentHandler, bestAttemptContent: bestAttemptContent, paymentHash: paymentHash)
        
        DispatchQueue.main.async {
            self.paymentReceivers.append(paymentReciever)
            if self.breezSDK == nil {
                do {
                    self.breezSDK = try connectSDK(paymentListener: {[weak self](paymentHash: String) in
                        DispatchQueue.main.async {
                            self?.onPaymentReceived(paymentHash: paymentHash)
                        }
                    })                    
                } catch {
                    self.onPaymentsMissed()
                }
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        log.trace("serviceExtensionTimeWillExpire()")
        
        // iOS calls this function just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content,
        // otherwise the original push payload will be used.
        self.onPaymentsMissed()
    }
    
    private func onPaymentsMissed() -> Void {
        for r in self.paymentReceivers {
            r.displayPushNotification(title: "Missed payment")
        }
        self.paymentReceivers = []
    }
    
    private func onPaymentReceived(paymentHash: String) -> Void {
        for r in self.paymentReceivers {
            if r.paymentHash == paymentHash {
                r.displayPushNotification(title: "Received payment")
            }
        }
        self.paymentReceivers.removeAll(where: {$0.paymentHash == paymentHash})
    }
}

class PaymentReceiver {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    public var paymentHash: String
    
    init(contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil, paymentHash: String) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.paymentHash = paymentHash
    }
    
    public func displayPushNotification(title: String) {
        log.trace("displayPushNotification()")
        
        
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
