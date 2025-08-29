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
    
    init() {
        setupTestReminders()
    }
    
    private func setupTestReminders() {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        
        reminders = [
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
    }
    
    func toggleReminder(id: UUID) {
        if let index = reminders.firstIndex(where: { $0.id == id }) {
            reminders[index].isEnabled.toggle()
        }
    }
}
