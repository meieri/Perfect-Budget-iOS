//
//  WeeklyExpenseViewOutput.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//
import Foundation

protocol WeeklyExpenseViewOutput {

    /**
        @author Isaak Meier
        Notify presenter that view is ready
    */
    func viewIsReady(currentDate: Date?)
    func createTransaction(reason: String, amount: Double)
    func errorCreatingTransaction()
    func showGraphScreen()
    func transactionTapped(_ transaction: Transaction)
    func deleteTransaction(transaction: Transaction)
    func injectLastWeek(weeklyExpenseVC: WeeklyExpenseViewController, from date: Date) -> WeeklyExpenseViewController
    func injectNextWeek(weeklyExpenseVC: WeeklyExpenseViewController, from date: Date) -> WeeklyExpenseViewController
}
