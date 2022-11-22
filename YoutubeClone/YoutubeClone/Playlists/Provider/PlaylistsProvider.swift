//
//  PlaylistsProvider.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/11/22.
//

import Foundation

protocol PlaylistsProviderProtocol {
    func getPlaylists(channelId: String) async throws -> PlaylistResponse
}

class PlaylistsProvider: PlaylistsProviderProtocol {
    func getPlaylists(channelId: String) async throws -> PlaylistResponse {
        let queryParams = ["part": "snippet,contentDetails", "channelId": channelId, "maxResults": "25"]
        
        let request = Request(endpoint: .playlists, queryParams: queryParams, baseUrl: .youtube)
        
        do {
            let model = try await ServiceLayer.callService(request: request, type: PlaylistResponse.self)
            return model
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
