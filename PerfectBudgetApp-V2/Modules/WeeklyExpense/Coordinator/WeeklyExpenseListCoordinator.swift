//
//  WeeklyExpenseCoordinator.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/29/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import UIKit
import Anchorage
import Foundation

class WeeklyExpenseCoordinator: Coordinator {

    var children = [Coordinator]()
    var navigationController: UINavigationController?
    private var service: TransactionService!
    private var presenter: WeeklyExpensePresenter!

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
        self.presenter = presenter

        let interactor = WeeklyExpenseInteractor()
        interactor.output = presenter

        let service = TransactionService()
        interactor.service = service
        self.service = service

        presenter.interactor = interactor
        view.output = presenter
        pageView.output = presenter
        view.view.tag = 0

        navigationController?.pushViewController(pageView, animated: false)
        presenter.generateViewControllers()
    }

    func transactionTapped(_ transaction: Transaction) {
        let view = DetailViewController()
        view.transaction = transaction
        view.coordinator = self
        view.service = self.service
        navigationController?.pushViewController(view, animated: true)
    }

    @objc func showSettingsScreen() {
        let view = SettingsViewController()
        view.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        view.coordinator = self
        navigationController?.present(view, animated: true, completion: nil)
    }

    func goHome() {
        navigationController?.popToRootViewController(animated: true)
    }

    func requestRefresh() {
        self.presenter.requestViewRefresh()
    }

}

