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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }

}

extension WeeklyExpensePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return output.getViewControllerBefore()
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return output.getViewControllerAfter()
    }
}
