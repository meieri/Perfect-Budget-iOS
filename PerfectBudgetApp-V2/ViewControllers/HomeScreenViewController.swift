//
//  ViewController.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/6/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import UIKit
import Anchorage

class HomeScreenViewController: UIViewController {
    var service: TransactionService!
    var coordinator: Coordinator?

    var tableView = UITableView()
    var titleProgressView = TitleProgressContainerView()
    var transactions: [Transaction] = []
    let addTransactionButton = UIButton(type: .system)
    let editTransactionButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        transactions = service.fetchTransactions()
        configureView()
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
                if let newTransaction = self?.service.createTransaction(reason: reason, amount: numAmount) {
                    self?.transactions.append(newTransaction)
                    self?.tableView.reloadData()
                    self?.titleProgressView.showProgress(progress: 0.5)
                }
            } else {
                return
            }
            // self.presenter.addExpense(amount: numAmount!, reason: reason!)
            // self.presenter.setProgress()
            // self.expenseTable.reloadData()
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
        tableView.isEditing = true
    }

}

extension HomeScreenViewController {
    func configureView() {
        // Heirarchy
        self.view.addSubview(tableView)
        self.view.addSubview(titleProgressView)
        self.view.addSubview(addTransactionButton)
        self.view.addSubview(editTransactionButton)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "TransactionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        addTransactionButton.addTarget(self, action: #selector(showInputDialog), for: .touchUpInside)
        editTransactionButton.addTarget(self, action: #selector(editTransaction), for: .touchUpInside)
        // Style
        addTransactionButton.backgroundColor = .blue
        addTransactionButton.setTitle("New Transaction", for: .normal)
        self.view.backgroundColor = .white
        tableView.layer.cornerRadius = 0.4
        tableView.backgroundView?.backgroundColor = UIColor.black
        // probably shouldn't go here but for now

        editTransactionButton.backgroundColor = .white
        editTransactionButton.setTitle("Edit Transactions", for: .normal)
        // Layout
        addTransactionButton.topAnchor == tableView.bottomAnchor + 10
        addTransactionButton.trailingAnchor == view.trailingAnchor
        addTransactionButton.bottomAnchor == view.bottomAnchor
        addTransactionButton.widthAnchor == view.widthAnchor / 2
        
        editTransactionButton.topAnchor == tableView.bottomAnchor + 10
        editTransactionButton.leadingAnchor == view.leadingAnchor
        editTransactionButton.bottomAnchor == view.bottomAnchor
        editTransactionButton.widthAnchor == view.widthAnchor / 2

        self.titleProgressView.topAnchor == self.view.topAnchor + 50
        self.titleProgressView.leadingAnchor == self.view.leadingAnchor + 10
        self.titleProgressView.trailingAnchor == self.view.trailingAnchor - 10
        self.titleProgressView.heightAnchor == 200

        tableView.leadingAnchor == self.view.leadingAnchor + 20
        tableView.trailingAnchor == self.view.trailingAnchor - 20
        tableView.topAnchor == titleProgressView.bottomAnchor + 40
        tableView.heightAnchor == view.heightAnchor / 2
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        cell.textLabel?.text = transactions[indexPath.row].reason
        cell.isUserInteractionEnabled = true
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            service.deleteTransaction(transaction: transactions[indexPath.row])
            self.transactions.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

}

extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedTransaction = transactions[indexPath.row]
        coordinator?.transactionTapped(tappedTransaction)
    }
}