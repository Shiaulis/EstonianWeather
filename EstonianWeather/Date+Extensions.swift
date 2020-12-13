//
//  Date+Extensions.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.12.2020.
//

import Foundation

extension Date {

    static var yesterday: Date { Date().dayBefore }
    static var tomorrow: Date { Date().dayAfter }

    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self.noon)!
    }

    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self.noon)!
    }

    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var isLastDayOfMonth: Bool {
        self.dayAfter.month != self.month
    }

}
