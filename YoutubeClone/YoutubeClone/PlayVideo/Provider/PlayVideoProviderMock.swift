//
//  PlayVideoProviderMock.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/11/22.
//

import Foundation

class PlayVideoProviderMock: PlayVideoProviderProtocol {
    var shouldFail = false
    
    func getVideo(_ videoId: String) async throws -> VideoResponse {
        if shouldFail {
            throw NetworkError.generic
        }
        
        return Utils.decodeJSON(VideoResponse.self, filename: "VideoOnlyOne.json")
    }
    
    func getRelatedVideos(_ relatedVideoId: String) async throws -> VideoResponse {
        Utils.decodeJSON(VideoResponse.self, filename: "Videos.json")
    }
    
    func getChannel(_ channelId: String) async throws -> ChannelResponse {
        Utils.decodeJSON(ChannelResponse.self, filename: "Channel.json")
    }
    
    
}
