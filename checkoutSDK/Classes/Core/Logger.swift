//
//  Logger.swift
//  checkoutSDK
//
//  Created by Cornelius Ashley-Osuzoka on 27/05/2025.
//

import Foundation

/// A utility for logging network requests and responses in a structured format.
enum Logger {

    /// Logs the details of an outgoing URLRequest.
    static func logRequest(_ request: URLRequest) {
        // You might want to wrap this in an #if DEBUG block for production builds
        #if DEBUG
        print("--- API Request (Debug Log) ---")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("Method: \(request.httpMethod ?? "N/A")")
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let httpBody = request.httpBody {
            if let bodyString = String(data: httpBody, encoding: .utf8) {
                print("Body: \(bodyString)")
            } else {
                print("Body (unreadable): \(httpBody.count) bytes")
            }
        }
        print("-------------------------------\n")
        #endif
    }

    /// Logs the details of an incoming API response.
    static func logResponse(data: Data, response: URLResponse) {
        // You might want to wrap this in an #if DEBUG block for production builds
        #if DEBUG
        print("--- API Response (Debug Log) ---")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Response Headers: \(httpResponse.allHeaderFields)")
        } else {
            print("Response: \(response)")
        }

        if let responseString = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseString)")
        } else {
            print("Response Body (unreadable): \(data.count) bytes")
        }
        print("--------------------------------\n")
        #endif
    }

    /// Logs details of an error that occurred during an API call.
    static func logError(_ error: Error) {
        // You might want to wrap this in an #if DEBUG block for production builds
        #if DEBUG
        print("--- API Error (Debug Log) ---")
        print("Error: \(error.localizedDescription)") // User-friendly message
        print("Detailed Error: \(error)") // Full error object for debugging

        if let urlError = error as? URLError {
            print("URLError Code: \(urlError.code.rawValue)")
            print("URLError Description: \(urlError.localizedDescription)")
        }
        print("-----------------------------\n")
        #endif
    }
}
