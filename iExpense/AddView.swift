//
//  AddView.swift
//  iExpense
//
//  Created by Vishrut Jha on 5/31/24.
//

import SwiftUI
import CurrencyField

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amountInCents = 0
    @State private var currency = "USD"
    
    @State private var chosenLocale = Locale(identifier: "en_US")
    
    private var formatter: NumberFormatter {
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.minimumFractionDigits = 2
        format.maximumFractionDigits = 2
        format.locale = chosenLocale
        return format
    }
    
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                HStack {
                    Picker("Amount", selection: $chosenLocale) {
                        ForEach(locales, id: \.self) { locale in
                            if let cc = locale.currency?.identifier, let sym = locale.currencySymbol {
                                Text("\(cc) \(sym)").tag(locale)
                            }
                        }
                    }
                    .onChange(of: chosenLocale) { _, newLocale in
                        currency = newLocale.currency?.identifier ?? "USD"
                    }
                    
                    Spacer()
                    
                    CurrencyField(value: $amountInCents, formatter: formatter)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let amount = Double(amountInCents) / 100.0
                    let item = ExpenseItem(name: name, type: type, amount: amount, currency: currency)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
