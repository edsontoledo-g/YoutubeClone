//
//  PlayVideoPresenter.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/11/22.
//

import Foundation

protocol PlayVideoViewProtocol: AnyObject, BaseViewProtocol {
    func getRelatedVideosFinished()
}

@MainActor
class PlayVideoPresenter {
    private var provider: PlayVideoProviderProtocol
    weak var delegate: PlayVideoViewProtocol?
    
    var relatedVideosArray: [[Any]] = []
    var channel: ChannelResponse.Item?
    
    init(provider: PlayVideoProviderProtocol = PlayVideoProvider()) {
        self.provider = provider
        
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = PlayVideoProviderMock()
        }
        #endif
    }
    
    func getVideos(videoId: String) async {
        delegate?.loadingView(.show)
        
        do {
            defer {
                delegate?.loadingView(.hide)
            }
            
            let response = try await provider.getVideo(videoId)
            relatedVideosArray.append(response.items)
            await getChannelAndRelatedVideos(videoId, response.items.first?.snippet?.channelId ?? "")
            
            delegate?.getRelatedVideosFinished()
        } catch {
            delegate?.showError(error.localizedDescription, completionHandler: {
                Task { [weak self] in
                    await self?.getVideos(videoId: videoId)
                }
            })
        }
    }
    
    func getChannelAndRelatedVideos(_ videoId: String, _ channelId: String) async {
        async let relatedVideosResponse = provider.getRelatedVideos(videoId)
        async let channelResponse = provider.getChannel(channelId)
        
        do {
            let (relatedVideos, channel) = try await (relatedVideosResponse, channelResponse)
            let filterRelatedVideos = relatedVideos.items.filter { $0.snippet != nil }
            
            relatedVideosArray.append(filterRelatedVideos)
            self.channel = channel.items.first
        } catch {
            delegate?.showError(error.localizedDescription, completionHandler: nil)
        }
    }
}
