//
//  WeeklyExpenseInteractorInput.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import Foundation

protocol WeeklyExpenseInteractorInput {
    func createTransaction(reason: String, amount: Double)
    func deleteTransaction(_ transaction: Transaction)
    func getWeeklyTransactions() -> [Transaction]
}
