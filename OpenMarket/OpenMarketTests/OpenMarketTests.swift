//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Yeon on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    private var itemList: ItemList?
    private var item: Item?
    private var deleteItem: ItemToDelete?
    
    func testGetItemListAsync() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")

        ItemManager.shared.loadData(path: .items, param: 1) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    itemList = try JSONDecoder().decode(ItemList.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }

        wait(for: [expectation], timeout: 5.0)
        let page = itemList?.page

        XCTAssertEqual(page, 1)
    }
    
    func testGetItemDetail() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        ItemManager.shared.loadData(path: .item, param: 68) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        let id = item?.id
        let title = item?.title
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(id, 68)
        XCTAssertEqual(title, "Mac mini")
        XCTAssertEqual(price, 890000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 90)
    }
    
    func testPostItem() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        guard let airPodMaxImage1 = UIImage(named: "AirPodMax1"), let airPodMaxImage2 = UIImage(named: "AirPodMax2") else {
            return
        }
        var imageDataStringArray: [String] = []
        guard let airPodMaxImageData1 = UIImageToData(image: airPodMaxImage1), let airPodMaxImageData2 = UIImageToData(image: airPodMaxImage2) else {
            return
        }
        imageDataStringArray.append(airPodMaxImageData1)
        imageDataStringArray.append(airPodMaxImageData2)
        
        let newItem = ItemToUpload(title: "AirPod Max",
                                        descriptions: "귀를 호강시켜주는 에어팟 맥스! 사주실 분 구해요ㅠ",
                                        price: 700000,
                                        currency: "KRW",
                                        stock: 10000,
                                        discountedPrice: nil,
                                        images: imageDataStringArray,
                                        password: "asdfqwerzxcv")
        
        ItemManager.shared.uploadData(method: .post, path: .item, item: newItem, param: nil) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        let title = item?.title
        let description = item?.descriptions
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(title, "AirPod Max")
        XCTAssertEqual(description, "귀를 호강시켜주는 에어팟 맥스! 사주실 분 구해요ㅠ")
        XCTAssertEqual(price, 700000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 10000)
    }
    
    func testPatchItem() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        let param: UInt = 239
        let pathcItem = ItemToUpload(title: nil,
                                          descriptions: nil,
                                          price: 750000,
                                          currency: nil,
                                          stock: 500000,
                                          discountedPrice: nil,
                                          images: nil,
                                          password: "asdfqwerzxcv")
        
        ItemManager.shared.uploadData(method: .patch, path: .item, item: pathcItem, param: param) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        let id = item?.id
        let title = item?.title
        let description = item?.descriptions
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(id, param)
        XCTAssertEqual(title, "AirPod Max")
        XCTAssertEqual(description, "귀를 호강시켜주는 에어팟 맥스! 사주실 분 구해요ㅠ")
        XCTAssertEqual(price, 750000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 500000)
    }
    
    private func UIImageToData(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8)?.base64EncodedData() else {
            return nil
        }
        let dataString = String(decoding: data, as: UTF8.self)
        return dataString
    }
    
    func testDeleteData() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        let param: UInt = 239
        let item = ItemToDelete(id: param, password: "asdfqwerzxcv")
        
        ItemManager.shared.deleteData(path: .item, deleteItem: item, param: param) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    deleteItem = try JSONDecoder().decode(ItemToDelete.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        let id = deleteItem?.id
        
        XCTAssertEqual(id, param)
    }
}
