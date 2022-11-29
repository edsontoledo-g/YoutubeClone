//
//  PlayVideoProvider.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/11/22.
//

import Foundation

protocol PlayVideoProviderProtocol: AnyObject {
    func getVideo(_ videoId: String) async throws -> VideoResponse
    func getRelatedVideos(_ relatedVideoId: String) async throws -> VideoResponse
    func getChannel(_ channelId: String) async throws -> ChannelResponse
}

class PlayVideoProvider: PlayVideoProviderProtocol {
    func getVideo(_ videoId: String) async throws -> VideoResponse {
        let queryItems = ["id": videoId, "part": "snippet,contentDetails,status,statistics"]
        let request = Request(endpoint: .videos, queryParams: queryItems)
        
        do {
            let response = try await ServiceLayer.callService(request: request, type: VideoResponse.self)
            return response
        } catch {
            throw error
        }
    }
    
    func getRelatedVideos(_ relatedToVideoId: String) async throws -> VideoResponse {
        let queryItems = ["relatedToVideoId": relatedToVideoId, "part": "snippet", "maxResults": "50", "type": "video"]
        let request = Request(endpoint: .search, queryParams: queryItems)
        
        do {
            let response = try await ServiceLayer.callService(request: request, type: VideoResponse.self)
            return response
        } catch {
            throw error
        }
    }
    
    func getChannel(_ channelId: String) async throws -> ChannelResponse {
        let queryItems = ["id": channelId, "part": "snippet, statistics"]
        let request = Request(endpoint: .channels, queryParams: queryItems)
        
        do {
            let response = try await ServiceLayer.callService(request: request, type: ChannelResponse.self)
            return response
        } catch {
            throw error
        }
    }
}
