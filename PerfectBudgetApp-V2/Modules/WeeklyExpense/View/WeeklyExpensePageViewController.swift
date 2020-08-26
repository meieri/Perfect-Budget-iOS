//
//  WeeklyExpensePageViewController.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 8/8/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import UIKit
import Anchorage
import Foundation

class WeeklyExpensePageViewController: UIPageViewController {
    // view controllers are ordered by increasing week, this week exists at 0
    var orderedWeeklyViewControllers: [UIViewController]!
    var output: WeeklyExpenseViewOutput!
    var drawerMenuButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstViewController = orderedWeeklyViewControllers.first {
            print(firstViewController.view.tag)
            setViewControllers([firstViewController], direction: .reverse, animated: false, completion: nil)
        }
        configureView()
    }

    func configureView() {
        let image = UIImage(named: "hamburger-menu-icon")
        drawerMenuButton.setImage(image, for: .normal)
        drawerMenuButton.tintColor = .black
        drawerMenuButton.accessibilityIdentifier = "Ok"
        view.addSubview(drawerMenuButton)
        drawerMenuButton.leadingAnchor == view.safeAreaLayoutGuide.leadingAnchor + 30
        drawerMenuButton.topAnchor == view.safeAreaLayoutGuide.topAnchor + 20
        view.bringSubviewToFront(drawerMenuButton)
    }

}

// Adding transactions is currently buggy because of this code. We don't shift the interactor's currentDate property without creating a new viewController. So they get initalized just fine, but the currentDate property becomes inconsistent after that.
extension WeeklyExpensePageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // get the view controller index
        guard let viewControllerIndex = orderedWeeklyViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex + 1
        // if there is not a view controller here, we need to create it
        let isIndexValid = orderedWeeklyViewControllers.indices.contains(previousIndex)
        if isIndexValid {
            return orderedWeeklyViewControllers[previousIndex]
        } else {
//            let vc = output.getPreviousWeekViewController(index: previousIndex)
//            orderedWeeklyViewControllers.append(vc)
//            return orderedWeeklyViewControllers[previousIndex]
            return nil
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
//
extension WeeklyExpensePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            output.pageViewTransitionCompleted()
        }
    }
}

extension WeeklyExpensePageViewController: WeeklyExpensePageViewInput {
    func setViewControllers(_ views: [WeeklyExpenseViewController]) {
        print(orderedWeeklyViewControllers.count)
//        orderedWeeklyViewControllers.append(contentsOf: views)
        print(orderedWeeklyViewControllers.count)
    }

    func getCurrentIndex() -> Int {
        return viewControllers?.first?.view.tag ?? 0
    }

    /// TODO make totally safe
    func getCurrentViewController() -> WeeklyExpenseViewController {
        let index = getCurrentIndex()
        return orderedWeeklyViewControllers[index] as! WeeklyExpenseViewController
    }
}
