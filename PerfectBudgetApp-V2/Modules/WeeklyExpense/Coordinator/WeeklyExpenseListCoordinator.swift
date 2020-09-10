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
    private var overlay: UIControl?
    private var menu: MenuView?
    private var menuButton: UIButton?

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
        let service = TransactionService()
        interactor.service = service
        self.service = service

        presenter.interactor = interactor
        view.output = presenter
        pageView.output = presenter
        view.view.tag = 0

        navigationController?.pushViewController(pageView, animated: false)
        presenter.generateViewControllers()
        configureView()
    }

    func transactionTapped(_ transaction: Transaction) {
        let view = DetailViewController()
        view.transaction = transaction
        view.coordinator = self
        view.service = self.service
        navigationController?.pushViewController(view, animated: true)
    }

    func viewGraphScreen() {
        let view = GraphViewController()
        navigationController?.pushViewController(view, animated: true)
    }

    @objc func exitMenu() {
        guard let overlay = self.overlay else { return }
        guard let menu = self.menu else { return }
        guard let menuButton = self.menuButton else { return }
        overlay.isHidden = true
        menu.isHidden = true
        menuButton.isHidden = false
    }

    @objc func showMenu() {
        guard let overlay = self.overlay else { return }
        guard let menu = self.menu else { return }
        guard let menuButton = self.menuButton else { return }
        overlay.isHidden = false
        menu.isHidden = false
        menuButton.isHidden = true
    }

    func configureView() {
        guard let view = navigationController?.view else { return }
        self.overlay = UIControl()
        self.menu = MenuView()
        guard let overlay = self.overlay else { return }
        guard let menu = self.menu else { return }
        view.addSubview(overlay)
        view.addSubview(menu)
        overlay.backgroundColor = .gray
        overlay.alpha = 0.5
        overlay.addTarget(self, action: #selector(exitMenu), for: UIControl.Event.touchUpInside)
        overlay.topAnchor == view.topAnchor
        overlay.bottomAnchor == view.bottomAnchor
        overlay.leadingAnchor == view.leadingAnchor
        overlay.trailingAnchor == view.trailingAnchor
        menu.coordinator = self
        menu.topAnchor == view.topAnchor
        menu.bottomAnchor == view.bottomAnchor
        menu.leadingAnchor == view.leadingAnchor
        let drawerMenuButton = UIButton()
        let image = UIImage(named: "hamburger-menu-icon-1")
        drawerMenuButton.setImage(image, for: .normal)
        drawerMenuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        drawerMenuButton.accessibilityIdentifier = "Ok"
        view.addSubview(drawerMenuButton)
        drawerMenuButton.leadingAnchor == view.safeAreaLayoutGuide.leadingAnchor + 30
        drawerMenuButton.topAnchor == view.safeAreaLayoutGuide.topAnchor + 20
        view.bringSubviewToFront(drawerMenuButton)
        self.menuButton = drawerMenuButton
        exitMenu()
    }
}

class MenuView: UIView {
    private var menuItems = [String]()
    var coordinator: WeeklyExpenseCoordinator!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.widthAnchor == 4 * UIScreen.main.bounds.size.width / 3
        self.heightAnchor == UIScreen.main.bounds.size.height
        self.backgroundColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        let animator = UIViewPropertyAnimator()
        menuItems.append("Weekly View")
        menuItems.append("Monthly View")
        menuItems.append("Fresh Graphs")
        self.widthAnchor == (UIScreen.main.bounds.size.width / 4) * 3
        self.heightAnchor == UIScreen.main.bounds.size.height
        self.backgroundColor = .white
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        self.addSubview(table)
        table.widthAnchor == self.widthAnchor
        table.topAnchor == self.safeAreaLayoutGuide.topAnchor
        table.heightAnchor == self.safeAreaLayoutGuide.heightAnchor
        table.centerXAnchor == self.centerXAnchor
    }


}

extension MenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // count for number of array items
        self.menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Menu Item")
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.detailTextLabel?.text = "Go to this"
        return cell
    }


}

extension MenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = menuItems[indexPath.row]
        switch title {
        case "Weekly View":
            coordinator.start()
            coordinator.exitMenu()
        case "Monthly View":
            print("Month")
            coordinator.exitMenu()
        case "Fresh Graphs":
            coordinator.viewGraphScreen()
            coordinator.exitMenu()
        default:
            print("Nothin but net")
        }
    }

}
