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
        // get week string and transactions for today
        let weeklyTransactions = interactor.getWeekTransactions(for: Date())
        let weekTitle = interactor.getWeekString(for: Date())
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
}

extension WeeklyExpensePresenter: WeeklyExpenseInteractorOutput {
    func pushNewTransaction(_ transaction: Transaction) {
        view.addTransaction(transaction)
    }
}
