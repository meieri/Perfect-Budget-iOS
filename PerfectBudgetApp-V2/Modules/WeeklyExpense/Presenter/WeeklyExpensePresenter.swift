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

    /// Checks the pageView for its current index, and gets a date moved that number weeks away backwards from today's date.
    private func getDisplayDate(index: Int) -> Date {
        var weeksAway = pageView.getCurrentIndex()
        weeksAway.negate()
        let day = interactor.getCurrentDateMovedBy(week: weeksAway)
        return day
    }
}

extension WeeklyExpensePresenter: WeeklyExpenseViewOutput {
    func pageViewTransitionCompleted() {
        let view = pageView.getCurrentViewController()
        view.output = self
        self.view = view
        print(view.view.tag)
    }

    func viewIsReady(tag: Int) {
        let index = tag
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
        //
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

    func getPreviousWeekViewController(index: Int) -> WeeklyExpenseViewController {
        let weeklyExpenseVC = WeeklyExpenseViewController()
        weeklyExpenseVC.output = self
        weeklyExpenseVC.view.tag = index
        self.view = weeklyExpenseVC
        return weeklyExpenseVC
    }

}

extension WeeklyExpensePresenter: WeeklyExpenseInteractorOutput {
    func pushNewTransaction(_ transaction: Transaction) {
        let index = pageView.getCurrentIndex()
        let day = getDisplayDate(index: index)
        let weekTitle = interactor.getWeekString(for: day)
        print(weekTitle)
        view.addTransaction(transaction)
    }
}
