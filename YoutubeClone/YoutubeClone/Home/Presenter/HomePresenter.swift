//
//  HomePresenter.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import Foundation

protocol HomePresenterDelegate: AnyObject {
    func getData(array: [[Any]])
}

class HomePresenter {
    var provider: HomeProviderDelegate
    weak var delegate: HomePresenterDelegate?
    private var objectArray: [[Any]] = []
    
    init(provider: HomeProviderDelegate = HomeProvider()) {
        self.provider = provider
    }
    
    @MainActor
    func getHomeObjects() async {
        objectArray.removeAll()
        
        async let responseChannel = try await provider.getChannel(channelId: Constants.channelId).items
        async let responsePlaylists = try await provider.getPlaylists(channelId: Constants.channelId).items
        async let responseVideos = try await provider.getVideos(searchString: nil, channelId: Constants.channelId).items
        do {
            let (channel, playlists, videos) = await (try responseChannel, try responsePlaylists, try responseVideos)
            objectArray.append(channel)
            
            if let playlistId = playlists.first?.id, let playlistItems = await getPlaylistItems(playlistId: playlistId)?.items {
                objectArray.append(playlistItems)
            }
            
            objectArray.append(playlists)
            objectArray.append(videos)
            
            delegate?.getData(array: objectArray)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getPlaylistItems(playlistId: String) async -> PlaylistItemResponse? {
        let playlistItems = try? await provider.getPlaylistItems(playlistId: playlistId)
        return playlistItems
    }
}
