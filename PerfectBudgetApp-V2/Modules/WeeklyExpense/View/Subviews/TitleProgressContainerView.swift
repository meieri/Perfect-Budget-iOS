//
//  TitleProgressContainerView.swift
//  Perfect Budget
//
//  Created by Isaak Meier on 7/11/19.
//  Copyright © 2019 Isaak Meier. All rights reserved.
//

import Foundation
import UIKit
import Anchorage

class TitleProgressContainerView: UIView {

    private let dayName = UILabel()
    private let dailySpending = UILabel()
    private let addCash = UIButton()
    private let progressBar: ProgressBarView

    override init(frame: CGRect) {
        self.progressBar = ProgressBarView()
        super.init(frame: frame)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showDayOfWeek(day: String) {
        dayName.text = day
    }

    func setSpendingValues(currSpend: Double, maxSpend: Double) {
        self.progressBar.setSpendingValues(currSpend: currSpend, maxSpend: maxSpend)
    }
}

private extension TitleProgressContainerView {

    func configureView() {

        // View Heirarchy
        // self.addSubview(addCash)
        self.addSubview(dayName)
        self.addSubview(progressBar)
        self.addSubview(dailySpending)

        // Style
        dayName.textColor = .black
        dayName.adjustsFontForContentSizeCategory = true
        dailySpending.adjustsFontForContentSizeCategory = true
        dailySpending.text = "Weekly Spending"

        // Layout
        // Center in the middle of the screen
        dayName.centerXAnchor == self.centerXAnchor
        progressBar.centerXAnchor == self.centerXAnchor
        // Move a nice distance from the top
        dayName.topAnchor == self.topAnchor + 50
        progressBar.topAnchor == dayName.bottomAnchor + 50
        progressBar.widthAnchor == self.widthAnchor - 20
        progressBar.heightAnchor == self.heightAnchor / 6

        dailySpending.leadingAnchor == self.leadingAnchor + 10
        dailySpending.bottomAnchor == progressBar.topAnchor - 10

    }
}
