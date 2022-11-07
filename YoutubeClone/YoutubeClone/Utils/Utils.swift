//
//  Utils.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 07/11/22.
//

import Foundation

class Utils {
    static func decodeJSON<T: Decodable>(_ type: T.Type, filename: String) -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Couldn't load data from bundle")
        }
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(type, from: data) else {
            fatalError("Couldn't decode data")
        }
        
        return decodedData
    }
}
