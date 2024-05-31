    //
    //  ContentView.swift
    //  iExpense
    //
    //  Created by Vishrut Jha on 5/21/24.
    //

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    var currency: String
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var groupedExpenses: [String: [ExpenseItem]] {
        Dictionary(grouping: expenses.items, by: { $0.type })
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedExpenses.keys.sorted(), id: \.self) { type in
                    Section(header: Text("\(type) Expenses")) {
                        ForEach(groupedExpenses[type] ?? []) { item in
                            ExpenseRow(item: item)
                        }
                        .onDelete { indexSet in
                            removeItems(at: indexSet, from: type)
                        }
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, from type: String) {
        let filteredItems = expenses.items.filter { $0.type == type }
        for index in offsets {
            if let itemIndex = expenses.items.firstIndex(where: { $0.id == filteredItems[index].id }) {
                expenses.items.remove(at: itemIndex)
            }
        }
    }
}

struct ExpenseRow: View {
    let item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                
                Text(item.type)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Text(formattedAmount(for: item)) // from Locales
                .foregroundColor(item.amount < 10 ? .green : (item.amount < 100 ? .orange : .red))
        }
    }
}

#Preview {
    ContentView()
}
