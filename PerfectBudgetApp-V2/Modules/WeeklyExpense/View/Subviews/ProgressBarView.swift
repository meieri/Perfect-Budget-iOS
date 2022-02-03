//
//  ProgressBarView.swift
//  Perfect Budget
//
//  Created by Isaak Meier on 7/11/19.
//  Copyright © 2019 Isaak Meier. All rights reserved.
//
import UIKit
import Anchorage
import Foundation

class ProgressBarView: UIView {
    private var progressBar = UIProgressView()
    private var currSpendLabel = UILabel()
    private var maxSpendLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureTrack()
    }

    func setSpendingValues(currSpend: Double) {
        var maxSpend = UserDefaults.standard.double(forKey: "maxSpendingPerWeek")
        if (maxSpend == 0) { maxSpend = 300.0 }
        currSpendLabel.text = String(format: "$%.02f", currSpend)
        maxSpendLabel.text = String(format: "$%.02f", maxSpend)


        UIView.animate(withDuration: 0.4, animations: {
            self.progressBar.setProgress(Float(currSpend/maxSpend), animated: true)
            self.layoutIfNeeded()
        })
        configureCurrentProgress()
    }
}

private extension ProgressBarView {
    func configureView() {

        // View Heirarchy
        self.addSubview(progressBar)
        self.addSubview(currSpendLabel)
        self.addSubview(maxSpendLabel)

        // Style -- rounded corners for the progess bar (among other things) handled by the configureTrack function
        progressBar.layer.cornerRadius = 16.0
        progressBar.clipsToBounds = true
        progressBar.heightAnchor == 40
        configureTrack()
        currSpendLabel.adjustsFontForContentSizeCategory = true
        maxSpendLabel.adjustsFontForContentSizeCategory = true

        // Layout
        progressBar.topAnchor == self.topAnchor
        progressBar.leadingAnchor == self.leadingAnchor
        progressBar.trailingAnchor == self.trailingAnchor
        currSpendLabel.topAnchor == progressBar.bottomAnchor + 5

        maxSpendLabel.topAnchor == progressBar.bottomAnchor + 5
        maxSpendLabel.centerXAnchor == progressBar.trailingAnchor - 20

        self.heightAnchor == maxSpendLabel.heightAnchor + 45
    }

    func configureTrack() {
        let newSize = CGSize(width: 140, height: 40)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        let baseImg: UIImage = renderer.image { (context) in
            context.stroke(renderer.format.bounds)
            UIColor.black.setFill()
            context.fill(CGRect(x: 1, y: 1, width: newSize.width, height: newSize.height))
        }
        let threeSlice = baseImg.roundedImage.resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 25, bottom: 0, right: 35))
        progressBar.progressImage = threeSlice
        configureCurrentProgress()
    }

    func configureCurrentProgress() {
        DispatchQueue.main.async {
            var multiplier: Float
            if self.progressBar.progress == 1.0 {
                multiplier = 0.20
                self.maxSpendLabel.isHidden = true
            }
            else if self.progressBar.progress < 0.2 {
                multiplier = 0.20
                self.maxSpendLabel.isHidden = false
            }
            else if self.progressBar.progress > 0.8 {
                multiplier = 0.85
                self.maxSpendLabel.isHidden = false
            }
            else {
                multiplier = self.progressBar.progress
                self.maxSpendLabel.isHidden = false
            }
            print(multiplier)
            self.currSpendLabel.trailingAnchor == (self.trailingAnchor * multiplier) - 15
        }
    }
}

extension UIImage {
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 16.0
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

