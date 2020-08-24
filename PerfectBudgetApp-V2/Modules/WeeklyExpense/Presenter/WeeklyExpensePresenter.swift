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

    private func getDate() -> Date {
        var weeksAway = pageView.getCurrentIndex()
        weeksAway.negate()
        print(weeksAway)
        let day = interactor.getCurrentDateMovedBy(week: weeksAway)
        return day
    }
}

extension WeeklyExpensePresenter: WeeklyExpenseViewOutput {
    func pageViewTransitionCompleted() {
        let view = pageView.getCurrentViewController()
        view.output = self
        self.view = view
    }

    func viewIsReady() {
        let day = getDate()
        let weeklyTransactions = interactor.getWeekTransactions(for: day)
        let weekTitle = interactor.getWeekString(for: day)
        view.setupInitialState(using: weeklyTransactions, weekTitle: weekTitle)
    }

    func createTransaction(reason: String, amount: Double) {
        let day = getDate()
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

    func getPreviousWeekViewController() -> WeeklyExpenseViewController {
        let weeklyExpenseVC = WeeklyExpenseViewController()
        weeklyExpenseVC.output = self
        self.view = weeklyExpenseVC
        return weeklyExpenseVC
    }

}

extension WeeklyExpensePresenter: WeeklyExpenseInteractorOutput {
    func pushNewTransaction(_ transaction: Transaction) {
        view.addTransaction(transaction)
    }
}
