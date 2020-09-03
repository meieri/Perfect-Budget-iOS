//
//  WeeklyExpenseListServiceTests.swift
//  PerfectBudgetApp-V2Tests
//
//  Created by Isaak Meier on 8/11/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import CoreData
import Foundation

class MockTransactionService: TransactionServiceProtocol {
    let managedContext = NSPersistentContainer(name: "Test Container").viewContext

    func createTransaction(reason: String, amount: Double, day: Date) -> Transaction {
        let transaction = Transaction()
        transaction.amount = amount
        transaction.reason = reason
        transaction.date = day
        return transaction
    }

    func fetchTransactions() -> [Transaction] {
        return [Transaction()]
    }

    func updateTransaction(transaction: Transaction) {

    }
    func deleteTransaction(transaction: Transaction) {

    }

}
