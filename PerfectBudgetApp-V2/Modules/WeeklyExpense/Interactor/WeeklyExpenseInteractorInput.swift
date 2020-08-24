//
//  WeeklyExpenseInteractorInput.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import Foundation

protocol WeeklyExpenseInteractorInput {
    func createTransaction(reason: String, amount: Double, day: Date)
    func deleteTransaction(_ transaction: Transaction)
    // return based on the week surrounding the given day
    func getWeekTransactions(for day: Date) -> [Transaction]
    func getWeekString(for day: Date) -> String
    func getCurrentDateMovedBy(week: Int) -> Date
}
