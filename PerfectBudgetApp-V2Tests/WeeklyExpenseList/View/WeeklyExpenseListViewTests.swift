//
//  WeeklyExpenseListWeeklyExpenseListViewTests.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import XCTest

class WeeklyExpenseListViewTests: XCTestCase {
    var viewController: WeeklyExpenseViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewController = WeeklyExpenseViewController()
        let mockPresenter = MockPresenter()
        viewController.output = mockPresenter
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    class MockPresenter: WeeklyExpenseViewOutput {
        func viewIsReady() {

        }
        func createTransaction(reason: String, amount: Double) {

        }
        func errorCreatingTransaction() {
        }
        func showGraphScreen(){
        }
        func transactionTapped(_ transaction: Transaction) {

        }
        func deleteTransaction(transaction: Transaction) {

        }
        func getPreviousWeekViewController(index: Int) -> WeeklyExpenseViewController {
            return WeeklyExpenseViewController()
        }
        func pageViewTransitionCompleted() {

        }
        func pushNewTransaction(_ transaction: Transaction) {
            //            print(transaction.amount)
            //            print(transaction.reason)
            XCTAssertEqual(transaction.amount, 10.0)
        }
    }
}
