//
//  APIError.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/05/17.
//

import Foundation

enum APIError: LocalizedError {
    case networking
    case decoding
    var errorDescription: String {
        switch self {
        case .networking:
            return "network Error occurred."
        case .decoding:
            return "data was not decoded properly."
        }
    }
}
