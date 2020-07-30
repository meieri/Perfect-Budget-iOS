//
//  WeeklyExpenseInteractor.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//
import Foundation

class WeeklyExpenseInteractor: WeeklyExpenseInteractorInput {
    weak var output: WeeklyExpenseInteractorOutput!
    var service: TransactionServiceProtocol!

    func createTransaction(reason: String, amount: Double) {
        let newTransaction = service.createTransaction(reason: reason, amount: amount)
        output.pushNewTransaction(newTransaction)
    }

    func deleteTransaction(_ transaction: Transaction) {
        service.deleteTransaction(transaction: transaction)
    }

    func getWeeklyTransactions() -> [Transaction] {
        let allTransactions = service.fetchTransactions()
        let calendar = Calendar.current
        let todaysDate = Date()

        // Filters based on if date is in this week.
        // TODO make date no longer optional
        return allTransactions.filter { calendar.isDate($0.date ?? Date.distantFuture, equalTo: todaysDate, toGranularity: .weekOfYear) }
    }

}
