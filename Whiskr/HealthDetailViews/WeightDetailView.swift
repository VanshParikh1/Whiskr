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
    @Environment(\.dismiss) private var dismiss
    
    // Editing state
    @State private var isEditing = false
    @State private var editableWeight: Double = 0.0
    @State private var isAnimated = false

    
    var weightCategory: (emoji: String, status: String, color: Color) {
        let weight = isEditing ? editableWeight : (currentWeight ?? 0)
        
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
                    
                    Button(action: {
                        if isEditing {
                            // Save the weight
                            currentWeight = editableWeight
                        } else {
                            // Load current weight for editing
                            editableWeight = currentWeight ?? 0
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
                
                // Enhanced weight scale icon
                ZStack {
                    Circle()
                        .fill(Color.whiskred.opacity(0.1))
                        .frame(width: 130, height: 130)
                        .scaleEffect(isAnimated ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimated)
                    
                    Image(systemName: "scalemass.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.whiskred)
                        .shadow(color: .whiskred.opacity(0.3), radius: 5, x: 5, y: 3)
                }
                .onAppear {
                    isAnimated = true
                }
                
                Text(isEditing ? "Set \(currentName ?? "your cat")'s weight:" : "As of this month, \(currentName ?? "your cat") weighs:")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.whiskred)
                
                if isEditing {
                    // Weight editing interface
                    VStack(spacing: 20) {
                        // Weight display
                        Text("\(String(format: "%.1f", editableWeight)) lbs")
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .foregroundColor(.whiskred)
                        
                        Text("\(String(format: "%.1f", editableWeight * 0.453592)) kg")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.whiskred.opacity(0.7))
                        
                        // Weight slider
                        VStack {
                            Slider(value: $editableWeight, in: 0...25, step: 0.1)
                                .accentColor(.whiskred)
                                .padding(.horizontal, 30)
                            
                            HStack {
                                Text("0 lbs")
                                    .font(.caption)
                                    .foregroundColor(.whiskred.opacity(0.6))
                                Spacer()
                                Text("25 lbs")
                                    .font(.caption)
                                    .foregroundColor(.whiskred.opacity(0.6))
                            }
                            .padding(.horizontal, 30)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.8))
                                .shadow(color: .whiskred.opacity(0.2), radius: 6, x: 0, y: 3)
                        )
                    }
                    .padding()
                    
                } else {
                    // Enhanced weight display card (view mode)
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
                }
                
                // Weight category indicator (shows real-time feedback during editing)
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
                
                if !isEditing {
                    Text(getWeightComparison())
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.whiskred.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .italic()
                        .padding()
                }
                
                Spacer()
                
                if isEditing {
                    // Cancel and Save buttons
                    HStack(spacing: 15) {
                        Button("Cancel") {
                            isEditing = false
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.whiskred)
                        .cornerRadius(30)
                        
                        Button("Save Weight") {
                            currentWeight = editableWeight
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
            }
        }
        .onAppear {
            editableWeight = currentWeight ?? 0
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
