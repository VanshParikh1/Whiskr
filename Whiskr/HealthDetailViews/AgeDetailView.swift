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
                    Text("Edit")
                        .font(.title3)
                        .fontWeight(.medium)
                        .underline()
                        .foregroundColor(.whiskred)
                        .onTapGesture {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                }
                .padding()
                
                // Enhanced calendar icon with background
                ZStack {
                    Circle()
                        .fill(Color.whiskred.opacity(0.1))
                        .frame(width: 130, height: 130)
                    
                    Image(systemName: "calendar.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.whiskred)
                        .shadow(color: .whiskred.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                
                Text("\(currentName ?? "Your cat") is currently")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.whiskred)
                
                // Enhanced age display card
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
                
                // Enhanced birthdate info with card background
                VStack(spacing: 8) {
                    Text("🎂")
                        .font(.system(size: 30))
                    
                    Text("Born on:")
                        .font(.headline)
                        .foregroundColor(.whiskred)
                    
                    Text(formattedBirthdate())
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
                
                Spacer()
                
                CloseButton {
                    print("close age detail view")
                }
                Spacer()
            }
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
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: birthdate)
    }
    
    // Function to get the stored birthdate as a Date object
    func getStoredBirthdate() -> Date {
        return Date(timeIntervalSince1970: birthdateStorage)
    }
}

#Preview {
    AgeDetailView()
}
