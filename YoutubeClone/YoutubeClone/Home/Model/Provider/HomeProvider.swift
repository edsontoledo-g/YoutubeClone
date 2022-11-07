//
//  HomeProvider.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import Foundation

protocol HomeProviderProtocol {
    func getVideos(searchString: String?, channelId: String?) async throws -> VideoResponse
    func getChannel(channelId: String) async throws -> ChannelResponse
    func getPlaylists(channelId: String) async throws -> PlaylistResponse
    func getPlaylistItems(playlistId: String) async throws -> PlaylistItemResponse
}

class HomeProvider: HomeProviderProtocol {
    func getVideos(searchString: String? = nil, channelId: String? = nil) async throws -> VideoResponse {
        var queryParams = ["part": "snippet", "type": "video"]
        
        if let searchString = searchString {
            queryParams["q"] = searchString
        }
        if let channelId = channelId {
            queryParams["channelId"] = channelId
        }
        
        let request = Request(endpoint: .search, queryParams: queryParams, baseUrl: .youtube)
        
        do {
            let model = try await ServiceLayer.callService(request: request, type: VideoResponse.self)
            return model
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getChannel(channelId: String) async throws -> ChannelResponse {
        let queryParams = ["part": "snippet,statistics,brandingSettings", "id": channelId]
        
        let request = Request(endpoint: .channels, queryParams: queryParams, baseUrl: .youtube)
        
        do {
            let model = try await ServiceLayer.callService(request: request, type: ChannelResponse.self)
            return model
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getPlaylists(channelId: String) async throws -> PlaylistResponse {
        let queryParams = ["part": "snippet,contentDetails", "channelId": channelId]
        
        let request = Request(endpoint: .playlists, queryParams: queryParams, baseUrl: .youtube)
        
        do {
            let model = try await ServiceLayer.callService(request: request, type: PlaylistResponse.self)
            return model
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getPlaylistItems(playlistId: String) async throws -> PlaylistItemResponse {
        let queryParams = ["part": "snippet,id,contentDetails", "playlistId": playlistId]
        
        let request = Request(endpoint: .playlistItems, queryParams: queryParams, baseUrl: .youtube)
        
        do {
            let model = try await ServiceLayer.callService(request: request, type: PlaylistItemResponse.self)
            return model
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
