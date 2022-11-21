//
//  VideosProviderMock.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/11/22.
//

import Foundation

class VideosProviderMock: VideosProviderProtocol {
    func getVideos(channelId: String?) async throws -> VideoResponse {
        Utils.decodeJSON(VideoResponse.self, filename: "VideoList.json")
    }
}
