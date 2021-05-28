//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    
    enum LayoutType {
        case list, grid
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var layoutType = LayoutType.list
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let apiProvider = OpenMarketAPIProvider()
    private var currentPage: Int = 1
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func didTapSegmentedControl(_ segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            layoutType = .list
            segment.backgroundColor = .cyan
        }
        else {
            layoutType = .grid
            segment.backgroundColor = .orange
        }
    }
}
extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutType {
        case .list:
            guard let cell: OpenMarketCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketCollectionViewCell", for: indexPath) as? OpenMarketCollectionViewCell else {
                return UICollectionViewCell()
            }
            getItemList(page: currentPage) { itemList in
                DispatchQueue.main.async {
                    guard let cellIndex = collectionView.indexPath(for: cell),
                          cellIndex == indexPath else { return }
                    cell.itemTitle.text = itemList.items[indexPath.row].title
                    cell.itemThumbnail.image = self.fetchItemThumbnail(itemList: itemList, indexPath: indexPath)
                    cell.itemPrice.text = "\(itemList.items[indexPath.row].currency) + \(itemList.items[indexPath.row].price)"
                    self.judgeDiscountedPriceForCollectionView(cell: cell, itemList: itemList, indexPath: indexPath)
                    cell.itemStock.text = "남은 수량 : \(itemList.items[indexPath.row].stock)"
                }
            }
            return cell
        case .grid:
            guard let cell: OpenMarketGridViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketGridViewCell", for: indexPath) as? OpenMarketGridViewCell else {
                return UICollectionViewCell()
            }
            getItemList(page: currentPage) { itemList in
                DispatchQueue.main.async {
                    guard let cellIndex = collectionView.indexPath(for: cell),
                          cellIndex == indexPath else { return }
                    cell.itemTitle.text = itemList.items[indexPath.row].title
                    cell.itemThumbnail.image = self.fetchItemThumbnail(itemList: itemList, indexPath: indexPath)
                    cell.itemPrice.text = "\(itemList.items[indexPath.row].currency) + \(itemList.items[indexPath.row].price)"
                    self.judgeDiscountedPriceForGridView(cell: cell, itemList: itemList, indexPath: indexPath)
                    cell.itemStock.text = "남은 수량 : \(itemList.items[indexPath.row].stock)"
                }
            }
            return cell
        }
    }
    private func drawCellborder(_ cell: UICollectionViewCell) {
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 8
    }
    
    private func judgeDiscountedPriceForCollectionView(cell: OpenMarketCollectionViewCell, itemList: MarketItemList, indexPath: IndexPath) {
        guard let discountedPrice = itemList.items[indexPath.row].discountedPrice else {
            return cell.itemDiscountedPrice.text = nil
        }
        cell.itemDiscountedPrice.text = "\(itemList.items[indexPath.row].currency) + \(discountedPrice)"
        cell.itemPrice.textColor = .red
    }
    
    private func judgeDiscountedPriceForGridView(cell: OpenMarketGridViewCell, itemList: MarketItemList, indexPath: IndexPath) {
        guard let discountedPrice = itemList.items[indexPath.row].discountedPrice else {
            return cell.itemDiscountedPrice.text = nil
        }
        cell.itemDiscountedPrice.text = "\(itemList.items[indexPath.row].currency) + \(discountedPrice)"
        cell.itemPrice.textColor = .red
    }
    
    private func fetchItemThumbnail(itemList: MarketItemList, indexPath: IndexPath) -> UIImage {
        let thumbnailLink = itemList.items[indexPath.row].thumbnails[currentIndex]
        guard let thumbnailURL = URL(string: thumbnailLink),
              let thumbnailData = try? Data(contentsOf: thumbnailURL),
              let thumbnail = UIImage(data: thumbnailData) else {
            return UIImage()
        }
        return thumbnail
    }
    
    private func getItemList(page: Int, completion: @escaping (MarketItemList) -> Void) {
        apiProvider.getItemListData(page: 1) { result in
            switch result {
            case .success(let itemList):
                completion(itemList)
            case .failure(let error):
                print("\(error) has occurred")
            }
        }
    }
}
extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        switch layoutType {
        case .list:
            return CGSize(width: width * 0.9, height: height / 12)
        case .grid:
            return CGSize(width: (width / 2) * 0.9, height: height / 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
