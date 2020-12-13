//
//  ViewController.swift
//  BoxViewTesting
//
//  Created by Vlad on 03.12.2020.
//

import UIKit

class TestViewController: UIViewController {
    
    var testViews = [TestView]()
    var runTestsOnLoad = false
    var curView: TestView?

    @discardableResult
    func performTests() -> Bool {
        for testView in testViews {
            curView?.removeFromSuperview()
            view.addFillingSubview(testView)
            curView = testView
            testView.backgroundColor = .blue
            print("\n\n******* testView: \(testView)")
            if !testView.checkAllSCAFrames() {
                return false
            }
        }
        return true
    }
}

class ViewController1: TestViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testViews = [ SimpleTestView(),  SimpleTestView(axis: .x),
                      CenterTestView(), CenterTestView(axis: .x),
                      CenterTestViewB(), CenterTestViewB(axis: .x),
                      ChainTestView(), ChainTestView(axis: .x),
                      RelationTestView(), RelationTestView(axis: .x),
                      PinTestView(), PinTestView(axis: .x)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if runTestsOnLoad {
            performTests()
        }
    }

}


