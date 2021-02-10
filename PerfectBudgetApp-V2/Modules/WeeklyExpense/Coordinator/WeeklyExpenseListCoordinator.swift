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
        exitMenu()
        let view = GraphViewController()
        navigationController?.pushViewController(view, animated: true)
        configureView()
    }

    func viewSettings() {
        exitMenu()
        let view = SettingsViewController()
        navigationController?.pushViewController(view, animated: true)
        configureView()
    }

    func goHome() {
        navigationController?.popToRootViewController(animated: true)
        configureView()
    }

    @objc func exitMenu() {
        guard let overlay = self.overlay else { return }
        guard let menu = self.menu else { return }
        overlay.fadeOut()
        menu.fadeOut()
    }

    @objc func showMenu() {
        guard let overlay = self.overlay else { return }
        guard let menu = self.menu else { return }
        overlay.fadeIn()
        menu.fadeIn()
    }

    func configureView() {
        guard let view = navigationController?.visibleViewController?.view else { return }
        self.overlay = UIControl()
        self.menu = MenuView()
        guard let overlay = self.overlay else { return }
        guard let menu = self.menu else { return }
        let drawerMenuButton = UIButton()
        let image = UIImage(named: "hamburger-menu-icon-1")
        drawerMenuButton.setImage(image, for: .normal)
        drawerMenuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        drawerMenuButton.accessibilityIdentifier = "Ok"
        view.addSubview(drawerMenuButton)
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
        drawerMenuButton.leadingAnchor == view.safeAreaLayoutGuide.leadingAnchor + 30
        drawerMenuButton.topAnchor == view.safeAreaLayoutGuide.topAnchor + 20
        self.menuButton = drawerMenuButton
        exitMenu()
    }
}

class MenuView: UIView {
    private var menuItems = [String]()
    var coordinator: WeeklyExpenseCoordinator!

    required init?(coder: NSCoder) {
        fatalError("This has not been implementend")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // create menu items
        menuItems.append("Weekly View")
        menuItems.append("Monthly View")
        menuItems.append("Fresh Graphs")
        menuItems.append("User Settings")
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        self.widthAnchor == (UIScreen.main.bounds.size.width / 4) * 3
        self.backgroundColor = .white
        self.addSubview(table)
        table.widthAnchor == self.widthAnchor
        table.topAnchor == self.safeAreaLayoutGuide.topAnchor
        table.heightAnchor == self.safeAreaLayoutGuide.heightAnchor
        table.centerXAnchor == self.centerXAnchor
        table.allowsSelection = true
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
        cell.selectionStyle = .gray
        cell.userInteractionEnabledWhileDragging = true
        return cell
    }


}

extension MenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = menuItems[indexPath.row]
        switch title {
        case "Weekly View":
            coordinator.exitMenu()
            coordinator.goHome()
            return
        case "Monthly View":
            coordinator.exitMenu()
            return
        case "Fresh Graphs":
            coordinator.exitMenu()
            return
        case "User Settings":
            coordinator.viewSettings()
            return
        default:
            print("Nothin but net")
            return
        }
    }

}

extension UIView {

    func fadeIn(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
                          if let complete = onCompletion { complete() }
                       }
        )
    }

    func fadeOut(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
                           self.isHidden = true
                           if let complete = onCompletion { complete() }
                       }
        )
    }

}
