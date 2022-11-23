//
//  HomePresenter.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import Foundation

protocol HomePresenterDelegate: AnyObject, BaseViewProtocol {
    func getData(array: [[Any]], sectionTitleArray: [String])
}

class HomePresenter {
    var provider: HomeProviderProtocol
    weak var delegate: HomePresenterDelegate?
    private var objectArray: [[Any]] = []
    private var sectionTitleArray: [String] = []
    
    init(provider: HomeProviderProtocol = HomeProvider()) {
        self.provider = provider
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = HomeProviderMock()
        }
        #endif
    }
    
    @MainActor
    func getHomeObjects() async {
        delegate?.loadingView(.show)
        objectArray.removeAll()
        sectionTitleArray.removeAll()
        
        async let responseChannel = try await provider.getChannel(channelId: Constants.channelId).items
        async let responsePlaylists = try await provider.getPlaylists(channelId: Constants.channelId).items
        async let responseVideos = try await provider.getVideos(searchString: nil, channelId: Constants.channelId).items
        
        do {
            defer {
                delegate?.loadingView(.hide)
            }
            
            let (channel, playlists, videos) = await (try responseChannel, try responsePlaylists, try responseVideos)
            objectArray.append(channel)
            sectionTitleArray.append("")
            
            if let playlistId = playlists.first?.id, let playlistItems = await getPlaylistItems(playlistId: playlistId)?.items {
                objectArray.append(playlistItems)
                sectionTitleArray.append(playlists.first?.snippet?.title ?? "")
            }
            
            objectArray.append(videos)
            sectionTitleArray.append("Uploads")
            
            objectArray.append(playlists)
            sectionTitleArray.append("Created Playlists")
            
            
            delegate?.getData(array: objectArray, sectionTitleArray: sectionTitleArray)
        } catch {
            delegate?.showError(error.localizedDescription, completionHandler: { [weak self] in
                Task {
                    await self?.getHomeObjects()
                }
            })
            print(error.localizedDescription)
        }
    }
    
    private func getPlaylistItems(playlistId: String) async -> PlaylistItemResponse? {
        let playlistItems = try? await provider.getPlaylistItems(playlistId: playlistId)
        return playlistItems
    }
}
