//
//  VideosProvider.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/11/22.
//

import Foundation

protocol VideosProviderProtocol {
    func getVideos(channelId: String?) async throws -> VideoResponse
}

class VideosProvider: VideosProviderProtocol {
    func getVideos(channelId: String?) async throws -> VideoResponse {
        var queryParams = ["part": "snippet", "type": "video", "maxResults": "50"]
        
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
}
