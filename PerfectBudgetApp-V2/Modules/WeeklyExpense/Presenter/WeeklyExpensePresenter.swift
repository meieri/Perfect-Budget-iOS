//
//  WeeklyExpensePresenter.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//
import Foundation

class WeeklyExpensePresenter {
    weak var view: WeeklyExpenseViewInput!
    weak var pageView: WeeklyExpensePageViewInput!
    var interactor: WeeklyExpenseInteractorInput!
    var coordinator: Coordinator!
    private var currentViewIndex: Int = 0

    /// Checks the pageView for its current index, and gets a date moved that number weeks away backwards from today's date.
    private func getDisplayDate(index: Int) -> Date {
//        var weeksAway = pageView.getCurrentIndex()
        var weeksAway = index
        weeksAway.negate()
        let day = interactor.getCurrentDateMovedBy(week: weeksAway)
        return day
    }

    func generateViewControllers() {
        var views: [WeeklyExpenseViewController] = []
        for index in 1...9 {
            self.currentViewIndex = index
            let vc = WeeklyExpenseViewController()
            self.view = vc
            vc.output = self
            vc.view.tag = index
            views.append(vc)
        }
        pageView.setViewControllers(views)
    }
}

extension WeeklyExpensePresenter: WeeklyExpenseViewOutput {
    func pageViewTransitionCompleted() {
        let view = pageView.getCurrentViewController()
        view.output = self
        self.view = view
        currentViewIndex = view.view.tag
    }

    func viewIsReady() {
        let index = currentViewIndex
        let day = getDisplayDate(index: index)
        let weeklyTransactions = interactor.getWeekTransactions(for: day)
        let weekTitle = interactor.getWeekString(for: day)
        view.setupInitialState(using: weeklyTransactions, weekTitle: weekTitle)
    }

    func createTransaction(reason: String, amount: Double) {
        let index = pageView.getCurrentIndex()
        let day = getDisplayDate(index: index)
        interactor.createTransaction(reason: reason, amount: amount, day: day)
    }

    func errorCreatingTransaction() {
        // TODO show errors
    }

    func showGraphScreen() {
        coordinator.viewGraphScreen()
    }

    func transactionTapped(_ tappedTransaction: Transaction) {
        coordinator.transactionTapped(tappedTransaction)
    }

    func deleteTransaction(transaction: Transaction) {
        interactor.deleteTransaction(transaction)
    }

    // initializes view
    func getPreviousWeekViewController(index: Int) -> WeeklyExpenseViewController {
        currentViewIndex = index
        let weeklyExpenseVC = WeeklyExpenseViewController()
        weeklyExpenseVC.output = self
        weeklyExpenseVC.view.tag = index
        self.view = weeklyExpenseVC
        return weeklyExpenseVC
    }

    func menuTapped() {
        coordinator.showMenu()
    }

}

extension WeeklyExpensePresenter: WeeklyExpenseInteractorOutput {
    func pushNewTransaction(_ transaction: Transaction) {
        let index = pageView.getCurrentIndex()
        let day = getDisplayDate(index: index)
        let weekTitle = interactor.getWeekString(for: day)
        let view = pageView.getCurrentViewController()
        self.view = view
        view.addTransaction(transaction)
    }
}
