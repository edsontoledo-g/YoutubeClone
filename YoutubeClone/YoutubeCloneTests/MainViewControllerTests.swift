//
//  MainViewControllerTests.swift
//  YoutubeCloneTests
//
//  Created by Edson Dario Toledo Gonzalez on 24/11/22.
//

import XCTest
@testable import YoutubeClone

final class MainViewControllerTests: XCTestCase {
    var sut: MainViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        sut = vc
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sut = nil
    }
    
    func testIfViewControllerIsLoaded() throws {
        XCTAssertNotNil(sut.rootPageViewController, "View controller couldn't be loaded correctly")
    }
}
