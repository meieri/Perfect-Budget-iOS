//
//  WeeklyExpenseListWeeklyExpenseListViewOutput.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

protocol WeeklyExpenseListViewOutput {

    /**
        @author Isaak Meier
        Notify presenter that view is ready
    */

    func viewIsReady()
    func createTransaction(reason: String, amount: Double)
    func errorCreatingTransaction()
    func showGraphScreen()
}
