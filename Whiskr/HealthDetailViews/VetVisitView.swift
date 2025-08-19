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
                
                // Enhanced stethoscope icon
                ZStack {
                    Circle()
                        .fill(Color.whiskred.opacity(0.1))
                        .frame(width: 130, height: 130)
                    
                    Image(systemName: "stethoscope.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.whiskred)
                        .shadow(color: .whiskred.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                
                Text("It has been")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.whiskred)
                
                // Enhanced days counter card
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
                    
                    Text("Last visit was on:")
                        .font(.headline)
                        .foregroundColor(.whiskred)
                    
                    Text(formattedLastVetVisit())
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
                    print("close vet visit view")
                }
                Spacer()
            }
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
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: lastVisitDate)
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
