//
//  PaymentConfig.swift
//  checkoutSDK
//
//  Created by Cornelius Ashley-Osuzoka on 27/05/2025.
//

import Foundation

public struct PaymentConfig {
    public let txRef: String
    public let amount: String
    public let currency: String?
    public let redirectURL: String
    public let email: String
    public let firstname: String?
    public let lastname: String?

    
    public init(
        txRef: String,
        amount: String,
        currency: String = "NGN",
        redirectURL: String,
        email: String,
        firstname: String,
        lastname: String
    ) {
        self.txRef = txRef
        self.amount = amount
        self.currency = currency
        self.redirectURL = redirectURL
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
    }
}
