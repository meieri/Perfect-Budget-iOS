//
//  WeeklyExpenseListWeeklyExpenseListConfiguratorTests.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import XCTest

class WeeklyExpenseListModuleConfiguratorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigureModuleForViewController() {

        //given
        let viewController = WeeklyExpenseListViewControllerMock()
        let configurator = WeeklyExpenseListModuleConfigurator()

        //when
        configurator.configureModuleForViewInput(viewInput: viewController)

        //then
        XCTAssertNotNil(viewController.output, "WeeklyExpenseListViewController is nil after configuration")
        XCTAssertTrue(viewController.output is WeeklyExpenseListPresenter, "output is not WeeklyExpenseListPresenter")

        let presenter: WeeklyExpenseListPresenter = viewController.output as! WeeklyExpenseListPresenter
        XCTAssertNotNil(presenter.view, "view in WeeklyExpenseListPresenter is nil after configuration")
        XCTAssertNotNil(presenter.router, "router in WeeklyExpenseListPresenter is nil after configuration")
        XCTAssertTrue(presenter.router is WeeklyExpenseListRouter, "router is not WeeklyExpenseListRouter")

        let interactor: WeeklyExpenseListInteractor = presenter.interactor as! WeeklyExpenseListInteractor
        XCTAssertNotNil(interactor.output, "output in WeeklyExpenseListInteractor is nil after configuration")
    }

    class WeeklyExpenseListViewControllerMock: WeeklyExpenseListViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
