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
    private var today: Date?

    func getTodaysDate() -> Date {
        let now = Date()
        var calender = Calendar.current
        calender.timeZone = TimeZone.current
        if let today = self.today {
            let result = calender.compare(today, to: now, toGranularity: .day)
            let isSameDay = result == .orderedSame
            if isSameDay {
                return today
            }
        }
        self.today = now
        return now
    }

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

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")

        let firstDayOfWeek = formatter.string(from: day.startOfWeek!)
        let lastDayOfWeek = formatter.string(from: day.endOfWeek!)
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



extension Date {
    // last Saturday
    var startOfPreviousWeek: Date? {
        let userCalendar = Calendar.current
        let sundayDate = userCalendar.date(from: userCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return userCalendar.date(byAdding: .day, value: -1, to: sundayDate)
    }
    // last Sunday
    var startOfWeek: Date? {
        let userCalendar = Calendar.current
        return userCalendar.date(from: userCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    // next Saturday
    var endOfWeek: Date? {
        let userCalendar = Calendar.current
        let sundayDate = userCalendar.date(from: userCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return userCalendar.date(byAdding: .day, value: 6, to: sundayDate)
    }
    // next Sunday
    var startOfNextWeek: Date? {
        let userCalendar = Calendar.current
        let sundayDate = userCalendar.date(from: userCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return userCalendar.date(byAdding: .day, value: 7, to: sundayDate)
    }
}
