//
//  Playlist.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import Foundation

struct PlaylistResponse: Decodable {
    let kind: String
    let etag: String
    let pageInfo: PageInfo
    let items: [Item]
    
    struct PageInfo: Decodable {
        let totalResults: Int
        let resultsPerPage: Int
    }
    
    struct Item: Decodable {
        let kind: String
        let id: String?
        let snippet: Snippet?
        let contentDetails: ContentDetails?
        
        enum CodingKeys: String, CodingKey {
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
            
            if let snippet = try? container.decode(Snippet.self, forKey: .snippet) {
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
        
        struct Snippet: Decodable {
            let publishedAt: String
            let channelId: String
            let title: String
            let description: String
            let thumbnails: Thumbnails
            let channelTitle: String
            
            struct Thumbnails: Decodable {
                let `default`: Thumbnail
                let medium: Thumbnail
                let high: Thumbnail
                let standard: Thumbnail
                let maxres: Thumbnail
                
                struct Thumbnail: Decodable {
                    let url: String
                    let width: Int
                    let height: Int
                }
            }
        }
        
        struct ContentDetails: Decodable {
            let itemCount: Int
        }
    }
}
