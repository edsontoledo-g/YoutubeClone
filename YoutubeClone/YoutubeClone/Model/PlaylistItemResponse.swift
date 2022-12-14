//
//  PlaylistItemResponse.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 04/11/22.
//

import Foundation

struct PlaylistItemResponse: Decodable {
    let kind: String
    let items: [Item]
    
    struct Item: Decodable {
        let kind: String
        let id: String?
        let snippet: VideoResponse.Item.Snippet?
        let contentDetails: ContentDetails?
        
        enum CodingKeys: CodingKey {
            case kind
            case id
            case snippet
            case contentDetails
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let id = try? container.decode(ItemId.self, forKey: .id) {
                self.id = id.videoId
            } else {
                if let id = try? container.decode(String.self, forKey: .id) {
                    self.id = id
                } else {
                    self.id = nil
                }
            }

            self.kind = try container.decode(String.self, forKey: .kind)

            if let snippet = try? container.decode(VideoResponse.Item.Snippet.self, forKey: .snippet) {
                self.snippet = snippet
            } else {
                self.snippet = nil
            }
            
            if let contentDetails = try? container.decode(ContentDetails.self, forKey: .contentDetails) {
                self.contentDetails = contentDetails
            } else {
                self.contentDetails = nil
            }
        }
        
        struct ItemId: Decodable {
            let kind: String
            let videoId: String
        }
        
        struct ContentDetails: Decodable {
            let videoId: String?
        }
    }
}
