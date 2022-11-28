//
//  HomeViewControllerTests.swift
//  YoutubeCloneTests
//
//  Created by Edson Dario Toledo Gonzalez on 24/11/22.
//

import XCTest
@testable import YoutubeClone
import SDWebImage
import YouTubeiOSPlayerHelper

final class HomeViewControllerTests: XCTestCase {
    var sut: HomeViewController!
    var provider: HomeProviderProtocol!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        provider = HomeProviderMock()
        sut = HomeViewController()
        sut.presenter = HomePresenter(provider: provider)
        sut.presenter.delegate = sut
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sut = nil
        provider = nil
    }
    
    func testIfViewControllerIsLoaded() throws {
        XCTAssertNotNil(sut.tableViewHome, "View controller couldn't be loaded correctly")
    }
}
