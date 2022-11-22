//
//  PlaylistsPresenter.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/11/22.
//

import Foundation

protocol PlaylistsViewProtocol: AnyObject {
    func getPlaylists(playlists: [PlaylistResponse.Item])
}

class PlaylistsPresenter {
    weak var delegate: PlaylistsViewProtocol?
    var provider: PlaylistsProviderProtocol!
    
    init(provider: PlaylistsProviderProtocol = PlaylistsProvider()) {
        self.provider = provider
        
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = PlaylistsProviderMock()
        }
        #endif
    }
    
    @MainActor
    func getPlaylists() async {
        do {
            let playlistsList = try await provider.getPlaylists(channelId: Constants.channelId).items
            delegate?.getPlaylists(playlists: playlistsList)
        } catch {
            print(error.localizedDescription)
        }
    }
}
