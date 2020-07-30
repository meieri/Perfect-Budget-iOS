//
//  WeeklyExpensePresenter.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

class WeeklyExpensePresenter {
    weak var view: WeeklyExpenseViewInput!
    var interactor: WeeklyExpenseInteractorInput!
    var coordinator: Coordinator!

}

extension WeeklyExpensePresenter: WeeklyExpenseViewOutput {
    func viewIsReady() {
        let weeklyTransactions = interactor.getWeeklyTransactions()
        view.setupInitialState(using: weeklyTransactions)
    }

    func createTransaction(reason: String, amount: Double) {
        interactor.createTransaction(reason: reason, amount: amount)
    }

    func errorCreatingTransaction() {
        //
    }

    func showGraphScreen() {
        //
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
