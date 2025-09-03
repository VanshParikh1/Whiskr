//
//  RemindersView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-28.
//

import SwiftUI

struct RemindersView: View {
    @StateObject private var reminderManager = ReminderManager()
    @AppStorage("name") var catName: String?
    
    @State private var showingAddReminder = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.whiskrYellow), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .sheet(isPresented: $showingAddReminder) {
                AddReminderView(reminderManager: reminderManager)
            }
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Reminders")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(.whiskred)
                        
                        Text("Keeping \(catName ?? "your cat") on track!")
                            .font(.system(size: 20))
                            .foregroundColor(.whiskred.opacity(0.8))
                    }
                    Spacer()
                    
                    Button(action: { showingAddReminder = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.whiskred)
                    }
                    .padding()
                }
                .padding(.horizontal)
                
                // Simplified list of reminders
                List {
                    // Active Reminders Section
                    let activeReminders = reminderManager.reminders.filter { $0.isEnabled }
                    if !activeReminders.isEmpty {
                        Section(header:
                                    Text("Active Reminders")
                            .font(.headline)
                            .foregroundColor(.whiskred)
                            .textCase(nil)
                        ) {
                            ForEach(activeReminders) { reminder in
                                EnhancedReminderCard(reminder: reminder, reminderManager: reminderManager)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            }
                            .onDelete { indexSet in
                                indexSet.forEach { i in
                                    let reminder = activeReminders[i]
                                    reminderManager.deleteReminder(id: reminder.id)
                                }
                            }
                        }
                    }
                    
                    // Disabled Section
                    let disabled = reminderManager.reminders.filter { !$0.isEnabled }
                    if !disabled.isEmpty {
                        Section(header:
                                    Text("Disabled")
                            .font(.headline)
                            .foregroundColor(.whiskred)
                            .textCase(nil)
                        ) {
                            ForEach(disabled) { reminder in
                                EnhancedReminderCard(reminder: reminder, reminderManager: reminderManager)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            }
                            .onDelete { indexSet in
                                indexSet.forEach { i in
                                    let reminder = disabled[i]
                                    reminderManager.deleteReminder(id: reminder.id)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                
                Spacer()
            }
        }
        .onAppear {
            reminderManager.cleanupExpiredOneTimeReminders()
            reminderManager.requestNotificationPermission()
        }
    }
}

struct EnhancedReminderCard: View {
    let reminder: CatReminder
    let reminderManager: ReminderManager
    
    private var nextDueDateString: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(reminder.nextDue, inSameDayAs: Date()) {
            formatter.timeStyle = .short
            return "Today at \(formatter.string(from: reminder.nextDue))"
        } else if calendar.isDate(reminder.nextDue, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()) {
            formatter.timeStyle = .short
            return "Tomorrow at \(formatter.string(from: reminder.nextDue))"
        } else {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: reminder.nextDue)
        }
    }
    
    var body: some View {
        HStack {
            // Category Icon with color
            ZStack {
                Circle()
                    .fill(reminder.category.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: reminder.category.icon)
                    .foregroundColor(reminder.category.color)
                    .font(.title3)
            }
            
            // Reminder Info
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.headline)
                    .foregroundColor(.whiskred)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(reminder.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.whiskred.opacity(0.6))
                    
                    Text("Next: \(nextDueDateString)")
                        .font(.caption)
                        .foregroundColor(.whiskred.opacity(0.8))
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 15) {
                
                // Toggle enabled/disabled
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        reminderManager.toggleReminder(id: reminder.id)
                    }
                }) {
                    Image(systemName: reminder.isEnabled ? "bell.fill" : "bell.slash")
                        .foregroundColor(reminder.isEnabled ? .whiskred : .gray)
                        .font(.title2)
                        .frame(width: 44, height: 44)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .whiskred.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    RemindersView()
}
