//
//  HomePresenterTests.swift
//  YoutubeCloneTests
//
//  Created by Edson Dario Toledo Gonzalez on 23/11/22.
//

import XCTest
@testable import YoutubeClone
import SDWebImage
import YouTubeiOSPlayerHelper

@MainActor
final class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!
    var sutDelegate: HomeViewMock!
    var provider: HomeProviderMock!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        MockManager.shared.runAppWithMock = true
        provider = HomeProviderMock()
        sut = HomePresenter(provider: provider)
        sutDelegate = HomeViewMock()
        sut.delegate = sutDelegate
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sut = nil
        provider = nil
        sutDelegate = nil
    }
    
    func testIfHomeObjectsAreInCorrectOrder() async throws {
        await sut.getHomeObjects()
        
        guard let objectArray = sutDelegate.objectArray else {
            XCTFail("Failed to get home object array")
            return
        }
        
        XCTAssertTrue(objectArray.count == 4, "Incorrect number of sections in home view")
        XCTAssertTrue(objectArray[0] is [ChannelResponse.Item], "Incorrect order for channel cell")
        XCTAssertTrue(objectArray[1] is [PlaylistItemResponse.Item], "Incorrect order for playlist items cells")
        XCTAssertTrue(objectArray[2] is [VideoResponse.Item], "Incorrect order for videos cells")
        XCTAssertTrue(objectArray[3] is [PlaylistResponse.Item], "Incorrect order for playlists cells")
    }
    
    func testHomeObjectsShouldFail() async throws {
        MockManager.shared.runAppWithMock = false
        provider = HomeProviderMock()
        provider.shouldFail = true
        sut = HomePresenter(provider: provider)
        sutDelegate = HomeViewMock()
        sut.delegate = sutDelegate
        
        await sut.getHomeObjects()
        
        XCTAssertTrue(sutDelegate.didShowError == true)
    }
}

class HomeViewMock: HomeViewProtocol {
    var objectArray: [[Any]]?
    var didShowError = false
    
    func getData(array: [[Any]], sectionTitleArray: [String]) {
        objectArray = array
    }
    
    func loadingView(_ state: YoutubeClone.LoadingViewState) {
        
    }
    
    func showError(_ error: String, completionHandler: (() -> Void)?) {
        didShowError = true
    }
}
