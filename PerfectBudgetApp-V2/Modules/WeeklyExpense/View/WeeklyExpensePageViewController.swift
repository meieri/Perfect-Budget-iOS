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
    private var currentIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
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
            currentIndex = previousIndex
            return orderedWeeklyViewControllers[previousIndex]
        } else {
            let view = output.getPreviousWeekViewController()
            orderedWeeklyViewControllers.append(view)
            currentIndex = previousIndex
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
        currentIndex = nextIndex
        return orderedWeeklyViewControllers[nextIndex]
    }
}

extension WeeklyExpensePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let vc = viewControllers?.first else { return }
            currentIndex = orderedWeeklyViewControllers.firstIndex(of: vc) ?? 0
            output.pageViewTransitionCompleted()
            print(self.currentIndex)
        }
    }
}

extension WeeklyExpensePageViewController: WeeklyExpensePageViewInput {
    func getCurrentIndex() -> Int {
        return currentIndex
    }

    /// TODO make totally safe
    func getCurrentViewController() -> WeeklyExpenseViewController {
        guard let view = viewControllers?.first else {
                return orderedWeeklyViewControllers[0] as! WeeklyExpenseViewController
        }
        return view as! WeeklyExpenseViewController
    }

}
