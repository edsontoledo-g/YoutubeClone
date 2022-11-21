//
//  VideosPresenter.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/11/22.
//

import Foundation

protocol VideosViewProtocol: AnyObject {
    func getVideos(videoList: [VideoResponse.Item])
}

class VideosPresenter {
    weak var delegate: VideosViewProtocol?
    var provider: VideosProviderProtocol!
    
    init(provider: VideosProviderProtocol = VideosProvider()) {
        self.provider = provider
        
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = VideosProviderMock()
        }
        #endif
    }
    
    @MainActor
    func getVideos() async {
        do {
            let videos = try await provider.getVideos(channelId: Constants.channelId).items
            delegate?.getVideos(videoList: videos)
        } catch {
            print(error.localizedDescription)
        }
    }
}
