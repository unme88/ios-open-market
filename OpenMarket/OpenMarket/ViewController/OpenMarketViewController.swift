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
    private var currentPage: Int = 1
    private var currentIndex: Int = 0
    private let apiProvider = OpenMarketAPIProvider()
    
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
        self.collectionView.reloadData()
    }
}
extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutType {
        case .list:
            guard let cell: OpenMarketCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketCollectionViewCell", for: indexPath) as? OpenMarketCollectionViewCell else {
                return UICollectionViewCell()
            }
            apiProvider.getItemListData(page: currentPage) { result in
                switch result {
                case .success(let itemList):
                    DispatchQueue.main.async {
                        guard let cellIndex = collectionView.indexPath(for: cell),
                              cellIndex == indexPath else { return }
                        cell.updateUI(with: itemList, index: indexPath.row)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            return cell
        case .grid:
            guard let cell: OpenMarketGridViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketGridViewCell", for: indexPath) as? OpenMarketGridViewCell else {
                return UICollectionViewCell()
            }
            apiProvider.getItemListData(page: currentPage) { result in
                switch result {
                case .success(let itemList):
                    DispatchQueue.main.async {
                        guard let cellIndex = collectionView.indexPath(for: cell),
                              cellIndex == indexPath else { return }
                        cell.updateUI(with: itemList, index: indexPath.row)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            return cell
        }
    }
    
}
extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width
//        let height = collectionView.frame.height
//
//        switch layoutType {
//        case .list:
//            return CGSize(width: width * 0.9, height: height / 12)
//        case .grid:
//            return CGSize(width: (width / 2) * 0.9, height: height / 3)
//        }
//    }
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

class OpenMarketCollectionViewLayout: UICollectionViewLayout {
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let customCollectionview = collectionView else { return
            0
        }
        let insets = customCollectionview.contentInset
        return customCollectionview.bounds.width - (insets.left - insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
}
