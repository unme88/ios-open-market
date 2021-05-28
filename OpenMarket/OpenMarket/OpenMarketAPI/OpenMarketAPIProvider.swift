//
//  APIManager.swift
//  OpenMarket
//
//  Created by Sunny, James on 2021/05/17.
//

import Foundation

class OpenMarketAPIProvider {
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func getItemListData(page: Int, completion: @escaping(_ result: Result <MarketItemList, Error>) -> Void) {
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/\(page)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            do {
                if let error = error {
                    completion(Result.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                    completion(Result.failure(APIError.networking))
                    return
                }
                
                if let data = data,
                   let object = try? JSONDecoder().decode(MarketItemList.self, from: data)  {
                    completion(Result.success(object))
                } else {
                    throw APIError.networking
                }
            } catch {
                completion(Result.failure(error))
            }
        }
        dataTask.resume()
    }
    
}
