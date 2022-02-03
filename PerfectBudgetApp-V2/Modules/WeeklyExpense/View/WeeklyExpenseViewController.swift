//
//  WeeklyExpenseViewController.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import UIKit
import Anchorage

class WeeklyExpenseViewController: UIViewController {

    var output: WeeklyExpenseViewOutput!
    var tableView = UITableView()
    var titleProgressView = TitleProgressContainerView()
    var transactions: [Transaction] = []
    let addTransactionButton = UIButton(type: .roundedRect)
    let editTransactionButton = UIButton(type: .system)
    let settingsButton = UIButton()

    var currentSpending: Double {
        get {
            var spending = 0.0
            for transaction in transactions {
                spending += transaction.amount
            }
            return spending
        }
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    @objc func settingsButtonTapped() {
        output.showSettings()
    }

    @objc func showInputDialog() {
        let alertController = UIAlertController(title: "Enter details of transaction?", message: "Enter your reason and amount", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { [weak self] (_) in
            let reason = alertController.textFields?[0].text
            let amount = alertController.textFields?[1].text
            // so crazy safe
            if let amount = amount, let reason = reason {
                // called 'nil coalescing'
                let numAmount = Double(amount) ?? 0.0
                self?.output.createTransaction(reason: reason, amount: numAmount)
            } else {
                self?.output.errorCreatingTransaction()
            }
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Reason"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Amount"
        }
        let denyAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in return }
        alertController.addAction(confirmAction)
        alertController.addAction(denyAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // refreshes everything that changes
    func refresh() {
        transactions.removeAll { $0.amount == 0.0 && $0.reason == nil} // purgeEmptyTransactions
        self.tableView.reloadData()
        self.titleProgressView.setSpendingValues(currSpend: currentSpending)
    }

}

extension WeeklyExpenseViewController {
    func configureView() {
        // Heirarchy
        let mainStack = UIStackView(arrangedSubviews: [titleProgressView, tableView])
        self.view.addSubview(mainStack)
        self.view.addSubview(addTransactionButton)
        self.view.addSubview(settingsButton)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "TransactionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        addTransactionButton.addTarget(self, action: #selector(showInputDialog), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        // Style
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 20
        let attrString = NSAttributedString(string: "New Expense", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.white
            ]
        )
        addTransactionButton.setAttributedTitle(attrString, for: .normal)
        addTransactionButton.backgroundColor = .black
        addTransactionButton.layer.cornerRadius = 8.0
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        let settingsButtonImage = UIImage(named: "hamburger-menu-icon-1")
        settingsButton.setImage(settingsButtonImage, for: .normal)
        // Layout
        titleProgressView.widthAnchor == view.safeAreaLayoutGuide.widthAnchor - 40
        mainStack.topAnchor == view.safeAreaLayoutGuide.topAnchor + 15
        mainStack.centerAnchors == view.centerAnchors
        addTransactionButton.topAnchor == mainStack.bottomAnchor - 20
        addTransactionButton.leadingAnchor == view.safeAreaLayoutGuide.leadingAnchor + 25
        addTransactionButton.trailingAnchor == view.safeAreaLayoutGuide.trailingAnchor - 25
        addTransactionButton.heightAnchor == 40
        tableView.widthAnchor == mainStack.widthAnchor / 8 * 7
        settingsButton.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor + 20
        settingsButton.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 10
    }
}

extension WeeklyExpenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        cell.textLabel?.text = transactions[indexPath.row].reason
        let amount = WeeklyExpenseViewController.getAmountString(amount: transactions[indexPath.row].amount)
        cell.detailTextLabel?.text = "\(amount)"
        cell.detailTextLabel?.textColor = .darkGray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            output.deleteTransaction(transaction: transactions[indexPath.row])
            self.transactions.remove(at: indexPath.row)
            refresh()
        }
    }

    static func getAmountString(amount: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current

        if let priceString = currencyFormatter.string(from: NSNumber(value: amount)) {
            return priceString
        } else {
            return ""
        }
    }
}



extension WeeklyExpenseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedTransaction = transactions[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        output.transactionTapped(tappedTransaction)
    }
}

// MARK: WeeklyExpenseViewInput
extension WeeklyExpenseViewController: WeeklyExpenseViewInput {

    func setupInitialState(using weeklyTransactions: [Transaction], weekTitle: String) {
        self.transactions = weeklyTransactions
        self.titleProgressView.showWeekTitle(title: weekTitle)
        refresh()
    }

    func addTransaction(_ transaction: Transaction) {
        self.transactions.append(transaction)
        refresh()
    }

    func requestRefresh() {
        refresh()
    }
}


class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
