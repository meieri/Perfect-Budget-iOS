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
        // This method is called before the invocation of each test method in the class.
        self.interactor = WeeklyExpenseInteractor()
        self.interactor.service = MockTransactionService()
        self.interactor.testOutput = MockPresenter()
    }

    func testGetWeekString() {
        //Monday, January 1, 2001
        let date = Date.init(timeIntervalSinceReferenceDate: 86400)
        let weekString = interactor.getWeekString(for: date)
        XCTAssertEqual("Dec 31 – Jan 6", weekString)
    }

    // need to set up a test core data service
    func testGetWeekMovedByIndex() {
        let date = Date()
        let movedByOneWeek = interactor.getCurrentDateMovedBy(week: 0)
        let thisWeekDescription = movedByOneWeek.description(with: Locale(identifier: "en-US"))
        let todayDescription = date.description(with: Locale(identifier: "en-US"))
        XCTAssertEqual(thisWeekDescription, todayDescription)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

class MockPresenter: WeeklyExpenseInteractorOutput {
    func pushNewTransaction(_ transaction: Transaction) {
        print(transaction.amount)
        print(transaction.reason)
        XCTAssertEqual(transaction.amount, 10.0)
    }
}
