//
//  WeightDetailView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-19.
//

import SwiftUI

struct WeightDetailView: View {
    @AppStorage("name") var currentName: String?
    @AppStorage("weight") var currentWeight: Double?
    
    var weightCategory: (emoji: String, status: String, color: Color) {
        let weight = currentWeight ?? 0
        
        if weight <= 5 {
            return ("🐱", "Kitten Size", .blue)
        } else if weight <= 8 {
            return ("😊", "Healthy Range", .green)
        } else if weight <= 12 {
            return ("☺️", "Average Size", .orange)
        } else if weight <= 16 {
            return ("😮", "Large Size", .orange)
        } else {
            return ("😳", "DAMN!", .red)
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.whiskrYellow), .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 10){
                HStack{
                    Text("Weight")
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
                
                // Enhanced weight scale icon
                ZStack {
                    Circle()
                        .fill(Color.whiskred.opacity(0.1))
                        .frame(width: 130, height: 130)
                    
                    Image(systemName: "scalemass.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.whiskred)
                        .shadow(color: .whiskred.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                
                Text("As of this month, \(currentName ?? "your cat") weighs:")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.whiskred)
                
                // Enhanced weight display card
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
                    
                    HStack(spacing: 15) {
                        Text("\(String(format: "%.0f", currentWeight ?? 0))")
                            .font(.system(size: 120, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("lbs")
                                .font(.system(size: 48, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text(String(format: "%.1f kg", (currentWeight ?? 0) * 0.453592))
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                
                // Weight category indicator
                VStack(spacing: 10) {
                    Text(weightCategory.emoji)
                        .font(.system(size: 40))
                    
                    Text(weightCategory.status)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(weightCategory.color)
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.8))
                        .shadow(color: .whiskred.opacity(0.2), radius: 6, x: 0, y: 3)
                )
                
        
                
                    
                    
                
                
                Text(getWeightComparison())
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.whiskred.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .italic()
                    .padding()
                Spacer()
                
                CloseButton {
                    print("close weight detail view")
                }
                Spacer()
            }
        }
    }
    
    func getWeightComparison() -> String {
        let weight = currentWeight ?? 0
        
        if weight <= 5 {
            return "Light as a feather! Perfect for tiny paws."
        } else if weight <= 8 {
            return "Just right! Most cats fall in this range."
        } else if weight <= 12 {
            return "A sturdy kitty with some extra cuddles!"
        } else if weight <= 16 {
            return "A big cat with a big personality!"
        } else {
            return "That's one substantial feline friend!"
        }
    }
}

#Preview {
    WeightDetailView()
}
