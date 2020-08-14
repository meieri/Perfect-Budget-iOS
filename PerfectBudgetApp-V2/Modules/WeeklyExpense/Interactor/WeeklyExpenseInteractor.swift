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
    // mock output for testing, strong reference so it is not deallocated
    var testOutput: WeeklyExpenseInteractorOutput!
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
        formatter.dateFormat = "MMM d"
        print(day.description(with: Locale(identifier: "en_US")))

        let firstDayOfWeek = formatter.string(from: day.previous(.sunday))
        let lastDayOfWeek = formatter.string(from: day.next(.saturday))
        return "\(firstDayOfWeek) - \(lastDayOfWeek)"
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
        print(self.description(with: userCalendar.locale))
        let lastSunday = userCalendar.date(from: userCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return lastSunday
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
