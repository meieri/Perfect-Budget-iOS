//
//  MainCoordinator.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/21/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import UIKit
import Foundation

class MainCoordinator: Coordinator {
    var children = [Coordinator]()
    var navigationController: UINavigationController?

    init(navController: UINavigationController) {
        self.navigationController = navController
    }

    func start() {
        let service = TransactionService()
        let view = HomeScreenViewController()
        view.service = service
        view.coordinator = self
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
