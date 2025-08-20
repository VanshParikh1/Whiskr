//
//  VetVisitDetailView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-19.
//

import SwiftUI

struct VetVisitDetailView: View {
    
    @AppStorage("name") var currentName: String?
    @AppStorage("lastVetVisit") var lastVetVisitStorage: Double = Date().timeIntervalSince1970
    @Environment(\.dismiss) private var dismiss
    
    // Editing state
    @State private var isEditing = false
    @State private var editableVetDate = Date()
    @State private var isAnimated = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.whiskrYellow), .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack{
                HStack{
                    Text("Vet Visit")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.whiskred)
                    Spacer()
                
              
                    
                    Button(action: {
                        if isEditing {
                            // Save the vet visit date
                            lastVetVisitStorage = editableVetDate.timeIntervalSince1970
                        } else {
                            // Load current date for editing
                            editableVetDate = Date(timeIntervalSince1970: lastVetVisitStorage)
                        }
                        isEditing.toggle()
                        
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .font(.title3)
                            .fontWeight(.medium)
                            .underline()
                            .foregroundColor(.whiskred)
                    }
                }
                .padding()
                
                if isEditing {
                    Spacer()
                        .frame(height: 75)
                    
                    Text("When was the last vet visit?" )
                        .multilineTextAlignment(.center)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.whiskred)
                    // Custom date picker for editing
                    
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.9))
                                .frame(height: 320)
                                .shadow(color: .whiskred.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            VStack(spacing: 15) {
                                Text("Select Visit Date")
                                    .font(.headline)
                                    .foregroundColor(.whiskred)
                                
                                // Using the CustomDatePicker instead of the standard DatePicker
                                CustomDatePicker(date: $editableVetDate)
                                    .frame(height: 200)
                                    .clipped()
                                
                                Text("Selected: \(formattedDate(editableVetDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.whiskred.opacity(0.8))
                                    .padding(.top)
                            }
                            .padding()
                        }
                        .padding()
                        // Cancel and Save buttons
                        HStack(spacing: 15) {
                            Button("Cancel") {
                                isEditing = false
                                editableVetDate = Date(timeIntervalSince1970: lastVetVisitStorage) // Reset to original
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.whiskred)
                            .cornerRadius(30)
                            
                            Button("Save Visit Date") {
                                lastVetVisitStorage = editableVetDate.timeIntervalSince1970
                                isEditing = false
                                
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.whiskred)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .shadow(color: Color.whiskred.opacity(0.3), radius: 6, x: 0, y: 4)
                        }
                        .padding(.horizontal)
                    }
                    
                } else {
                    //VIEW MODE
                    
                    ZStack {
                        Circle()
                            .fill(Color.whiskred.opacity(0.1))
                            .frame(width: 130, height: 130)
                            .scaleEffect(isAnimated ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimated)
                        
                        Image(systemName: "stethoscope.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.whiskred)
                            .shadow(color: .whiskred.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .onAppear {
                        isAnimated = true
                    }
                    Text("It has been")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.whiskred)
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.whiskred, Color.whiskred.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 350, height: 200)
                            .shadow(color: Color.whiskred.opacity(0.4), radius: 12, x: 0, y: 6)
            
                        VStack(spacing: 12) {
                            Text("\(daysSinceLastVetVisit())")
                                .font(.system(size: 70, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                            
                            Text(daysSinceLastVetVisit() == 1 ? "day" : "days")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("since \(currentName ?? "your cat")'s last visit")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal)
                        }
                       
                    }
                    // Enhanced last visit date info
                    VStack(spacing: 8) {
                        Text("🏥")
                            .font(.system(size: 30))
                        
                        Text(isEditing ? "Current last visit:" : "Last visit was on:")
                            .font(.headline)
                            .foregroundColor(.whiskred)
                        
                        Text(isEditing ? formattedDate(editableVetDate) : formattedLastVetVisit())
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.whiskred)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: .whiskred.opacity(0.2), radius: 6, x: 0, y: 3)
                    )
                }
             
                Spacer()
            }
        }
        .onAppear {
            editableVetDate = Date(timeIntervalSince1970: lastVetVisitStorage)
        }
    }
}

// MARK: - Functions
extension VetVisitDetailView {
    
    // Function to calculate days since last vet visit
    func daysSinceLastVetVisit() -> Int {
        let lastVisitDate = Date(timeIntervalSince1970: lastVetVisitStorage)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastVisitDate, to: Date())
        return max(components.day ?? 0, 0) // Ensure we don't return negative days
    }
    
    // Function to format the last vet visit date for display
    func formattedLastVetVisit() -> String {
        let lastVisitDate = Date(timeIntervalSince1970: lastVetVisitStorage)
        return formattedDate(lastVisitDate)
    }
    
    // Helper function to format any date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    // Function to get the stored last vet visit date as a Date object
    func getStoredLastVetVisitDate() -> Date {
        return Date(timeIntervalSince1970: lastVetVisitStorage)
    }
    
    func timeSinceLastVisit() -> String {
        let days = daysSinceLastVetVisit()
        
        if days == 0 {
            return "Today"
        } else if days == 1 {
            return "1 day ago"
        } else if days < 30 {
            return "\(days) days ago"
        } else if days < 365 {
            let months = days / 30
            return months == 1 ? "1 month ago" : "\(months) months ago"
        } else {
            let years = days / 365
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
    }
}

#Preview {
    VetVisitDetailView()
}
