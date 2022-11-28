//
//  PlayVideoPresenterTests.swift
//  YoutubeCloneTests
//
//  Created by Edson Dario Toledo Gonzalez on 23/11/22.
//

import XCTest
@testable import YoutubeClone

import SDWebImage
import YouTubeiOSPlayerHelper

@MainActor
final class PlayVideoPresenterTests: XCTestCase {
    var sut: PlayVideoPresenter!
    var sutDelegate: PlayVideoViewMock!
    var provider: PlayVideoProviderProtocol!
    var videoId = "PY9HTSBXE8s"
    var timeout: TimeInterval = 10.0
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        MockManager.shared.runAppWithMock = false
        provider = PlayVideoProvider()
        sut = PlayVideoPresenter(provider: provider)
        sutDelegate = PlayVideoViewMock()
        sut.delegate = sutDelegate
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        provider = nil
        sut = nil
        sutDelegate = nil
    }
    
    func testGetRelatedVideosAndChannelFromVideo() {
        sutDelegate.expectationGetRelatedVideosFinished = expectation(description: "Loading videos")
        sutDelegate.expectationLoadingView = expectation(description: "Show/hide loading")
        sutDelegate.expectationLoadingView?.expectedFulfillmentCount = 2
        
        Task {
            await sut.getVideos(videoId: videoId)
        }
        
        waitForExpectations(timeout: timeout)
        
        guard let videos = sut.relatedVideosArray.first as? [VideoResponse.Item] else {
            XCTFail("Failed to get related videos")
            return
        }
         
        XCTAssertTrue(videos.first?.id == videoId, "Video id is different than expected")
        XCTAssertTrue(sut.relatedVideosArray.count == 2, "Couldn't retreive related videos")
        XCTAssertNotNil(sut.channel, "Couldn't retreive channel from video")
        
        XCTAssertTrue(sutDelegate.didStartLoadingView && sutDelegate.didFinishLoadingView, "Loading view should appear and disappear but just one state occurred")
    }
    
    func testGetRelatedVideosAndChannelFromVideoShouldFail() {
        MockManager.shared.runAppWithMock = false
        let providerMock = PlayVideoProviderMock()
        providerMock.shouldFail = true
        sut = PlayVideoPresenter(provider: providerMock)
        sutDelegate = PlayVideoViewMock()
        sut.delegate = sutDelegate
        
        sutDelegate.expectationShowError = expectation(description: "Show error")
        
        Task {
            await sut.getVideos(videoId: videoId)
        }
        
        waitForExpectations(timeout: timeout)
        XCTAssertFalse(sutDelegate.didFinishGettingRelatedVideos)
        XCTAssertTrue(sutDelegate.didShowError)
    }
}

class PlayVideoViewMock: PlayVideoViewProtocol {
    var didShowError = false
    var didFinishGettingRelatedVideos = false
    var didStartLoadingView = false
    var didFinishLoadingView = false
    
    var expectationLoadingView: XCTestExpectation?
    var expectationGetRelatedVideosFinished: XCTestExpectation?
    var expectationShowError: XCTestExpectation?
    
    func loadingView(_ state: YoutubeClone.LoadingViewState) {
        if state == .show {
            didStartLoadingView = true
        } else {
            didFinishLoadingView = true
        }
        
        expectationLoadingView?.fulfill()
    }
    
    func showError(_ error: String, completionHandler: (() -> Void)?) {
        didShowError = true
        expectationShowError?.fulfill()
    }
    
    func getRelatedVideosFinished() {
        didFinishGettingRelatedVideos = true
        expectationGetRelatedVideosFinished?.fulfill()
    }
}
