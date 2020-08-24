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
    private var backButton = UIButton(type: .close)

    override func viewDidLoad() {
        super.viewDidLoad()
        let reason = transaction?.reason
        configureView(reason)
    }

    @objc func returnHome(sender: UIButton) {
        coordinator.navigationController?.popViewController(animated: true)
    }

}

extension DetailViewController {
    func configureView(_ reason: String?) {
        if let reason = reason {
            // Style
            view.backgroundColor = .white
            let reasonLabel = UILabel()
            reasonLabel.text = reason
            backButton.addTarget(self, action: #selector(returnHome), for: .touchUpInside)

            // Heirarchy
            view.addSubview(reasonLabel)
            view.addSubview(backButton)

            // Layout
            reasonLabel.centerXAnchor == self.view.centerXAnchor
            reasonLabel.centerYAnchor == self.view.centerYAnchor

            backButton.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 20
            backButton.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor + 20
        }
    }
}
