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
    // return based on the week surrounding the given day
    func getWeekTransactions() -> [Transaction]
    func getWeekString() -> String
    func getCurrentDay() -> Date
    func moveCurrentDateBy(week: Int) 
}
