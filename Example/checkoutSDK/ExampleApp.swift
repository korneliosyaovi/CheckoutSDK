//
//  ExampleApp.swift
//  checkoutSDK_Example
//
//  Created by Cornelius Ashley-Osuzoka on 27/05/2025.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import SwiftUI
import checkoutSDK

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    Task {
                        do {
                            let data = try await PaymentVerifier.handleRedirectURL(
                                url,
                                secretKey: "FLWSECK_TEST-592f56ef8d7384fc710559d3a15dd8d6-X"
                            )
                            print("Payment Verified: \(data)")
                            // Handle successful UI update

                        } catch {
                            print("Verification Failed: \(error.localizedDescription)")
                            // Handle error UI update
                        }
                    }
                }
        }
    }
}
