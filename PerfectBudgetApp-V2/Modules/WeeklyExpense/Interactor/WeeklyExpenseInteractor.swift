//
//  WeeklyExpenseInteractor.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//
import Foundation

class WeeklyExpenseInteractor: WeeklyExpenseInteractorInput {
    weak var output: WeeklyExpenseInteractorOutput!
    var service: TransactionServiceProtocol!

    func createTransaction(reason: String, amount: Double) {
        let newTransaction = service.createTransaction(reason: reason, amount: amount)
        output.pushNewTransaction(newTransaction)
    }

    func deleteTransaction(_ transaction: Transaction) {
        service.deleteTransaction(transaction: transaction)
    }

    func getWeeklyTransactions() -> [Transaction] {
        let allTransactions = service.fetchTransactions()
        let calendar = Calendar.current
        let todaysDate = Date()

        // Filters based on if date is in this week.
        // TODO make date no longer optional
        return allTransactions.filter { calendar.isDate($0.date ?? Date.distantFuture, equalTo: todaysDate, toGranularity: .weekOfYear) }
    }

    func getCurrentWeekString() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
        .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }  // use `flatMap` in Xcode versions before 9.3

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")

        var weeklyString = ""
        for (index, day) in days.enumerated() {
            if index == 0 {
                weeklyString = ""
            }
            print(formatter.string(from: day))
        }

    }
}
