//
//  ReminderManager.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-27.
//

import Foundation
import SwiftUI
import UserNotifications

class ReminderManager: ObservableObject {
    @Published var reminders: [CatReminder] = []
    
    private let userDefaults = UserDefaults.standard
    private let remindersKey = "catReminders"
    
    init() {
        loadReminders()
        setupDefaultReminders()
        cleanupExpiredOneTimeReminders()
    }
    
    private func setupDefaultReminders() {
        if reminders.isEmpty {
            let calendar = Calendar.current
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            
            let defaultReminders = [
                CatReminder(
                    title: "Clean litter",
                    category: .litter,
                    frequency: .daily,
                    isEnabled: true,
                    nextDue: tomorrow // Set to tomorrow instead of now
                ),
                CatReminder(
                    title: "Visit Vet",
                    category: .vetVisit,
                    frequency: .weekly, // Changed from daily - vet visits aren't daily
                    isEnabled: true,
                    nextDue: calendar.date(byAdding: .day, value: 7, to: Date()) ?? Date()
                ),
                CatReminder(
                    title: "Feed cat",
                    category: .feeding,
                    frequency: .daily,
                    isEnabled: true,
                    nextDue: tomorrow
                )
            ]
            reminders = defaultReminders
            saveReminders()
            // Schedule notifications for default reminders
            defaultReminders.forEach { scheduleNotification(for: $0) }
        }
    }
    
    func saveReminders() {
        if let encodedData = try? JSONEncoder().encode(reminders) {
            userDefaults.set(encodedData, forKey: remindersKey)
        }
    }
    
    func loadReminders() {
        if let data = userDefaults.data(forKey: remindersKey),
           let decodedReminders = try? JSONDecoder().decode([CatReminder].self, from: data) {
            reminders = decodedReminders
        }
    }
    
    func addReminder(_ reminder: CatReminder) {
        reminders.append(reminder)
        saveReminders()
        if reminder.isEnabled {
            scheduleNotification(for: reminder)
        }
    }
    
    func cleanupExpiredOneTimeReminders() {
        let now = Date()
        let removedIds = reminders.compactMap { reminder in
            // Remove if it's a one-time reminder that's past due
            (reminder.frequency == .once && reminder.nextDue < now) ? reminder.id.uuidString : nil
        }
        
        reminders.removeAll { reminder in
            reminder.frequency == .once && reminder.nextDue < now
        }
        
        // Cancel notifications for removed reminders
        if !removedIds.isEmpty {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removedIds)
        }
        
        saveReminders()
    }
    
    func deleteReminder(id: UUID) {
        // Cancel notification before removing
        cancelNotification(for: id.uuidString)
        reminders.removeAll { $0.id == id }
        saveReminders()
    }
    
    func markReminderComplete(id: UUID) {
        guard let index = reminders.firstIndex(where: { $0.id == id }) else { return }
        let reminder = reminders[index]
        
        // Cancel current notification
        cancelNotification(for: reminder.id.uuidString)
        
        if reminder.frequency == .once {
            // Remove one-time reminders when completed
            reminders.remove(at: index)
        } else {
            // Schedule next occurrence for recurring reminders
            scheduleNextRecurrence(for: id)
        }
        saveReminders()
    }
    
    func toggleReminder(id: UUID) {
        if let index = reminders.firstIndex(where: { $0.id == id }) {
            reminders[index].isEnabled.toggle()
            saveReminders()
            
            if reminders[index].isEnabled {
                // If enabling and the due date has passed, reschedule for next occurrence
                if reminders[index].nextDue <= Date() && reminders[index].frequency != .once {
                    scheduleNextRecurrence(for: id)
                } else {
                    scheduleNotification(for: reminders[index])
                }
            } else {
                cancelNotification(for: reminders[index].id.uuidString)
            }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func scheduleNotification(for reminder: CatReminder) {
        guard reminder.isEnabled else {return}
        
        let content = UNMutableNotificationContent()
        content.title = "Whiskr Reminder"
        content.body = reminder.title
        content.sound = .default
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.nextDue),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notifications: \(error)")
            }}
    }
    
    func cancelNotification(for id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func scheduleNextRecurrence(for reminderId: UUID) {
        guard let index = reminders.firstIndex(where: { $0.id == reminderId}) else {return}
        let reminder = reminders[index]
        
        guard reminder.frequency != .once else {return} //dont reschedule if it is one time
        
        let nextDue = Calendar.current.date(byAdding: .day, value: reminder.intervalInDays, to: reminder.nextDue) ?? Date()
        reminders[index].nextDue = nextDue
        saveReminders()
        scheduleNotification(for: reminders[index])
    }
}
