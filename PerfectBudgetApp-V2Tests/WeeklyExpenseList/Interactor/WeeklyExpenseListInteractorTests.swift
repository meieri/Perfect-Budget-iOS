//
//  WeeklyExpenseListWeeklyExpenseListInteractorTests.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import XCTest
import CoreData
import Foundation

class WeeklyExpenseListInteractorTests: XCTestCase {
    var interactor: WeeklyExpenseInteractor!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.interactor = WeeklyExpenseInteractor()
        self.interactor.service = MockTransactionService()
        self.interactor.output = MockPresenter()
    }

    func testCreateTransaction() {
        interactor.createTransaction(reason: "Test", amount: 10.0)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    class MockPresenter: WeeklyExpenseInteractorOutput {
        func pushNewTransaction(_ transaction: Transaction) {
            XCTAssertEqual(transaction.amount, 10.0)
            XCTAssertEqual(transaction.reason, "Test")
        }
    }
}
