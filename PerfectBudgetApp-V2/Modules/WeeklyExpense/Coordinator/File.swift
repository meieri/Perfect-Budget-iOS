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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

extension SettingsViewController {
    func configureView() {
        let title = UILabel()
        title.text = "Settings"
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.view.addSubview(title)
        title.topAnchor == self.view.topAnchor + 30
    }
}
