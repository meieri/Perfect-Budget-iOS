//
//  WeeklyExpensePageViewController.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 8/8/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import UIKit
import Foundation

class WeeklyExpensePageViewController: UIPageViewController {
    var output: WeeklyExpenseViewOutput!
    var currentView: WeeklyExpenseViewController!

    override func viewDidLoad() {
        configureView()
    }

}

extension WeeklyExpensePageViewController {
    func configureView() {
        // Heirarchy
        self.dataSource = self
        self.setViewControllers([currentView], direction: .forward, animated: true, completion: nil)
    }
}

extension WeeklyExpensePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let date = currentView.currentDate else { return nil }
        let injectedCopy = output.injectLastWeek(weeklyExpenseVC: currentView.copy() as! WeeklyExpenseViewController, from: date)
        self.currentView = injectedCopy
        return injectedCopy
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let date = currentView.currentDate else { return nil }
        let injectedCopy = output.injectNextWeek(weeklyExpenseVC: currentView.copy() as! WeeklyExpenseViewController, from: date)
        self.currentView = injectedCopy
        return injectedCopy
    }
}
