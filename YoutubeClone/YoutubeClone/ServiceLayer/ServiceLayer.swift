//
//  ServiceLayer.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import UIKit
import Foundation

@MainActor
class ServiceLayer {
    static func callService<T: Decodable>(request: Request, type: T.Type) async throws -> T {
        var serviceUrl = URLComponents(string: request.getURL())
        serviceUrl?.queryItems = buildQueryItems(params: request.queryParams ?? [:])
        serviceUrl?.queryItems?.append(URLQueryItem(name: "key", value: Constants.apiKey))
        
        guard let url = serviceUrl?.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpResponseError
        }
        
        if (httpResponse.statusCode > 299) {
            throw NetworkError.statusCodeError
        }
        
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(type, from: data)
            return decodeData
        } catch {
            throw NetworkError.couldNotDecodeData
        }
    }
    
    static func buildQueryItems(params: [String:String]) -> [URLQueryItem] {
        let items = params.map{ URLQueryItem(name: $0, value: $1) }
        return items
    }
}
