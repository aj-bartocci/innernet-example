//
//  URLSessionViewModelTests.swift
//  InnernetExampleAppTests
//
//  Created by AJ Bartocci on 8/4/21.
//

import XCTest
@testable import InnernetExampleApp
import Innernet
import Combine

class URLSessionViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        URLSession.interceptRequests()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_download_WhenFailing_SetsErrorMessage() {
        Innernet.intercept(.get, matching: "somefakedomain.com/items") { _, completion in
            completion(.networkError(.timeout))
        }
        let sut = URLSessionViewModel()
        sut.download()
        let errorExpect = expectation(description: "test_download_WhenFailing_SetsErrorMessage.error")
        let itemExpect = expectation(description: "test_download_WhenFailing_SetsErrorMessage.items")
        sut.$errorMessage.dropFirst().sink { value in
            XCTAssertNotNil(value)
            errorExpect.fulfill()
        }.store(in: &cancellables)
        sut.$items.dropFirst().sink { value in
            XCTAssert(value.isEmpty)
            itemExpect.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [errorExpect, itemExpect], timeout: 0.1)
    }
    
    func test_download_WhenSuccessful_SetsItems() {
        let items: [ExampleItem] = [
            ExampleItem(id: "1", value: "Foo"),
            ExampleItem(id: "2", value: "Bar"),
            ExampleItem(id: "3", value: "Baz"),
        ]
        Innernet.intercept(.get, matching: "somefakedomain.com/*") { _, completion in
            let data = try? JSONEncoder().encode(items)
            completion(.mock(status: 200, data: data, headers: nil, httpVersion: nil))
        }
        let sut = URLSessionViewModel()
        sut.download()
        let errorExpect = expectation(description: "test_download_WhenSuccessful_SetsItems.error")
        let itemExpect = expectation(description: "test_download_WhenSuccessful_SetsItems.items")
        sut.$errorMessage.dropFirst().sink { value in
            XCTAssertNil(value)
            errorExpect.fulfill()
        }.store(in: &cancellables)
        sut.$items.dropFirst().sink { value in
            XCTAssertEqual(value, items)
            itemExpect.fulfill()
        }.store(in: &cancellables)
        wait(for: [errorExpect, itemExpect], timeout: 0.1)
    }

}
