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
    var isEnabled: Bool
    var nextDue: Date
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
