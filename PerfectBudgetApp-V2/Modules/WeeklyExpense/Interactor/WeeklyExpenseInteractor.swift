//
//  WeeklyExpenseInteractor.swift
//  PerfectBudgetApp
//
//  Created by Isaak Meier on 28/07/2020.
//  Copyright © 2020 44 Inc.. All rights reserved.
//
import Foundation

class WeeklyExpenseInteractor: WeeklyExpenseInteractorInput {

    var output: WeeklyExpenseInteractorOutput!
    var service: TransactionServiceProtocol!

    func createTransaction(reason: String, amount: Double) {
        let newTransaction = service.createTransaction(reason: reason, amount: amount)
        output.pushNewTransaction(newTransaction)
    }

    func deleteTransaction(_ transaction: Transaction) {
        service.deleteTransaction(transaction: transaction)
    }


    func getWeekTransactions(for day: Date) -> [Transaction] {
        let allTransactions = service.fetchTransactions()
        let calendar = Calendar.current

        // Filters based on if date is in this week.
        // TODO make date no longer optional
        return allTransactions.filter { calendar.isDate($0.date ?? Date.distantFuture, equalTo: day, toGranularity: .weekOfYear) }
    }

    func getWeekString(for day: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: day)
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
        .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")

        let firstDayOfWeek = formatter.string(from: days[0])
        let lastDayOfWeek = formatter.string(from: days[days.count - 1])
        return "\(abbreviateDate(date: firstDayOfWeek)) - \(abbreviateDate(date: lastDayOfWeek))"
    }

    private func abbreviateDate(date: String) -> String {
        if let commaIndex = date.firstIndex(of: ",") {
            let substring = date[..<commaIndex]
            let string = String(substring)
            return string
        } else {
            return ""
        }
    }
}
