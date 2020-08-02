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

    var tableView = UITableView()
    var titleProgressView = TitleProgressContainerView()
    var transactions: [Transaction] = []
    let addTransactionButton = UIButton(type: .system)
    let editTransactionButton = UIButton(type: .system)
    let navigateToGraphs = UIButton(type: .system)

    var output: WeeklyExpenseViewOutput!

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

    @objc func showInputDialog() {
        let alertController = UIAlertController(title: "Enter details of transaction?", message: "Enter your reason and amount", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { [weak self] (_) in
            let reason = alertController.textFields?[0].text
            let amount = alertController.textFields?[1].text
            // so god damn safe jesus
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
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }


    @objc func editTransaction(selector: UIButton) {
        if tableView.isEditing {
            selector.setTitle("Edit", for: .normal)
            tableView.isEditing = false
        } else {
            selector.setTitle("Done", for: .normal)
            tableView.isEditing = true
        }
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
        let buttonStack = UIStackView(arrangedSubviews: [navigateToGraphs, editTransactionButton, addTransactionButton])
        self.view.addSubview(mainStack)
        self.view.addSubview(buttonStack)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "TransactionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        self.tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        addTransactionButton.addTarget(self, action: #selector(showInputDialog), for: .touchUpInside)
        editTransactionButton.addTarget(self, action: #selector(editTransaction), for: .touchUpInside)
        navigateToGraphs.addTarget(self, action: #selector(viewGraphScreen), for: .touchUpInside)
        // Style
        mainStack.axis = .vertical
        mainStack.alignment = .center
        buttonStack.distribution = .fillEqually
        addTransactionButton.setTitle("New", for: .normal)
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        editTransactionButton.backgroundColor = .white
        editTransactionButton.setTitle("Edit", for: .normal)
        navigateToGraphs.setTitle("Graphs", for: .normal)
        // Layout
        titleProgressView.heightAnchor == 200
        titleProgressView.widthAnchor == view.safeAreaLayoutGuide.widthAnchor - 40
        mainStack.topAnchor == view.safeAreaLayoutGuide.topAnchor + 15
        mainStack.centerAnchors == view.centerAnchors

        buttonStack.topAnchor == mainStack.bottomAnchor
        buttonStack.bottomAnchor == view.bottomAnchor
        buttonStack.widthAnchor == (view.safeAreaLayoutGuide.widthAnchor / 4) * 3
        buttonStack.centerXAnchor == view.safeAreaLayoutGuide.centerXAnchor

        tableView.widthAnchor == mainStack.widthAnchor / 8 * 7
    }
}

extension WeeklyExpenseViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        cell.textLabel?.text = transactions[indexPath.row].reason
        cell.detailTextLabel?.text = "$\(transactions[indexPath.row].amount)"
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            output.deleteTransaction(transaction: transactions[indexPath.row])
            self.transactions.remove(at: indexPath.row)
            refresh()
        }
    }

}

extension WeeklyExpenseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedTransaction = transactions[indexPath.row]
        output.transactionTapped(tappedTransaction)
    }
}

// MARK: WeeklyExpenseViewInput
extension WeeklyExpenseViewController: WeeklyExpenseViewInput {

    func setupInitialState(using weeklyTransactions: [Transaction], weekTitle: String) {
        self.transactions = weeklyTransactions
        self.titleProgressView.showDayOfWeek(day: weekTitle)
        refresh()
    }

    func addTransaction(_ transaction: Transaction) {
        self.transactions.append(transaction)
        refresh()
    }
}

class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
