//
//  GraphViewController.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/26/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        configureView()
    }

}

extension GraphViewController {
    func configureView() {
        self.title = "Graphs"
    }
}
