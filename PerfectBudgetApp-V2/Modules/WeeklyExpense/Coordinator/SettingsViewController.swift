//
//  File.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 9/22/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import Foundation
import UIKit
import Anchorage

class SettingsViewController: UIViewController {
    let spendingTextField = UITextField()
    var coordinator: Coordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        guard var newMaxSpendingStr = spendingTextField.text else { return }
        newMaxSpendingStr.remove(at: newMaxSpendingStr.startIndex)
        let newMaxSpendingAmount = Double(newMaxSpendingStr) ?? 0.0
        let currSpendingAmount = UserDefaults.standard.double(forKey: "maxSpendingPerWeek")
        if (newMaxSpendingAmount >= 0 && newMaxSpendingAmount != currSpendingAmount) {
            UserDefaults.standard.set(newMaxSpendingAmount, forKey: "maxSpendingPerWeek")
        }
        self.coordinator?.requestRefresh()
    }
}

extension SettingsViewController {
    func configureView() {
        self.view.backgroundColor = .white
        let title = UILabel()
        title.text = "Settings"
        title.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        self.view.addSubview(title)
        title.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 30
        title.centerXAnchor == self.view.centerXAnchor

        let spendingTitle = UILabel()
        spendingTitle.text = "Maximum spending per week: "
        spendingTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.view.addSubview(spendingTitle)
        spendingTitle.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor + 25
        spendingTitle.topAnchor == title.bottomAnchor + 45

        var spendingAmount = UserDefaults.standard.double(forKey: "maxSpendingPerWeek")
        if (spendingAmount == 0) { spendingAmount = 300.0 }
        spendingTextField.text = String(format: "$%.1f", spendingAmount)
        self.view.addSubview(spendingTextField)
        spendingTextField.leadingAnchor == spendingTitle.trailingAnchor + 5
        spendingTextField.trailingAnchor == self.view.safeAreaLayoutGuide.trailingAnchor - 30
        spendingTextField.centerYAnchor == spendingTitle.centerYAnchor
        spendingTextField.textAlignment = .left
    }
}
