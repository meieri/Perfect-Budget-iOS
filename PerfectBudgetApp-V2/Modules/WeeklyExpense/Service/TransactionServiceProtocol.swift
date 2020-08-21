//
//  TransactionServiceProtocol.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/29/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import Foundation

protocol TransactionServiceProtocol: AnyObject {
    // CRUD Operations
    func createTransaction(reason: String, amount: Double, date: Date) -> Transaction
    func fetchTransactions() -> [Transaction]
    func updateTransaction(transaction: Transaction)
    func deleteTransaction(transaction: Transaction)
}
