//
//  WeeklyExpenseListWeeklyExpenseListPresenter.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

class WeeklyExpenseListPresenter: WeeklyExpenseListModuleInput, WeeklyExpenseListViewOutput {
    weak var view: WeeklyExpenseListViewInput!
    var interactor: WeeklyExpenseListInteractorInput!
    var coordinator: Coordinator!

    func viewIsReady() {
        
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

}

extension WeeklyExpenseListPresenter: WeeklyExpenseListInteractorOutput {
    func pushNewTransaction(_ transaction: Transaction) {
        view.addTransaction(transaction)
    }
}
