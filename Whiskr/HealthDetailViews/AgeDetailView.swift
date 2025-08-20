//
//  AgeDetailView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-19.
//

import SwiftUI

struct AgeDetailView: View {
    
    @AppStorage("name") var currentName: String?
    @AppStorage("birthdate") var birthdateStorage: Double = Date().timeIntervalSince1970
    @Environment(\.dismiss) private var dismiss
    
    // Editing state
    @State private var isEditing = false
    @State private var editableBirthdate = Date()
    @State private var isAnimated = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.whiskrYellow), .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20){
                HStack{
                    Text("Age")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.whiskred)
                    Spacer()
                
                    
                    Button(action: {
                        if isEditing {
                            // Save the birthdate
                            birthdateStorage = editableBirthdate.timeIntervalSince1970
                        } else {
                            // Load current birthdate for editing
                            editableBirthdate = Date(timeIntervalSince1970: birthdateStorage)
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
                
              
                
                Text(isEditing ? "When was \(currentName ?? "your cat") born?" : "\(currentName ?? "Your cat") is currently")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.whiskred)
                
                if isEditing {
                    // Custom date picker for editing birthdate
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.9))
                                .frame(height: 400)
                                .shadow(color: .whiskred.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            VStack {
                                Text("Select Birthdate")
                                    .font(.headline)
                                    .foregroundColor(.whiskred)
                                
                                // Using the CustomDatePicker instead of the standard DatePicker
                                CustomDatePicker(date: $editableBirthdate)
                                    .frame(height: 200)
                                    .clipped()
                                
                                // Real-time age calculation during editing
                                let currentAge = getAge(from: editableBirthdate)
                                VStack(spacing: 5) {
                                    Text("\(currentName ?? "Your cat") will be:")
                                        .font(.subheadline)
                                        .foregroundColor(.whiskred.opacity(0.8))
                                    
                                    Text("\(currentAge.years) years and \(currentAge.months) months old")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.whiskred)
                                }
                                .padding(.top)
                            }
                            .padding()
                        }
                        // Cancel and Save buttons
                        HStack(spacing: 15) {
                            Button("Cancel") {
                                isEditing = false
                                editableBirthdate = Date(timeIntervalSince1970: birthdateStorage) // Reset to original
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.whiskred)
                            .cornerRadius(30)
                            
                            Button("Save Birthdate") {
                                birthdateStorage = editableBirthdate.timeIntervalSince1970
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
                        .padding()
                    }
                    
                } else {
                    // Enhanced calendar icon with background
                    ZStack {
                        Circle()
                            .fill(Color.whiskred.opacity(0.1))
                            .frame(width: 130, height: 130)
                            .scaleEffect(isAnimated ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimated)
                        
                        Image(systemName: "calendar.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.whiskred)
                            .shadow(color: .whiskred.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .onAppear {
                        isAnimated = true
                    }
                    VStack{
                    
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
                            
                            HStack(spacing: 20){
                                VStack {
                                    Text("\(getCurrentAge().years)")
                                        .font(.system(size: 60, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                                    
                                    Text("years")
                                        .font(.system(size: 18))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                
                                Text("and")
                                    .font(.system(size: 22, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                VStack {
                                    Text("\(getCurrentAge().months)")
                                        .font(.system(size: 60, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                                    
                                    Text("months")
                                        .font(.system(size: 18))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                        }
                        VStack {
                            Text("🎂")
                                .font(.system(size: 30))
                            
                            Text(isEditing ? "Current birthdate:" : "Born on:")
                                .font(.headline)
                                .foregroundColor(.whiskred)
                            
                            Text(isEditing ? formattedDate(editableBirthdate) : formattedBirthdate())
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
                }
                
               
                
                
                
                Spacer()
            }
        }
        .onAppear {
            editableBirthdate = Date(timeIntervalSince1970: birthdateStorage)
        }
    }
}

// MARK: - Functions
extension AgeDetailView {
    
    // Function to get current age from stored birthdate
    func getCurrentAge() -> (years: Int, months: Int) {
        let storedBirthdate = Date(timeIntervalSince1970: birthdateStorage)
        return getAge(from: storedBirthdate)
    }
    
    // Function to calculate age from birthdate (same as in OnboardingView)
    func getAge(from birthdate: Date) -> (years: Int, months: Int) {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month], from: birthdate, to: now)
        
        return (components.year ?? 0, components.month ?? 0)
    }
    
    // Function to format the birthdate for display
    func formattedBirthdate() -> String {
        let birthdate = Date(timeIntervalSince1970: birthdateStorage)
        return formattedDate(birthdate)
    }
    
    // Helper function to format any date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    // Function to get the stored birthdate as a Date object
    func getStoredBirthdate() -> Date {
        return Date(timeIntervalSince1970: birthdateStorage)
    }
    
    
 
}

#Preview {
    AgeDetailView()
}
