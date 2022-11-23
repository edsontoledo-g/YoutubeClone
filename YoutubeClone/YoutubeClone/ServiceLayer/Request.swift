//
//  Request.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import Foundation

struct Request  {
    let endpoint: Endpoint
    var queryParams: [String: String]?
    let httpMethod: HttpMethod = .GET
    var baseUrl: URLBase = .youtube
    
    func getURL() -> String {
        return baseUrl.rawValue + endpoint.rawValue
    }
    
    enum HttpMethod: String {
        case GET
        case POST
    }

    enum Endpoint: String {
        case search = "/search"
        case channels = "/channels"
        case playlists = "/playlists"
        case playlistItems = "/playlistItems"
        case videos = "/videos"
        case empty = ""
    }

    enum URLBase: String {
        case youtube = "https://youtube.googleapis.com/youtube/v3"
        case google = "https://othereweb.com/v2"
    }
}
