//
//  NetworkError.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL
    case serializationFailed
    case generic
    case couldNotDecodeData
    case httpResponseError
    case statusCodeError
    case jsonDecoder
    case unauthorized
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid url", comment: "")
        case .serializationFailed:
            return NSLocalizedString("Failed when trying to serialize body request", comment: "")
        case .generic:
            return NSLocalizedString("Unknown error", comment: "")
        case .couldNotDecodeData:
            return NSLocalizedString("Wrong format data", comment: "")
        case .httpResponseError:
            return NSLocalizedString("Couldn't get a response from server", comment: "")
        case .statusCodeError:
            return NSLocalizedString("Server error ", comment: "")
        case .jsonDecoder:
            return NSLocalizedString("JSON error", comment: "")
        case .unauthorized:
            return NSLocalizedString("Session finished", comment: "")
        }
    }
}
