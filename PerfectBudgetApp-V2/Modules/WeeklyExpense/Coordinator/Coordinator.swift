//
//  Coordinator.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/21/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }

    func start()
    func transactionTapped(_ transaction: Transaction)
    func viewGraphScreen()
    func showMenu()
}
