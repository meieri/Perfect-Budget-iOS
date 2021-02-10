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
    let navigateToGraphs = UIButton(type: .system)

    var currentSpending: Double {
        get {
            var spending = 0.0
            for transaction in transactions {
                spending += transaction.amount
            }
            return spending
        }
    }

    override var navigationItem: UINavigationItem {
        get {
            let navigationItem = UINavigationItem()
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showMenu))
//            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: image, style: .plain, target: self, action: #selector(showMenu))
            return navigationItem
        }
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        output.viewIsReady()
    }

    @objc func showMenu() {
//        output.showMenu()
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


    @objc func viewGraphScreen(selector: UIButton) {
        output.showGraphScreen()
    }

    // refreshes everything that changes
    func refresh() {
        self.tableView.reloadData()
        self.titleProgressView.setSpendingValues(currSpend: currentSpending, maxSpend: 40.0)
    }

}

extension WeeklyExpenseViewController {
    func configureView() {
        // Heirarchy
        let mainStack = UIStackView(arrangedSubviews: [titleProgressView, tableView])
        self.view.addSubview(mainStack)
        self.view.addSubview(addTransactionButton)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "TransactionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        addTransactionButton.addTarget(self, action: #selector(showInputDialog), for: .touchUpInside)
        navigateToGraphs.addTarget(self, action: #selector(viewGraphScreen), for: .touchUpInside)
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
        navigateToGraphs.setTitle("Graphs", for: .normal)
        // Layout
        titleProgressView.widthAnchor == view.safeAreaLayoutGuide.widthAnchor - 40
        mainStack.topAnchor == view.safeAreaLayoutGuide.topAnchor + 15
        mainStack.centerAnchors == view.centerAnchors
        addTransactionButton.topAnchor == mainStack.bottomAnchor
        addTransactionButton.leadingAnchor == view.safeAreaLayoutGuide.leadingAnchor + 25
        addTransactionButton.trailingAnchor == view.safeAreaLayoutGuide.trailingAnchor - 25
        addTransactionButton.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - 20

        addTransactionButton.heightAnchor == 40

        tableView.widthAnchor == mainStack.widthAnchor / 8 * 7

    }
}

extension WeeklyExpenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        cell.textLabel?.text = transactions[indexPath.row].reason
        let amount = Self.getAmountString(amount: transactions[indexPath.row].amount)
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
}


class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
