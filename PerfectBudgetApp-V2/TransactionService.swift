//
//  TransactionServicef.swift
//  PerfectBudgetApp-V2
//
//  Created by Isaak Meier on 7/10/20.
//  Copyright © 2020 Isaak Meier. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class TransactionService {
    var transactions: [Transaction] = []
    // Access transaction values ex:
    // let transaction = transactions[0]
    // let reason = transaction.value(forKeyPath: "reason") as? String
    func sort() {
        
    }

    func fetchTransactions() -> [Transaction] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        // A fetch request for all Transactions
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        // sort by date
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            transactions = try managedContext.fetch(fetchRequest) as! [Transaction]
            // This is what I want to avoid

        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
        }
        return transactions

    }

    func createTransaction(reason: String, amount: Double) -> Transaction {
        // save transaction to the database
        let date = Date()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return Transaction()}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: managedContext)!
        let transactionManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        transactionManagedObject.setValue(amount, forKey: "amount")
        transactionManagedObject.setValue(date, forKey: "date")
        transactionManagedObject.setValue(reason, forKey: "reason")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return transactionManagedObject as! Transaction
    }

    func deleteTransaction(transaction: Transaction) {
        print(transaction)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(transaction)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error saving after delete. \(error)")
        }
    }

    func updateTransaction(transaction: Transaction) {
        // it's really looking like we're going to need an ID field
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        print(managedContext.updatedObjects)
        do { try managedContext.save() }
        catch let error as NSError {
            print("Error saving after ...update?\(error)")
        }

        // I don't think I have a searchable ID. consider adding an autogenerated one
        // let predicate = NSPredicate(format: "id = %@", transaction.objectID)
        // fetchRequest.predicate = predicate
        // do {
        //     let foundTransaction = try managedContext.fetch(fetchRequest) as! [Transaction]
        //     print("Got \(transactions.count) transactions")
        //     print(foundTransaction[0])
        //
        // } catch let error as NSError {
        //     print("Couldn't fetch. \(error), \(error.userInfo)")
        // }
    }

    func findTransaction(transaction: Transaction) {
        // idk how we do without it
    }

}
