//
//  PaymentHandler.swift
//  checkoutSDK
//
//  Created by Cornelius Ashley-Osuzoka on 27/05/2025.
//

import Foundation
import UIKit

@MainActor
public final class PaymentHandler: ObservableObject {
    @Published public var isLoading: Bool = false

    private let config: PaymentConfig
    private let secretKey: String

    public init(config: PaymentConfig, secretKey: String) {
        self.config = config
        self.secretKey = secretKey
    }

    public func startPayment(onError: ((Error) -> Void)? = nil) {
        isLoading = true
        let api = ApiClient(secretKey: secretKey)

        let localConfig = config

        Task { [weak self] in
            do {
                let url = try await api.createPayment(with: localConfig)

                guard let self = self else { return }

                self.isLoading = false

                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let error = NSError(domain: "PaymentButton", code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Cannot open URL"])
                    onError?(error)
                }

            } catch {
                guard let self = self else { return }
                self.isLoading = false
                onError?(error)
            }
        }
    }
}

