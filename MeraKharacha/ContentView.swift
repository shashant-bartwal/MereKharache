//
//  ContentView.swift
//  MeraKharacha
//
//  Created by shashant on 16/06/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items  = decoded
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
    @ObservedObject var  expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items, id: \.id) { item in
//                    Text(item.name)
                    HStack {
                        VStack(alignment: .leading) {
                            
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("₹\(item.amount)")
                    }
                }.onDelete(perform: removeItems)
            }.navigationBarTitle("Mera kharacha")
            .navigationBarItems(trailing: Button(action: {
//                let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
//                self.expenses.items.append(expense)
                self.showingAddExpense.toggle()
            }){
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
