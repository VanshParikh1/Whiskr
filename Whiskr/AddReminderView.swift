//
//  AddReminderView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-29.
//

import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) private var dismiss
    let reminderManager: ReminderManager
    
    @State private var title = ""
    @State private var selectedCategory = ReminderCategory.litter
    @State private var nextDueDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(.whiskrYellow), .white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Title Input
                    VStack(alignment: .leading) {
                        Text("Reminder Title")
                            .font(.title)
                            .foregroundColor(.whiskred)
                        
                        TextField("Enter reminder title", text: $title)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                    
                    // Category Selection
                    VStack {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.whiskred)
                        HStack(spacing: 15) {
                            
                            ForEach(ReminderCategory.allCases, id: \.self) { category in
                                Button(action: { selectedCategory = category }) {
                                    VStack {
                                        Image(systemName: category.icon)
                                            .font(.title2)
                                            .foregroundColor(selectedCategory == category ? .whiskred : .gray)
                                            .padding()
                                            .background(
                                                Circle()
                                                    .fill(selectedCategory == category ? Color.whiskred.opacity(0.2) : Color.white.opacity(0.5))
                                            )
                                        
                                        Text(category.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.whiskred)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Next Due Date
                    VStack {
                        Text("Next Due")
                            .font(.headline)
                            .foregroundColor(.whiskred)
                        
                        DatePicker("Select date", selection: $nextDueDate, in: Date()...)
                            .datePickerStyle(.compact)
                            .accentColor(.whiskred)
                            .foregroundColor(.whiskred)
                    }
                    
                    Spacer()
                    
                    // Save Button
                    Button("Add Reminder") {
                        let newReminder = CatReminder(
                            title: title,
                            category: selectedCategory,
                            isEnabled: true,
                            nextDue: nextDueDate
                        )
                        reminderManager.addReminder(newReminder)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(title.isEmpty ? Color.whiskredDark : Color.whiskred)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .disabled(title.isEmpty)
                }
                .padding()
            }
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.whiskred)
                }
            }
        }
    }
}

#Preview {
    AddReminderView(reminderManager: ReminderManager())
}
