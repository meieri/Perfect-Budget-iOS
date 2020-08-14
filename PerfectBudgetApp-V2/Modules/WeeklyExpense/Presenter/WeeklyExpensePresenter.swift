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
    var interactor: WeeklyExpenseInteractorInput!
    var coordinator: Coordinator!
}

extension WeeklyExpensePresenter: WeeklyExpenseViewOutput {
    func viewIsReady(currentDate: Date?) {
        if let date = currentDate {
            let weeklyTransactions = interactor.getWeekTransactions(for: date)
            let weekTitle = interactor.getWeekString(for: date)
            view.setupInitialState(using: weeklyTransactions, weekTitle: weekTitle, currentDate: date)
        } else {
            let todaysDate = interactor.getTodaysDate()
            let weeklyTransactions = interactor.getWeekTransactions(for: currentDate)
            let weekTitle = interactor.getWeekString(for: currentDate)
            view.setupInitialState(using: weeklyTransactions, weekTitle: weekTitle, currentDate: currentDate)
        }
    }

    func createTransaction(reason: String, amount: Double) {
        interactor.createTransaction(reason: reason, amount: amount)
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

    func injectLastWeek(weeklyExpenseVC: WeeklyExpenseViewController,
                        from date: Date) -> WeeklyExpenseViewController {
        weeklyExpenseVC.currentDate = date.startOfPreviousWeek
        weeklyExpenseVC.output = self
        self.view = weeklyExpenseVC
        return weeklyExpenseVC
    }

    func injectNextWeek(weeklyExpenseVC: WeeklyExpenseViewController,
                        from date: Date) -> WeeklyExpenseViewController {
        weeklyExpenseVC.currentDate = date.startOfNextWeek
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
