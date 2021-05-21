//
//  MockURLProtocol.swift
//  OpenMarketTests
//
//  Created by Sunny on 2021/05/14.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            guard let resultData = data else { return }
            
            client?.urlProtocol(self, didLoad: resultData)
            client?.urlProtocolDidFinishLoading(self)
            
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        
    }
    
    override func stopLoading() {
        
    }
    
}
