//
//  ChannelResponse.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 04/11/22.
//

import Foundation

struct ChannelResponse: Decodable {
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
        let statistics: Statistics?
        let brandingSettings : BrandingSettings?
        
        enum CodingKeys: String, CodingKey {
            case kind
            case id
            case snippet
            case statistics
            case brandingSettings
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

            if let statistics = try? container.decode(Statistics.self, forKey: .statistics) {
                self.statistics = statistics
            } else {
                self.statistics = nil
            }
            
            if let brandingSettings = try? container.decode(BrandingSettings.self, forKey: .brandingSettings) {
                self.brandingSettings = brandingSettings
            } else {
                self.brandingSettings = nil
            }
        }
        
        struct ItemId: Decodable {
            let kind: String
            let videoId: String
        }
        
        struct Snippet: Decodable {
            let title: String
            let description: String
            let thumbnails: Thumbnails
            
            struct Thumbnails: Decodable {
                let `default`: Thumbnail
                let medium: Thumbnail
                let high: Thumbnail
            }
            
            struct Thumbnail: Decodable {
                let url: String
                let width: Int
                let height: Int
            }
        }
        
        struct Statistics: Decodable {
            let viewCount: String
            let subscriberCount: String
            let videoCount: String
        }
        
        struct BrandingSettings: Codable {
            let image: Image
            
            struct Image: Codable {
                let bannerExternalUrl: String
            }
        }
        
    }
}
