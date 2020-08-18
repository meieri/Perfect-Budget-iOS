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
    func viewIsReady() {
        let day = interactor.getCurrentDay()
        let weeklyTransactions = interactor.getWeekTransactions(for: day)
        let weekTitle = interactor.getWeekString(for: day)
        view.setupInitialState(using: weeklyTransactions, weekTitle: weekTitle)
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

    func getViewControllerBefore() -> WeeklyExpenseViewController? {
        if interactor.moveCurrentDateBy(week: -1) {
            let weeklyExpenseVC = WeeklyExpenseViewController()
            weeklyExpenseVC.output = self
            self.view = weeklyExpenseVC
            return weeklyExpenseVC
        }
        return nil
    }

    func getViewControllerAfter() -> WeeklyExpenseViewController? {
        if interactor.moveCurrentDateBy(week: 1) {
            let weeklyExpenseVC = WeeklyExpenseViewController()
            weeklyExpenseVC.output = self
            self.view = weeklyExpenseVC
            return weeklyExpenseVC
        }
        return nil
    }

}

extension WeeklyExpensePresenter: WeeklyExpenseInteractorOutput {
    func pushNewTransaction(_ transaction: Transaction) {
        view.addTransaction(transaction)
    }
}
