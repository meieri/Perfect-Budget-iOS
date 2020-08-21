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
    // view controllers are ordered by increasing week, this week exists at 0
    var orderedWeeklyViewControllers: [UIViewController]!
    var output: WeeklyExpenseViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstViewController = orderedWeeklyViewControllers.first {
            setViewControllers([firstViewController], direction: .reverse, animated: false, completion: nil)
        }
    }

}

extension WeeklyExpensePageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedWeeklyViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex + 1
        // if there is not a view controller here, we need to create it
        let isIndexValid = orderedWeeklyViewControllers.indices.contains(previousIndex)
        if isIndexValid {
            return orderedWeeklyViewControllers[previousIndex]
        } else {
            let view = output.getPreviousWeekViewController()
            orderedWeeklyViewControllers.append(view)
            return orderedWeeklyViewControllers[previousIndex]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedWeeklyViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex - 1
        guard nextIndex >= 0 else {
            // we are at the current week, and cannot move into the future
            return nil
        }
        return orderedWeeklyViewControllers[nextIndex]
    }
}
