//
//  WeeklyExpenseListWeeklyExpenseListConfigurator.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import UIKit

class WeeklyExpenseListModuleConfigurator {

//    func configureModuleForViewInput<UINavigationController>(viewInput: UIViewController) {
    func configureModuleForViewInput(viewInput: UINavigationController) {
//        if let viewController = viewInput as? WeeklyExpenseListViewController {
        configure(viewController: viewInput)
    }

    private func configure(viewController: WeeklyExpenseListViewController) {

        let router = WeeklyExpenseListRouter()

        let presenter = WeeklyExpenseListPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WeeklyExpenseListInteractor()
        interactor.output = presenter
        // this should be a protocol
        interactor.service = TransactionService()

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
