//
//  WeeklyExpenseCoordinator.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/29/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import UIKit
import Foundation

class WeeklyExpenseCoordinator: Coordinator {
    var children = [Coordinator]()
    var navigationController: UINavigationController?

    init(_ navController: UINavigationController) {
        self.navigationController = navController
    }

    func start() {
        let pageView = WeeklyExpensePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        let view = WeeklyExpenseViewController()
        pageView.orderedWeeklyViewControllers = [view]

        let presenter = WeeklyExpensePresenter()
        presenter.view = view
        presenter.pageView = pageView
        presenter.coordinator = self

        let interactor = WeeklyExpenseInteractor()
        interactor.output = presenter
        // this should be a protocol
        interactor.service = TransactionService()

        presenter.interactor = interactor
        view.output = presenter
        pageView.output = presenter

        navigationController?.pushViewController(pageView, animated: false)
    }

    func transactionTapped(_ transaction: Transaction) {
        let view = DetailViewController()
        view.transaction = transaction
        navigationController?.pushViewController(view, animated: true)
    }

    func viewGraphScreen() {
        let view = GraphViewController()
        navigationController?.pushViewController(view, animated: true)
    }
}
