//
//  ContentView.swift
//  checkoutSDK_Example
//
//  Created by Cornelius Ashley-Osuzoka on 27/05/2025.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import SwiftUI
import checkoutSDK

struct ContentView: View {
    private let config = PaymentConfig(
        txRef: UUID().uuidString,
        amount: "1000",
        currency: "NGN",
        redirectURL: "https://google.com",
        email: "lionel.ronaldo@examplepay.com",
        firstname: "Lionel",
        lastname: "Ronaldo"
    )

    private let secretKey = "sk_test_lkowqtejidzytubleji1kjpdnmo2d1c0vmaszcc"

    @StateObject private var paymentHandler: PaymentHandler

    init() {
        let handler = PaymentHandler(config: config, secretKey: secretKey)
        _paymentHandler = StateObject(wrappedValue: handler)
    }

    var body: some View {
        VStack(spacing: 40) {
            Text("Demo Payment")
                .font(.title2)
                .fontWeight(.semibold)

            PaymentButton(
                title: "Pay ₦\(config.amount) Now.",
                config: config,
                secretKey: secretKey,
                onError: { error in
                    print("Default button error: \(error.localizedDescription)")
                }
            )
            .padding()

            Button(action: {
                paymentHandler.startPayment { error in
                    print("Custom button error: \(error.localizedDescription)")
                }
            }) {
                if paymentHandler.isLoading {
                    ProgressView()
                } else {
                    Text("Pay ₦\(config.amount) With Custom Button")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(5)
                }
            }
            .padding()
            .disabled(paymentHandler.isLoading)
        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
