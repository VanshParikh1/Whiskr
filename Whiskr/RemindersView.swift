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
            
            VStack(spacing:20) {
                //Header
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
                    
                    Button(action: { showingAddReminder = true}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size:30))
                            .foregroundColor(.whiskred)
                    }
                    .padding()
                }
                .padding(.horizontal)
                
                //Simple scroll list of reminders
                ScrollView {
                    LazyVStack(spacing: 25) {
                        ForEach(reminderManager.reminders, id: \.id){ reminder in
                            BasicReminderCard(reminder: reminder, reminderManager: reminderManager)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}

//Simple reminder card
struct BasicReminderCard: View {
    let reminder: CatReminder
    let reminderManager: ReminderManager
    var body: some View {
        HStack {
            //Icon
            Image(systemName: reminder.category.icon)
                .foregroundColor(.whiskred)
                .font(.system(size: 40))
                .frame(width: 60)
            
            //Reminder info
            VStack(alignment: .leading, spacing: 4){
                Text(reminder.title)
                    .font(.headline)
                    .foregroundColor(.whiskred)
                
                Text(reminder.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.whiskred.opacity(0.6))
            }
            Spacer()
            
            //Status
            VStack{
                Text(reminder.isEnabled ? "ON" : "OFF")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(reminder.isEnabled ? .green : .whiskred)
                    .padding(.horizontal)
                
                //Simple toggle button
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)){
                        reminderManager.toggleReminder(id: reminder.id)
                    }
                    
                }) {
                    Image(systemName: reminder.isEnabled ? "bell.fill" : "bell.slash")
                        .foregroundColor(reminder.isEnabled ? .whiskred : .gray)
                        .scaleEffect(reminder.isEnabled ? 1.0 : 0.9)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: reminder.isEnabled)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.6))
                .shadow(color: .whiskred.opacity(0.1), radius: 4, x: 0, y: 0)
        )
    }
}

#Preview {
    RemindersView()
}
