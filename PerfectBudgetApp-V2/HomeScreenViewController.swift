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
    var transactions: [Transaction] = []
    let addTransactionButton = UIButton(type: .system)
    let editTransactionButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        transactions = service.fetchTransactions()
        configureView()
    }

    @objc func addTransaction(sender: UIButton) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new reason",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
          [unowned self] action in
          guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {
              return
          }
          self.transactions.append(self.service.createTransaction(reason: nameToSave, amount: 10))
          self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    @objc func editTransaction(selector: UIButton) {
        tableView.isEditing = true
    }

}

extension HomeScreenViewController {
    func configureView() {
        // Heirarchy
        self.view.addSubview(tableView)
        self.view.addSubview(addTransactionButton)
        self.view.addSubview(editTransactionButton)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "TransactionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        addTransactionButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        editTransactionButton.addTarget(self, action: #selector(editTransaction), for: .touchUpInside)
        // Style
        addTransactionButton.backgroundColor = .blue
        addTransactionButton.setTitle("New Transaction", for: .normal)

        editTransactionButton.backgroundColor = .white
        editTransactionButton.setTitle("Edit Transactions", for: .normal)
        // Layout
        addTransactionButton.topAnchor == tableView.bottomAnchor
        addTransactionButton.trailingAnchor == view.trailingAnchor
        addTransactionButton.bottomAnchor == view.bottomAnchor
        addTransactionButton.widthAnchor == view.widthAnchor / 2
        
        editTransactionButton.topAnchor == tableView.bottomAnchor
        editTransactionButton.leadingAnchor == view.leadingAnchor
        editTransactionButton.bottomAnchor == view.bottomAnchor
        editTransactionButton.widthAnchor == view.widthAnchor / 2
        
        tableView.leadingAnchor == self.view.leadingAnchor
        tableView.trailingAnchor == self.view.trailingAnchor
        tableView.topAnchor == self.view.topAnchor
        tableView.heightAnchor == 3 * self.view.heightAnchor / 4
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
