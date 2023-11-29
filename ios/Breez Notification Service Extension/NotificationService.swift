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
    
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    
    private var breezSDK = BreezManager()
    
    private var breezStarted: Bool = false
    private var srvExtDone: Bool = false
    
    private var receivedPayments: [Payment] = []
    
    private var totalTimer: Timer? = nil
    private var paymentHashPollerTimer: Timer? = nil
    private var postPaymentTimer: Timer? = nil
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        let selfPtr = Unmanaged.passUnretained(self).toOpaque().debugDescription
        
        log.trace("instance => \(selfPtr)")
        log.trace("didReceive(_:withContentHandler:)")
        
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        self.startTotalTimer()
        self.startBreez()
    }
    
    override func serviceExtensionTimeWillExpire() {
        log.trace("serviceExtensionTimeWillExpire()")
        
        // iOS calls this function just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content,
        // otherwise the original push payload will be used.
        self.displayPushNotification()
    }
    
    // --------------------------------------------------
    // MARK: Timers
    // --------------------------------------------------
    
    private func startTotalTimer() {
        log.trace("startTotalTimer()")
        
        guard totalTimer == nil else {
            return
        }
        
        // The OS gives us 30 seconds to fetch data, and then invoke the completionHandler.
        // Failure to properly "clean up" in this way will result in the OS reprimanding us.
        // So we set a timer to ensure we stop before the max allowed.
        totalTimer = Timer.scheduledTimer(
            withTimeInterval : 29.5,
            repeats          : false
        ) {[weak self](_: Timer) -> Void in
            
            if let self = self {
                log.debug("totalTimer.fire()")
                self.displayPushNotification()
            }
        }
    }
    
    private func startPaymentHashPollerTimer() {
        log.trace("startPaymentHashPollerTimer()")
        
        guard paymentHashPollerTimer == nil else {
            return
        }
        
        paymentHashPollerTimer = Timer.scheduledTimer(
            withTimeInterval : 2.0,
            repeats          : true
        ) {[weak self](_: Timer) in
            
            if let self = self {
                log.debug("paymentHashPollerTimer.fire()")
                // TODO: Once SDK is connected, wait for payment to arrive on BreezManager and once it does, send the received payment to NotificationService through listeners
                if let paymentHash = bestAttemptContent?.userInfo["payment_hash"] as? String  {
                    if let payment = breezSDK.paymentByHash(hash: paymentHash) {
                        didReceivePayment(payment)
                    }
                }
            }
        }
    }
    
    private func startPostPaymentTimer() {
        log.trace("startPostPaymentTimer()")
        
        // This method is called everytime we receive a payment,
        // and it's possible we receive multiple payments.
        // So for every payment, we want to restart the timer.
        postPaymentTimer?.invalidate()
        
#if DEBUG
        let delay: TimeInterval = 5.0
#else
        let delay: TimeInterval = 5.0
#endif
        
        postPaymentTimer = Timer.scheduledTimer(
            withTimeInterval : delay,
            repeats          : false
        ) {[weak self](_: Timer) -> Void in
            
            if let self = self {
                log.debug("postPaymentTimer.fire()")
                self.displayPushNotification()
            }
        }
    }
    
    // --------------------------------------------------
    // MARK: Breez
    // --------------------------------------------------
    
    private func startBreez() {
        log.trace("startBreez()")
        
        if !breezStarted && !srvExtDone {
            breezStarted = true
            
            
            /// Ensure SDK is connected and wait for payment
            do {
                guard (try? breezSDK.connectSDK(paymentListener: {[weak self](payment: Payment?) in
                    self?.didReceivePayment(payment)
                })) != nil else {
                    throw SdkError.Generic(message: "Failed to connect to Breez SDK")
                }
                // TODO: Wait for payment
            } catch let error {
                log.error("Failed to connect to Breez SDK. Error: \(error)")
            }
        }
    }
    
    private func stopBreez() {
        log.trace("stopBreez()")
        
        if breezStarted {
            breezStarted = false
            
            do {
                try breezSDK.disconnect()
            } catch let error {
                log.error("Failed to disconnect Breez SDK. Error: \(error)")
            }
        }
    }
    
    private func didReceivePayment(_ payment: Payment?) {
        log.trace("didReceivePayment()")
        if(payment != nil){
            receivedPayments.append(payment!)
        } else {
            log.trace("payment information is not available")
        }
        if !srvExtDone {
            startPostPaymentTimer()
        }
    }
    
    // --------------------------------------------------
    // MARK: Finish
    // --------------------------------------------------
    
    private func displayPushNotification() {
        log.trace("displayPushNotification()")
        
        guard !srvExtDone else {
            return
        }
        srvExtDone = true
        
        guard
            let contentHandler = contentHandler,
            let bestAttemptContent = bestAttemptContent
        else {
            return
        }
        
        totalTimer?.invalidate()
        totalTimer = nil
        paymentHashPollerTimer?.invalidate()
        paymentHashPollerTimer = nil
        postPaymentTimer?.invalidate()
        postPaymentTimer = nil
        stopBreez()
        
        if receivedPayments.isEmpty {
            bestAttemptContent.title = NSLocalizedString("Missed incoming payment", comment: "")
        } else { // received 1 or more payments
            bestAttemptContent.fillForReceivedPayments(payments: receivedPayments)
        }
        
        contentHandler(bestAttemptContent)
    }
}
