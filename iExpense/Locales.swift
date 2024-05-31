//
//  Locales.swift
//  iExpense
//
//  Created by Vishrut Jha on 5/31/24.
//

import Foundation

let locales = [
    Locale(identifier: "en_US"),
    Locale(identifier: "fr_FR"),
    Locale(identifier: "ja_JP"),
    Locale(identifier: "en_UK"),
    Locale(identifier: "en_IN"),
]

private func getLocale(for currency: String) -> Locale {
    for locale in locales {
        if locale.currency?.identifier == currency {
            return locale
        }
    }
    return Locale(identifier: "en_US") // default locale
}

func formattedAmount(for item: ExpenseItem) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.locale = getLocale(for: item.currency)
    return formatter.string(from: NSNumber(value: item.amount)) ?? "\(item.amount)"
}
