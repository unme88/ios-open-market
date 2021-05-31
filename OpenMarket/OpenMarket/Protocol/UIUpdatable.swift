//
//  UIUpdatable.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/05/30.
//

import Foundation
import UIKit

protocol UIUpdatable {
    var currentIndex: Int { get set }
    func updateUI(with itemList: MarketItemList, index: Int)
    func judgeDiscountedPriceForCollectionView(itemList: MarketItemList, index: Int)
    func fetchItemThumbnail(itemList: MarketItemList, index: Int) -> UIImage
}
