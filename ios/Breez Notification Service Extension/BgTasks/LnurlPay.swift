//
//  LnurlPay.swift
//  Breez Notification Service Extension
//
//  Created by Roei Erez on 03/01/2024.
//

import UserNotifications
import XCGLogger
import Combine
import os.log
import notify
import Foundation

struct LnurlInfo: Decodable, Encodable {
    let callback: String
    let maxSendable: UInt64
    let minSendable: UInt64
    let metadata: String
    let tag: String
    
    init(callback: String, maxSendable: UInt64, minSendable: UInt64, metadata: String, tag: String) {
        self.callback = callback
        self.maxSendable = maxSendable
        self.minSendable = minSendable
        self.metadata = metadata
        self.tag = tag
    }
}

struct LnurlInvoiceResponse: Decodable, Encodable {
    let pr: String
    let routes: [String]
    
    init(pr: String, routes: [String]) {
        self.pr = pr
        self.routes = routes
    }
}

struct LnurlErrorResponse: Decodable, Encodable {
    let status: String
    let reason: String
    
    init(status: String, reason: String) {
        self.status = status
        self.reason = reason
    }
}

class LnurlPay : SDKBackgroundTask {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    private var logger: XCGLogger
    private var payload: PayloadData
    private var serverReplyURL: URL
    
    init(payload: PayloadData, serverReplyURL: URL, logger: XCGLogger, contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.logger = logger
        self.payload = payload
        self.serverReplyURL = serverReplyURL
    }
    
    func start(breezSDK: BlockingBreezServices){
        do {
            let metadata = "[[\"text/plain\",\"Pay to Breez\"]]"
            switch self.payload {
            case let .lnurlpay_info(callbackURL):
                let nodeInfo = try breezSDK.nodeInfo()
                self.replyServer(encodable: LnurlInfo(callback: callbackURL, maxSendable: nodeInfo.inboundLiquidityMsats, minSendable: UInt64(1000), metadata: metadata, tag: "payRequest"), successMessage: "Lnurl Information Requested")
            case let .lnurlpay_invoice(amount):
                let receiveResponse = try breezSDK.receivePayment(req: ReceivePaymentRequest(amountMsat: amount, description: metadata, useDescriptionHash: true))
                self.replyServer(encodable: LnurlInvoiceResponse(pr: receiveResponse.lnInvoice.bolt11, routes: []), successMessage: "Lnurl Invoice Requested")
            }
        } catch let e {
            self.logger.error("failed to process lnurl: \(e)")
            self.fail(withError: e.localizedDescription, andTitle: "Lnurl processing failed")
        }
    }
    
    func replyServer(encodable: Encodable, successMessage: String) {
        var request = URLRequest(url: self.serverReplyURL)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(encodable)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode

            if statusCode == 200 {
                self.displayPushNotification(title: successMessage)
            } else {
                self.displayPushNotification(title: "Lnurl processing failed")                
                return
            }
        }
        task.resume()
    }
    
    func fail(withError: String, andTitle: String) {
        var request = URLRequest(url: serverReplyURL)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(LnurlErrorResponse(status: "ERROR", reason: withError))
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let _ = (response as! HTTPURLResponse).statusCode
        }
        task.resume()
        self.displayPushNotification(title: andTitle)
    }
    
    func onShutdown() {
        displayPushNotification(title: "Lnurl processing failed")
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
