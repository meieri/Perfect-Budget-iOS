//
//  WeeklyExpenseListWeeklyExpenseListInteractorTests.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//

import XCTest
import CoreData
import Foundation

class WeeklyExpenseListInteractorTests: XCTestCase {
    var interactor: WeeklyExpenseInteractor!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.interactor = WeeklyExpenseInteractor()
        self.interactor.service = MockTransactionService()
        self.interactor.output = MockPresenter()
    }

    func testCreateTransaction() {
        interactor.createTransaction(reason: "Test", amount: 10.0)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    class MockPresenter: WeeklyExpenseInteractorOutput {
        func pushNewTransaction(_ transaction: Transaction) {
            XCTAssertEqual(transaction.amount, 10.0)
            XCTAssertEqual(transaction.reason, "Test")
        }
    }
}

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
