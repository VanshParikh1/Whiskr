//
//  BreedDetailView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-19.
//

import SwiftUI

struct BreedDetailView: View {
    @AppStorage("name") var currentName: String?
    @AppStorage("breed") var currentBreed: String?
    
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
                    Text("Breed")
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
                            // Add haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                }
                .padding()
                
                // Enhanced paw print with animation
                ZStack {
                    Circle()
                        .fill(Color.whiskred.opacity(0.1))
                        .frame(width: 140, height: 140)
                        .scaleEffect(isAnimated ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimated)
                    
                    Image(systemName: "pawprint.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.whiskred)
                        .shadow(color: .whiskred.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .onAppear {
                    isAnimated = true
                }
                
                Text("\(currentName ?? "Your cat") is a")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .foregroundColor(.whiskred)
                
                // Enhanced breed display card
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
                        .shadow(color: Color.whiskred.opacity(0.4), radius: 15, x: 0, y: 8)
                    
                    // Decorative elements
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "pawprint")
                                .foregroundColor(.white.opacity(0.2))
                                .font(.title)
                                .offset(x: -20, y: 20)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "pawprint")
                                .foregroundColor(.white.opacity(0.2))
                                .font(.caption)
                                .offset(x: 20, y: -20)
                            Spacer()
                        }
                    }
                    .frame(width: 350, height: 200)
                    
                    VStack(spacing: 8) {
                        Text("\(currentBreed ?? "Unknown Breed")")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 60, height: 2)
                            .cornerRadius(1)
                    }
                }
                
                // Fun breed fact or characteristics (placeholder)
                VStack(spacing: 8) {
                    Text("🐱")
                        .font(.system(size: 40))
                    
                    Text("Every breed has its own personality!")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.whiskred.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .italic()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.7))
                        .shadow(color: .whiskred.opacity(0.2), radius: 8, x: 0, y: 4)
                )
                
                Spacer()
                    .frame(height:20)
                
                CloseButton {
                    print("close breed detail view")
                }
                Spacer()
                    .frame(height:20)
            }
        }
    }
}

#Preview {
    BreedDetailView()
}
