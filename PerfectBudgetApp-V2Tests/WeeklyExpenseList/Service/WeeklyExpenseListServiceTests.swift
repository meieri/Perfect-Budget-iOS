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

    func createTransaction(reason: String, amount: Double) -> Transaction {
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: managedContext)!
        let transactionManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        transactionManagedObject.setValue(amount, forKey: "amount")
        transactionManagedObject.setValue(Date(), forKey: "date")
        transactionManagedObject.setValue(reason, forKey: "reason")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return transactionManagedObject as! Transaction
    }

    func fetchTransactions() -> [Transaction] {
        return [Transaction()]
    }

    func updateTransaction(transaction: Transaction) {

    }
    func deleteTransaction(transaction: Transaction) {

    }

}
