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
    private var today: Date {
        get {
            Date()
        }
    }
    // these two will differ often, because the user is changing screens
    private var currentDate: Date?

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
        let firstDayOfWeek = formatter.string(from: day.lastSunday!)
        let lastDayOfWeek = formatter.string(from: day.nextSaturday!)
        return "\(firstDayOfWeek) - \(lastDayOfWeek)"
    }

    func getCurrentDay() -> Date {
        // if the current date is nil, it hasn't been set and we haven't changed days
        if let currentDate = self.currentDate {
            return currentDate
        } else {
            return today
        }
    }

    // returns a boolean to describe whether or not the date was actually moved
    func moveCurrentDateBy(week: Int) {
        let currentDay = getCurrentDay()
        let userCalender = Calendar.current
        self.currentDate = userCalender.date(byAdding: .weekOfMonth, value: week, to: currentDay)!
        // do not let the user move into the future
        if self.currentDate == nil || self.currentDate! > today {
            self.currentDate = today
        }
    }
}


extension Date {
    var lastSaturday: Date? {
        let userCalendar = Calendar.current
        let sundayDate = userCalendar.date(from: userCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return userCalendar.date(byAdding: .day, value: -1, to: sundayDate)
    }
    var lastSunday: Date? {
        let userCalendar = Calendar.current
        let lastSunday = userCalendar.date(from: userCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return lastSunday
    }
    var nextSaturday: Date? {
        let userCalendar = Calendar.current
        let sundayDate = userCalendar.date(from: userCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return userCalendar.date(byAdding: .day, value: 6, to: sundayDate)
    }
    var nextSunday: Date? {
        let userCalendar = Calendar.current
        let sundayDate = userCalendar.date(from: userCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return userCalendar.date(byAdding: .day, value: 7, to: sundayDate)
    }
}
