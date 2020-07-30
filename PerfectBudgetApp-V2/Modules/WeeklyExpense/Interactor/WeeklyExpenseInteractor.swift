//
//  WeeklyExpenseInteractor.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

class WeeklyExpenseInteractor: WeeklyExpenseInteractorInput {
    weak var output: WeeklyExpenseInteractorOutput!
    var service: TransactionServiceProtocol!

    func createTransaction(reason: String, amount: Double) {
        let newTransaction = service.createTransaction(reason: reason, amount: amount)
        output.pushNewTransaction(newTransaction)
    }

}
