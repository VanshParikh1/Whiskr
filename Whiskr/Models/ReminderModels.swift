//
//  ReminderModels.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-27.
//

import SwiftUI
import Foundation

//MARK: Basic reminder
struct CatReminder: Identifiable, Codable {
    let id = UUID()
    var title: String
    var category: ReminderCategory
    var frequency: ReminderFrequency
    var customDays: Int? // Only used when frequency is .custom
    var isEnabled: Bool
    var nextDue: Date
    
    // Computed property to get actual interval in days
    var intervalInDays: Int {
        switch frequency {
        case .once: return 0
        case .daily: return 1
        case .weekly: return 7
        case .custom: return customDays ?? 2
        }
    }
}
//MARK: Reminder Categories
enum ReminderCategory: String, CaseIterable, Codable {
    case litter = "Clean litter"
    case feeding = "Feeding"
    case vetVisit = "Vet Visit"
    
    var icon: String  {
        switch self{
        case .litter: return "tray.fill"
        case .feeding: return "fork.knife.circle"
        case .vetVisit: return "stethoscope"
        }
    }
    
    var color: Color {
        switch self{
        case .litter: return .blue
        case .feeding: return .brown
        case .vetVisit: return .whiskredDark
        }
    }
}


//MARK: Reminder Frequency
enum ReminderFrequency: String, CaseIterable, Codable {
    case once = "Once"
    case daily = "Daily"
    case weekly = "Weekly"
    case custom = "Custom"
    
    var defaultInterval: Int {
            switch self {
            case .once: return 0
            case .daily: return 1
            case .weekly: return 7
            case .custom: return 2 // Default to 3 days
            }
        }
    
}
