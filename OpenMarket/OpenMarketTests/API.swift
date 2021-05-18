//
//  API.swift
//  OpenMarketTests
//
//  Created by Sunny on 2021/05/18.
//

import Foundation

enum JokesAPI {
    case randomJokes
    
    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    var path: String { "/item/:id" }
    var url: URL { URL(string: JokesAPI.baseURL + path)! }
    
    var sampleData: Data {
        Data(
        """
            {
                "page": 1,
                    "items": {
                    "id": 1,
                    "title": "MacBook Pro",
                    "price": 1690000
                }
            }
            """.utf8
        )
    }
}

class JokesAPIProvider {

    let session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchRandomJoke(completion: @escaping (Result<Joke, Error>) -> Void) {
            let request = URLRequest(url: JokesAPI.randomJokes.url)

            let task: URLSessionDataTask = session
                .dataTask(with: request) { data, urlResponse, error in
                    guard let response = urlResponse as? HTTPURLResponse,
                          (200...399).contains(response.statusCode) else {
                        completion(.failure(error ?? APIError.unknownError))
                        return
                    }

                    if let data = data,
                        let jokeResponse = try? JSONDecoder().decode(JokeReponse.self, from: data) {
                        completion(.success(jokeResponse.value))
                        return
                    }
                    completion(.failure(APIError.unknownError))
            }

            task.resume()
        }
}
