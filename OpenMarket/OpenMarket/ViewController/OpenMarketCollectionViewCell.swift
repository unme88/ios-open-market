//
//  OpenMarketCollectionViewCell.swift
//  OpenMarket
//
//  Created by James, Sunny on 2021/05/28.
//

import UIKit

class OpenMarketCollectionViewCell: UICollectionViewCell, UIUpdatable {
    
    @IBOutlet weak private var itemThumbnail: UIImageView!
    @IBOutlet weak private var itemTitle: UILabel!
    @IBOutlet weak private var itemPrice: UILabel!
    @IBOutlet weak private var itemDiscountedPrice: UILabel!
    @IBOutlet weak private var itemStock: UILabel!
    var currentIndex: Int = 0
    
    func updateUI(with itemList: MarketItemList, index: Int) {
        itemTitle.text = itemList.items[index].title
        itemThumbnail.image = self.fetchItemThumbnail(itemList: itemList, index: index)
        itemPrice.text = "\(itemList.items[index].currency) + \(itemList.items[index].price)"
        judgeDiscountedPriceForCollectionView(itemList: itemList, index: index)
        itemStock.text = "남은 수량 : \(itemList.items[index].stock)"
        drawCellborder()
    }
    
    func judgeDiscountedPriceForCollectionView(itemList: MarketItemList, index: Int) {
        guard let discountedPrice = itemList.items[index].discountedPrice else {
            return itemDiscountedPrice.text = nil
        }
        itemDiscountedPrice.text = "\(itemList.items[index].currency) + \(discountedPrice)"
        itemPrice.textColor = .red
    }
    
    func fetchItemThumbnail(itemList: MarketItemList, index: Int) -> UIImage {
        let thumbnailLink = itemList.items[index].thumbnails[currentIndex]
        guard let thumbnailURL = URL(string: thumbnailLink),
              let thumbnailData = try? Data(contentsOf: thumbnailURL),
              let thumbnail = UIImage(data: thumbnailData) else {
            return UIImage()
        }
        return thumbnail
    }
    
    func drawCellborder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 8
    }
}
