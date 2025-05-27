//
//  ApiClient.swift
//  checkoutSDK
//
//  Created by Cornelius Ashley-Osuzoka on 27/05/2025.
//

import Foundation

final class ApiClient {
    private let secretKey: String
    private let baseURL = "https://api.budpay.com/api/v2"

    init(secretKey: String) {
        self.secretKey = secretKey
    }

    func verifyPayment(transactionId: String) async throws -> [String: Any] {
        guard let url = URL(string: "\(baseURL)/transaction/verify/\(transactionId)") else {
            Logger.logError(URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey: "\(baseURL)/transaction/verify/\(transactionId)"]))
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")

        // --- Log the outgoing request ---
        Logger.logRequest(request)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // --- Log the incoming response ---
            Logger.logResponse(data: data, response: response)

            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                Logger.logError(NSError(domain: "ApiClientError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response from verifyPayment"]))
                throw NSError(domain: "Invalid JSON", code: 500, userInfo: nil)
            }

            return json
        } catch {
            // --- Log any errors ---
            Logger.logError(error)
            throw error // Re-throw the error so the caller can handle it
        }
    }

    func createPayment(with config: PaymentConfig) async throws -> URL {
        guard let url = URL(string: "\(baseURL)/transaction/initialize") else {
            Logger.logError(URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey: "\(baseURL)/transaction/initialize"]))
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var body: [String: Any] = [
            "reference": config.txRef,
            "amount": config.amount,
            "currency": config.currency,
            "redirect_url": config.redirectURL,
            "email": config.email,
            "firstname": config.firstname,
            "lastname": config.lastname
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            Logger.logError(error)
            throw NSError(domain: "ApiClientError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON body for createPayment"])
        }

        // --- Log the outgoing request ---
        Logger.logRequest(request)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // --- Log the incoming response ---
            Logger.logResponse(data: data, response: response)

            guard
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let dataDict = json["data"] as? [String: Any],
                let link = dataDict["authorization_url"] as? String,
                let paymentURL = URL(string: link)
            else {
                Logger.logError(NSError(domain: "ApiClientError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid payment response structure for createPayment"]))
                throw NSError(domain: "Invalid payment response", code: 500, userInfo: nil)
            }

            return paymentURL
        } catch {
            // --- Log any errors ---
            Logger.logError(error)
            throw error // Re-throw the error so the caller can handle it
        }
    }
}
