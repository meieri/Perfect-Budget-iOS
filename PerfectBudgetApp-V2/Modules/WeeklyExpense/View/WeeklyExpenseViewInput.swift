//
//  WeeklyExpenseListViewInput.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//
import Foundation

protocol WeeklyExpenseViewInput: class {

    /**
        @author Isaak Meier
        Setup initial state of the view
    */

    func setupInitialState(using weeklyTransactions: [Transaction], weekTitle: String, currentDate: Date)
    func addTransaction(_ transaction: Transaction)
}
