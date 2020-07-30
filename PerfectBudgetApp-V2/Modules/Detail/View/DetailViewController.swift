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
    var transaction: Transaction!

    override func viewDidLoad() {
        super.viewDidLoad()
        let reason = transaction?.reason
        configureView(reason)
    }

}

extension DetailViewController {
    func configureView(_ reason: String?) {
        if let reason = reason {
            view.backgroundColor = .white
            let reasonLabel = UILabel()
            reasonLabel.text = reason
            view.addSubview(reasonLabel)

            reasonLabel.centerXAnchor == self.view.centerXAnchor
            reasonLabel.centerYAnchor == self.view.centerYAnchor
        }
    }
}
