//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Sunny, James on 2021/05/11.
//

import XCTest
@testable import OpenMarket
class JokesAPIProviderTests: XCTestCase {

    var sut: JokesAPIProvider!

    override func setUpWithError() throws {
        sut = .init(session: MockURLSession())
    }

    func test_fetchRandomJoke() {
        let expectation = XCTestExpectation()
        let response = try? JSONDecoder().decode(Joke.self,
                                                 from: JokesAPI.randomJokes.sampleData)

        sut.fetchRandomJoke { result in
            switch result {
            case .success(let joke):
                XCTAssertEqual(joke.id, response?.value.id)
                XCTAssertEqual(joke.title, response?.value.title)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func test_fetchRandomJoke_failure() {
        sut = .init(session: MockURLSession(makeRequestFail: true))
        let expectation = XCTestExpectation()

        sut.fetchRandomJoke { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "unknownError")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
