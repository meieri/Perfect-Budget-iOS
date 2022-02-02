//
//  WeeklyExpenseInteractorOutput.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import Foundation

protocol WeeklyExpenseInteractorOutput: AnyObject {
    func pushNewTransaction(_ transaction: Transaction)
}
