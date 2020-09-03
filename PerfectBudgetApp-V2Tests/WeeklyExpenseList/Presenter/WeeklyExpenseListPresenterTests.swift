//
//  WeeklyExpenseListWeeklyExpenseListPresenterTests.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import XCTest

class WeeklyExpenseListPresenterTest: XCTestCase {
    var presenter: WeeklyExpenseListPresenter!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.presenter = WeeklyExpenseListPresenter()
        presenter.interactor = MockInteractor()
        presenter.coordinator = MockCoordinator()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    class MockInteractor: WeeklyExpenseListInteractorInput {

    }

    class MockCoordinator: WeeklyExpenseListRouterInput {

    }

    class MockViewController: WeeklyExpenseListViewInput {

        func setupInitialState() {

        }
    }
}
