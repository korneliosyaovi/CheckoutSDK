//
//  PaymentButton.swift
//  checkoutSDK
//
//  Created by Cornelius Ashley-Osuzoka on 27/05/2025.
//

import SwiftUI
import UIKit


public struct PaymentButton: View {
    @ObservedObject private var handler: PaymentHandler
    let title: String
    let onError: ((Error) -> Void)?

    public init(
        title: String = "Pay Now",
        config: PaymentConfig,
        secretKey: String,
        onError: ((Error) -> Void)? = nil
    ) {
        self.handler = PaymentHandler(config: config, secretKey: secretKey)
        self.title = title
        self.onError = onError
    }

    public var body: some View {
        Button(action: {
            handler.startPayment(onError: onError)
        }) {
            if handler.isLoading {
                if #available(iOS 14.0, *) {
                    ProgressView()
                } else {
                    Text("Loading...")
                        .padding()
                }
            } else {
                Text(title)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
}


struct PaymentButton_Previews: PreviewProvider {
    static var previews: some View {
        PaymentButton(
            config: PaymentConfig(
                txRef: "demoPayment12",
                amount: "100",
                currency: "NGN",
                redirectURL: "https://google.com",
                email: "fred@examplepay.com",
                firstname: "Fredrick",
                lastname: "Ise"
            ),
            secretKey: "111111"
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

