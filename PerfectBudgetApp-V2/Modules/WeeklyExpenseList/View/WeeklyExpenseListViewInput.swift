//
//  WeeklyExpenseListWeeklyExpenseListViewInput.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

protocol WeeklyExpenseListViewInput: class {

    /**
        @author Isaak Meier
        Setup initial state of the view
    */

    func setupInitialState()
    func addTransaction(_ transaction: Transaction)
}
