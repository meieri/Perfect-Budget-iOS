//
//  DetailViewController.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/21/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import UIKit
import Anchorage
import Foundation

class DetailViewController: UIViewController {
    // this should be abstracted away by a DetailPresenter
    var coordinator: WeeklyExpenseCoordinator!
    var transaction: Transaction!
    var service: TransactionServiceProtocol!
    private var reason: String!
    private var backButton = UIButton(type: .close)
    private var deleteButton = UIButton(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reason = transaction.reason
        configureView()
    }

    @objc func returnHome(sender: UIButton) {
        coordinator.navigationController?.popViewController(animated: true)
    }

    @objc func deleteTransaction(sender: UIButton) {
        service.deleteTransaction(transaction: self.transaction)
        returnHome(sender: sender)
    }

}

extension DetailViewController {
    func configureView() {
        // Heirarchy
        let reasonLabel = UILabel()
        view.addSubview(reasonLabel)
        view.addSubview(backButton)
        view.addSubview(deleteButton)

        // Style
        view.backgroundColor = .white
        reasonLabel.text = self.reason
        deleteButton.backgroundColor = .red
        backButton.addTarget(self, action: #selector(returnHome), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTransaction), for: .touchUpInside)

        // Layout
        reasonLabel.centerXAnchor == self.view.centerXAnchor
        reasonLabel.centerYAnchor == self.view.centerYAnchor

        backButton.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 20
        backButton.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor + 20

        deleteButton.topAnchor == reasonLabel.bottomAnchor + 20
        deleteButton.widthAnchor == reasonLabel.widthAnchor * 2
        deleteButton.heightAnchor == reasonLabel.widthAnchor
        deleteButton.centerXAnchor == reasonLabel.centerXAnchor
    }
}
