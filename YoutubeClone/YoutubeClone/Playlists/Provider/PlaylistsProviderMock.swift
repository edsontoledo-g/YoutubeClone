//
//  PlaylistsProviderMock.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/11/22.
//

import Foundation

class PlaylistsProviderMock: PlaylistsProviderProtocol {
    func getPlaylists(channelId: String) async throws -> PlaylistResponse {
        Utils.decodeJSON(PlaylistResponse.self, filename: "PlaylistsList.json")
    }
}
