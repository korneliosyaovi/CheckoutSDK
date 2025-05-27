//
//  PaymentVerifier.swift
//  checkoutSDK
//
//  Created by Cornelius Ashley-Osuzoka on 27/05/2025.
//

import Foundation

public class PaymentVerifier {
    public static func handleRedirectURL(
        _ url: URL,
        secretKey: String
    ) async throws -> [String: Any] {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            throw NSError(domain: "Invalid redirect URL", code: 400, userInfo: nil)
        }

        let status = queryItems.first(where: { $0.name == "status" })?.value
        let txId = queryItems.first(where: { $0.name == "reference" })?.value

        guard status == "success", let reference = txId else {
            throw NSError(domain: "Payment not successful", code: 401, userInfo: nil)
        }

        let api = ApiClient(secretKey: secretKey)
        return try await api.verifyPayment(transactionId: reference)
    }
}
