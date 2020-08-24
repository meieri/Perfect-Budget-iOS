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

    func createTransaction(reason: String, amount: Double, day: Date) {
<<<<<<< HEAD
        let newTransaction = service.createTransaction(reason: reason, amount: amount, day: day)
=======
        let day = day
        let newTransaction = service.createTransaction(reason: reason, amount: amount)
>>>>>>> 42e0dcb7537c366d492c1200e7ca0cd0eeed42a7
        output.pushNewTransaction(newTransaction)
    }

    func deleteTransaction(_ transaction: Transaction) {
        service.deleteTransaction(transaction: transaction)
    }

    func getWeekTransactions(for day: Date) -> [Transaction] {
        let allTransactions = service.fetchTransactions()
        let calendar = Calendar.current
        // Filters based on if date is in this week.
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

    // returns a boolean to describe whether or not the date was actually moved
    func getCurrentDateMovedBy(week: Int) -> Date {
        let currentDay = self.today
        let userCalender = Calendar.current
        let movedDate = userCalender.date(byAdding: .weekOfMonth, value: week, to: currentDay)
        // do not let the user move into the future
        if movedDate == nil || movedDate! > today {
            return currentDay
        } else {
            // force unwrap is ok because above checks if nil
            return movedDate!
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
