//
//  HomeProviderMock.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 07/11/22.
//

import Foundation

class HomeProviderMock: HomeProviderProtocol {
    func getVideos(searchString: String?, channelId: String?) async throws -> VideoResponse {
        Utils.decodeJSON(VideoResponse.self, filename: "Videos.json")
    }
    
    func getChannel(channelId: String) async throws -> ChannelResponse {
        Utils.decodeJSON(ChannelResponse.self, filename: "Channel.json")
    }
    
    func getPlaylists(channelId: String) async throws -> PlaylistResponse {
        Utils.decodeJSON(PlaylistResponse.self, filename: "Playlists.json")
    }
    
    func getPlaylistItems(playlistId: String) async throws -> PlaylistItemResponse {
        Utils.decodeJSON(PlaylistItemResponse.self, filename: "PlaylistItems.json")
    }
}
