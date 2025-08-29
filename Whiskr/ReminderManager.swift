//
//  ReminderManager.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-27.
//

import Foundation
import SwiftUI


class ReminderManager: ObservableObject {
    @Published var reminders: [CatReminder] = []
    
    private let userDefaults = UserDefaults.standard
    private let remindersKey = "catReminders"
    
    init() {
        loadReminders()
        setupDefaultReminders()
    }
    
    private func setupDefaultReminders() {
        if reminders.isEmpty {
            let defaultReminders = [
                CatReminder(
                    title: "Clean litter",
                    category: .litter,
                    isEnabled: true,
                    nextDue: Date()
                    ),
                CatReminder(
                    title: "Visit Vet",
                    category: .vetVisit,
                    isEnabled: true,
                    nextDue: Date()
                    ),
                CatReminder(
                    title: "Feed cat",
                    category: .feeding,
                    isEnabled: true,
                    nextDue: Date()
                    )
            ]
            reminders = defaultReminders
            saveReminders()
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
    }
    
    func toggleReminder(id: UUID) {
        if let index = reminders.firstIndex(where: { $0.id == id }) {
            reminders[index].isEnabled.toggle()
            saveReminders()
        }
    }
}
