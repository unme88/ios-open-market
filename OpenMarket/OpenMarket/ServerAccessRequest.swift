//
//  ServerAccessRequest.swift
//  OpenMarket
//
//  Created by Sunny, James on 2021/05/11.
//

import Foundation

struct JokeReponse: Decodable {
    let page: Int
    let items: Joke
}

struct Joke: Decodable {
    let id: Int
    let title: String
    let price: Int
}
