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
    
    // Editing state
    @State private var isEditing = false
    @State private var searchText = ""
    @State private var breeds: [String] = []
    @State private var selectedBreed: String?
    
    @State private var isAnimated = false
    
    // Computed property for filtered breeds
    private var filteredBreeds: [String] {
        if searchText.isEmpty {
            return breeds
        } else {
            return breeds.filter { $0.localizedCaseInsensitiveContains(searchText) }
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
            
            VStack(spacing: 20){
                HStack{
                    Text("Breed")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.whiskred)
                    Spacer()
                    
                    Button(action: {
                        if isEditing {
                            // Save the selected breed
                            if let selectedBreed = selectedBreed {
                                currentBreed = selectedBreed
                            }
                        } else {
                            // Load current breed for editing
                            selectedBreed = currentBreed
                            searchText = ""
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
                
                
                
                Text(isEditing ? "What is \(currentName ?? "your cat")'s breed?" : "\(currentName ?? "Your cat") is a")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .foregroundColor(.whiskred)
                
                if isEditing {
                    // Breed editing interface
                    VStack(spacing: 15) {
                        // Search field
                        TextField("Search for breed...", text: $searchText)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .whiskred.opacity(0.2), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                        
                        // Breed list
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.9))
                                .frame(height: 350)
                                .shadow(color: .whiskred.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            VStack {
                                Text("Select Breed")
                                    .font(.headline)
                                    .foregroundColor(.whiskred)
                                    .padding(.top)
                                
                                List {
                                    ForEach(filteredBreeds, id: \.self) { breed in
                                        HStack {
                                            Text(breed)
                                                .foregroundColor(.whiskred)
                                            Spacer()
                                            if breed == selectedBreed {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.whiskred)
                                                    .fontWeight(.bold)
                                            }
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            selectedBreed = breed
                                            
                                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                            impactFeedback.impactOccurred()
                                        }
                                    }
                                }
                                .listStyle(.plain)
                                .frame(height: 280)
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        // Show selected breed preview
                        if let selectedBreed = selectedBreed {
                            Text("Selected: \(selectedBreed)")
                                .font(.subheadline)
                                .foregroundColor(.whiskred.opacity(0.8))
                                .fontWeight(.medium)
                        }
                        
                        HStack(spacing: 15) {
                            Button("Cancel") {
                                isEditing = false
                                selectedBreed = currentBreed  // Reset to original
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.whiskred)
                            .cornerRadius(30)
                            
                            Button("Save Breed") {
                                currentBreed = selectedBreed
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
                    // Enhanced breed display card (view mode)
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
                }
            
                Spacer()
                   
            }
        }
        .onAppear {
            if breeds.isEmpty {
                breeds = loadBreeds()
            }
        }
    }
}

// MARK: - Functions
extension BreedDetailView {
  
    func loadBreeds() -> [String] {
        guard let url = Bundle.main.url(forResource: "cat-breeds", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            print("⚠️ Failed to load breeds.json")
            return []
        }
        return decoded
    }}

#Preview {
    BreedDetailView()
}
