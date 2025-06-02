# BudPay

[![Version](https://img.shields.io/cocoapods/v/checkoutSDK.svg?style=flat)](https://cocoapods.org/pods/checkoutSDK)
[![License](https://img.shields.io/cocoapods/l/checkoutSDK.svg?style=flat)](https://cocoapods.org/pods/checkoutSDK)
[![Platform](https://img.shields.io/cocoapods/p/checkoutSDK.svg?style=flat)](https://cocoapods.org/pods/checkoutSDK)

A lightweight Swift SDK for integrating BudPay Payment Checkout into your iOS apps. Includes native SwiftUI support and async payment handling.

## Requirements
To use this library, you need the following:
- iOS version 15.0 or later
- Swift version 5.0 or later
- Xcode version 13.0 or later
- CocoaPods for dependency management


## Installation

checkoutSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BudPay'
```

## Configuration 
The checkout generated in this library supports the following parameters for configuration:
```
let config = PaymentConfig(
    reference: "REF-45678",
    amount: "5000",
    currency: "NGN", // or "USD", "KES", etc.
    redirectURL: "myapp://payment-redirect", // This should be your app's universal link
    firstname: "Lionel",
    lastname: "Ronaldo"
)
```

| Parameter        | Required | Description                                                   |
| ---------------- | -------- | ------------------------------------------------------------- |
| `reference`      | ✅        | Unique transaction reference                                  |
| `amount`         | ✅        | Amount to charge                                              |
| `currency`       | ✅        | The Currency code e.g. NGN, USD, etc.                         |
| `redirectURL`    | ✅        | Specify the URL to redirect customers to after payment        |
| `firstname`      | ❌        | The Customer's first name.                                    |
| `lastname`       | ❌        | The Customer's last name.                                     |

Read more about the supported configuration options for our payment checkout [here](https://devs.budpay.com/standard-checkout).



## Using our Payment Checkout 

### Option 1 - Use the prebuilt Payment Button

This button opens BudPay's hosted payment page and handles loading state and redirection internally.

```
import SwiftUI
import checkoutSDK

struct ContentView: View {
    private let config = PaymentConfig(
        txRef: UUID().uuidString,
        amount: "1000",
        currency: "NGN",
        redirectURL: "myapp://payment-redirect", // This should be your app's universal link
        firstname: "Lionel",
        lastname: "Ronaldo"
    )

    private let secretKey = "sk_test-XXXXXXXXXXXXXXX" //Your BudPay Secret Key

    var body: some View {
        VStack(spacing: 40) {
            PaymentButton(
                title: "Pay ₦\(config.amount)",
                config: config,
                secretKey: secretKey,
                onError: { error in
                    print("Payment error: \(error.localizedDescription)")
                }
            )
            .padding()
        }
        .padding()
    }
}
```

### Option 2 - Customizing your payment Button with the PaymentHandler

Use this if you want full control of your UI:

```
import SwiftUI
import checkoutSDK

struct ContentView: View {
    private let config = PaymentConfig(
        txRef: UUID().uuidString,
        amount: "1000",
        currency: "NGN",
        redirectURL: "myapp://payment-redirect", // This should be your app's universal link
        firstname: "Lionel",
        lastname: "Ronaldo"
    )

    private let secretKey = "sk_test-XXXXXXXXXXXXXXX" //Your BudPay Secret Key

    @StateObject private var paymentHandler: PaymentHandler

    init() {
        let handler = PaymentHandler(config: config, secretKey: secretKey)
        _paymentHandler = StateObject(wrappedValue: handler)
    }

    var body: some View {
        VStack(spacing: 40) {
            Button(action: {
                paymentHandler.startPayment { error in
                    print("Payment error: \(error.localizedDescription)")
                }
            }) {
                if paymentHandler.isLoading {
                    ProgressView()
                } else {
                    Text("Pay ₦\(config.amount)")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(12)
                }
            }
            .padding()
            .disabled(paymentHandler.isLoading)
        }
        .padding()
    }
}
```

### Handling Redirect and Verifying Payment

BudPay redirects your users to the specified redirectURL after payment. Use **PaymentVerifier** to confirm the status of the transaction:

```
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
                                secretKey: "sk_test-XXXXXXXXXXXXXXX" //Your BudPay Secret Key
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
```

## Handling Redirect and Verifying Payment
To securely handle payment redirects, you should implement [Universal Links](https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content)  in your iOS app.

1. In your Xcode target → Signing & Capabilities:
    - Add Associated Domains
    - Add: applinks:yourdomain.com

2. Host an apple-app-site-association (AASA) JSON file at:
```
https://yourdomain.com/.well-known/apple-app-site-association
```
3. The file should look like:
```
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "<TEAMID>.<BUNDLEID>",
        "paths": [ "/payment-redirect" ]
      }
    ]
  }
}
```
4. Your redirectURL in the payment config should match the format:
```
https://yourdomain.com/payment-redirect
```


## Example

To run the example project, clone the repo, update the secret key and run `pod install` from the Example directory first.

After successfully completing the pod installation, build the `ContentView` file and run this file in the App Simulator.


## License

This Checkout SDK is open-source and available under the MIT License.
