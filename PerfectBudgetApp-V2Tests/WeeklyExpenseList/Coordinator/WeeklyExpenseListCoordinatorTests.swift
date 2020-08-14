//
//  WeeklyExpenseWeeklyExpenseConfiguratorTests.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import XCTest

class WeeklyExpenseModuleConfiguratorTests: XCTestCase {

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
        let coordinator = WeeklyExpenseCoordinator(UINavigationController())

        //when
        coordinator.start()

        //then
        XCTAssertNotNil(coordinator.view)
        XCTAssertNotNil(viewController.output, "WeeklyExpenseViewController is nil after configuration")
        XCTAssertTrue(viewController.output is WeeklyExpensePresenter, "output is not WeeklyExpensePresenter")

        let presenter: WeeklyExpensePresenter = viewController.output as! WeeklyExpensePresenter
        XCTAssertNotNil(presenter.view, "view in WeeklyExpensePresenter is nil after configuration")
        XCTAssertNotNil(presenter.coordinator, "router in WeeklyExpensePresenter is nil after configuration")
        XCTAssertTrue(presenter.coordinator is WeeklyExpenseCoordinator)

        let interactor: WeeklyExpenseInteractor = presenter.interactor as! WeeklyExpenseInteractor
        XCTAssertNotNil(interactor.output, "output in WeeklyExpenseInteractor is nil after configuration")
    }

    class WeeklyExpenseViewControllerMock: WeeklyExpenseViewController {

        var setupInitialStateDidCall = false

        func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
