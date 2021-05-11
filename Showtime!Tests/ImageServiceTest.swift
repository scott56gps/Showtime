//
//  ImageServiceTest.swift
//  Showtime!Tests
//
//  Created by Scott Nicholes on 5/9/21.
//

import XCTest
@testable import Showtime_

class ImageServiceTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchImage_MalformedURL() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // If an empty URL is passed, the completion handler should receive an invalid endpoint failure
        let url = URL(string: "http://localhost:-80")!
        let imageService = ImageService()
        
        let cancellableToken = imageService.fetchImage(from: url) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Invalid endpoint")
            case .success(_):
                break
            }
        }
        
        XCTAssertNil(cancellableToken)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
