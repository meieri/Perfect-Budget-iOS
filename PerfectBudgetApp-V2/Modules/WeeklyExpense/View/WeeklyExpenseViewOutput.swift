//
//  WeeklyExpenseViewOutput.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//
import UIKit
import Foundation

protocol WeeklyExpenseViewOutput {

    /**
        @author Isaak Meier
        Notify presenter that view is ready
    */
    func viewIsReady(tag: Int)
    func createTransaction(reason: String, amount: Double)
    func errorCreatingTransaction()
    func showGraphScreen()
    func transactionTapped(_ transaction: Transaction)
    func deleteTransaction(transaction: Transaction)
    func getPreviousWeekViewController(index: Int) -> WeeklyExpenseViewController
    func pageViewTransitionCompleted()
}
