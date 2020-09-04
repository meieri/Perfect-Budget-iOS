//
//  WeeklyExpenseListWeeklyExpenseListPresenterTests.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import XCTest

class WeeklyExpenseListPresenterTest: XCTestCase {
    var presenter: WeeklyExpensePresenter!

    override func setUp() {
        super.setUp()
        self.presenter = WeeklyExpensePresenter()
        presenter.interactor = MockInteractor()
        presenter.coordinator = MockCoordinator()
    }

    func testGetWeekString() {
    }

    override func tearDown() {
        //
        super.tearDown()
    }

    class MockInteractor: WeeklyExpenseInteractorInput {
        func createTransaction(reason: String, amount: Double, day: Date) {
        }

        func deleteTransaction(_ transaction: Transaction) {
            //
        }

        func getWeekTransactions(for day: Date) -> [Transaction] {
            //
            return [Transaction]()
        }

        func getWeekString(for day: Date) -> String {
            return "Aug 30 - Sep 5"
        }

        func getCurrentDateMovedBy(week: Int) -> Date {
            //
            return Date()
        }


    }

    class MockCoordinator: Coordinator {
        func showMenu() {
            //
        }

        var children = [Coordinator]()

        var navigationController: UINavigationController?

        func start() {
            //
        }

        func transactionTapped(_ transaction: Transaction) {
            //
        }

        func viewGraphScreen() {
            //
        }


    }

    class MockViewController: WeeklyExpenseViewInput {
        func setupInitialState(using weeklyTransactions: [Transaction], weekTitle: String) {
            //
        }

        func addTransaction(_ transaction: Transaction) {
            //
        }


        func setupInitialState() {

        }
    }
}
