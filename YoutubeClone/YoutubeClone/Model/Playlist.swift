//
//  Playlist.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import Foundation

struct Playlist: Decodable {
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
        let etag: String
        let id: String
        let snippet: Snippet
        let contentDetails: ContentDetails
    }
    
    struct Snippet: Decodable {
        let publishedAt: String
        let channelId: String
        let title: String
        let description: String
        let thumbnails: Thumbnails
        let channelTitle: String
    }
    
    struct Thumbnails: Decodable {
        let `default`: Thumbnail
        let medim: Thumbnail
        let hight: Thumbnail
        let starndard: Thumbnail
        let maxres: Thumbnail
    }
    
    struct Thumbnail: Decodable {
        let url: String
        let width: Int
        let height: Int
    }
    
    struct ContentDetails: Decodable {
        let itemCount: Int
    }
}
