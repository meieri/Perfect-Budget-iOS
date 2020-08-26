//
//  WeeklyExpensePageViewInput.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 8/23/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import Foundation

protocol WeeklyExpensePageViewInput: class {
    func getCurrentIndex() -> Int
    func getCurrentViewController() -> WeeklyExpenseViewController
    func setViewControllers(_ views: [WeeklyExpenseViewController])
}
