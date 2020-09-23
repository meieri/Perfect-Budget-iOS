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

    private let weekTitle = UILabel()
    private let weeklySpending = UILabel()
    private let progressBar = ProgressBarView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showWeekTitle(title: String) {
        weekTitle.text = title
    }

    func setSpendingValues(currSpend: Double, maxSpend: Double) {
        self.progressBar.setSpendingValues(currSpend: currSpend, maxSpend: maxSpend)
    }
}

private extension TitleProgressContainerView {


    func configureView() {

        // View Heirarchy
        let left = UIImage(systemName: "arrow.backward")
        let right = UIImage(systemName: "arrow.forward")
        let leftArrow = UIImageView(image: left)
        let rightArrow = UIImageView(image: right)
        let mainStack = UIStackView(arrangedSubviews: [weekTitle, weeklySpending, progressBar])
        self.addSubview(mainStack)
        self.addSubview(leftArrow)
        self.addSubview(rightArrow)

        // Style
        weekTitle.textColor = .black
        weekTitle.adjustsFontForContentSizeCategory = true
        weekTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        weekTitle.addCharacterSpacing(kernValue: 0.3)
        weeklySpending.adjustsFontForContentSizeCategory = true
        weeklySpending.text = "Weekly Spending"
        weeklySpending.setContentHuggingPriority(UILayoutPriority(751), for: .vertical)
        mainStack.axis = .vertical
        mainStack.distribution = .fillProportionally
        mainStack.alignment = .center
        mainStack.spacing = 20

        // Layout
        progressBar.widthAnchor == mainStack.widthAnchor / 10 * 9
        mainStack.topAnchor == self.topAnchor
        mainStack.leadingAnchor == self.leadingAnchor
        mainStack.trailingAnchor == self.trailingAnchor
        self.heightAnchor == mainStack.heightAnchor
        leftArrow.trailingAnchor == weekTitle.leadingAnchor
        leftArrow.heightAnchor == leftArrow.widthAnchor
        leftArrow.heightAnchor == 10
        rightArrow.leadingAnchor == weekTitle.trailingAnchor
        rightArrow.heightAnchor == rightArrow.widthAnchor
        rightArrow.heightAnchor == 10
    }
}

extension UILabel {
  func addCharacterSpacing(kernValue: Double = 1.15) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
