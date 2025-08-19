//
//  NotesDetailView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-08-19.
//

import SwiftUI

struct NotesDetailView: View {
    
    @AppStorage("name") var currentName: String?
    @AppStorage("catNotes") var catNotes: String = ""
    
    @State private var isEditing = false
    @State private var editableNotes = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.whiskrYellow), .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30){
                HStack{
                    Text("Notes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.whiskred)
                    Spacer()
                    
                    Button(action: {
                        if isEditing {
                            // Save notes
                            catNotes = editableNotes
                        } else {
                            // Start editing
                            editableNotes = catNotes
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
                
                // Enhanced notepad icon
                ZStack {
                    Circle()
                        .fill(Color.whiskred.opacity(0.1))
                        .frame(width: 130, height: 130)
                    
                    Image(systemName: "note.text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.whiskred)
                        .shadow(color: .whiskred.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                
                Text("Notes about \(currentName ?? "your cat")")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.whiskred)
                
                // Enhanced notes display/edit area
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: 350, height: 300)
                        .shadow(color: Color.whiskred.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    VStack {
                        if isEditing {
                            TextEditor(text: $editableNotes)
                                .padding()
                                .font(.system(size: 16))
                                .foregroundColor(.whiskred)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                        } else {
                            ScrollView {
                                if catNotes.isEmpty {
                                    VStack(spacing: 15) {
                                        Text("📝")
                                            .font(.system(size: 50))
                                        
                                        Text("No notes yet!")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.whiskred.opacity(0.7))
                                        
                                        Text("Tap 'Edit' to add notes about \(currentName ?? "your cat")'s personality, habits, or anything special!")
                                            .font(.subheadline)
                                            .foregroundColor(.whiskred.opacity(0.6))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                    }
                                    .padding()
                                } else {
                                    Text(catNotes)
                                        .font(.system(size: 16))
                                        .foregroundColor(.whiskred)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                        }
                    }
                    .frame(width: 350, height: 300)
                }
                
                
                Spacer()
                
                CloseButton {
                    // Save any unsaved changes before closing
                    if isEditing {
                        catNotes = editableNotes
                    }
                    print("close notes detail view")
                }
                Spacer()
            }
        }
        .onAppear {
            editableNotes = catNotes
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            if isEditing {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

#Preview {
    NotesDetailView()
}
