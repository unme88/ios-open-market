//
//  MockURLProtocol.swift
//  OpenMarketTests
//
//  Created by Sunny on 2021/05/14.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession: URLSessionProtocol { }

enum APIError: LocalizedError {
    case unknownError
    var errorDescription: String? { "unknownError" }
}

class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall: () -> Void = {}

    override func resume() {
        resumeDidCall()
    }
}

class MockURLSession: URLSessionProtocol {

    var makeRequestFail = false
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }

    var sessionDataTask: MockURLSessionDataTask?

    // dataTask 를 구현합니다.
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        // 성공시 callback 으로 넘겨줄 response
        let successResponse = HTTPURLResponse(url: JokesAPI.randomJokes.url,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        // 실패시 callback 으로 넘겨줄 response
        let failureResponse = HTTPURLResponse(url: JokesAPI.randomJokes.url,
                                              statusCode: 410,
                                              httpVersion: "2",
                                              headerFields: nil)

        let sessionDataTask = MockURLSessionDataTask()

        // resume() 이 호출되면 completionHandler() 가 호출되도록 합니다.
        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(JokesAPI.randomJokes.sampleData, successResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}


