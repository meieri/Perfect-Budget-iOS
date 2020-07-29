//
//  WeeklyExpenseListWeeklyExpenseListInitializer.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import UIKit

class WeeklyExpenseListModuleInitializer: NSObject {

//    override func awakeFromNib() {
    // Takes in the navigationController set as the roow window in sceneDelegate
    func initialize(_ navigationController: UINavigationController) {
        let configurator = WeeklyExpenseListModuleConfigurator() 
        configurator.configureModuleForViewInput(viewInput: navigationController)
    }

}
