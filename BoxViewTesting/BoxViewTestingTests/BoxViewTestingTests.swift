//
//  BoxViewTestingTests.swift
//  BoxViewTestingTests
//
//  Created by Vlad on 03.12.2020.
//

import XCTest
@testable import BoxViewTesting

extension XCTestCase {

  var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }

  func wait(timeout: TimeInterval) {
    let expectation = XCTestExpectation(description: "Waiting for \(timeout) seconds")
    XCTWaiter().wait(for: [expectation], timeout: timeout)
  }

}

class BoxViewTestingTests: XCTestCase {

    var testIndex = 0
        
    var viewControllers: [TestViewController] = [
        ViewController1()
    ]
    
    private func setUpViewController(at ind: Int) -> TestViewController {
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = viewControllers[ind]
        appDelegate.window!.rootViewController = vc
        appDelegate.window!.makeKeyAndVisible()
        return vc
    }
    
    override func setUpWithError() throws {
        print("***Lang: \(String(describing: Locale.current.languageCode))")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        for ind in 0..<viewControllers.count {
            let vc = setUpViewController(at: ind)
            wait(timeout: 1)
            XCTAssertTrue(vc.performTests(), "frames are wrong at ind: \(ind)")
            print("===================================")
        }
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
