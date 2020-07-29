//
//  WeeklyExpenseListCoordinator.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/29/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import UIKit
import Foundation

class WeeklyExpenseListCoordinator: Coordinator {
    var children = [Coordinator]()
    var navigationController: UINavigationController?

    init(_ navController: UINavigationController) {
        self.navigationController = navController
    }

    func start() {
        let view = WeeklyExpenseListViewController()

        let presenter = WeeklyExpenseListPresenter()
        presenter.view = view
        presenter.coordinator = self

        let interactor = WeeklyExpenseListInteractor()
        interactor.output = presenter
        // this should be a protocol
        interactor.service = TransactionService()

        presenter.interactor = interactor
        view.output = presenter

        navigationController?.pushViewController(view, animated: false)
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
