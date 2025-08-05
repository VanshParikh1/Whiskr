//
//  HealthDetailView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-07-27.
//

import SwiftUI

struct HealthDetailView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color(.whiskred))
                .ignoresSafeArea()
            VStack{
                HStack{
                    Label("Weight", systemImage: "dumbbell")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                Spacer()
                
                Text("Romeo weighs 20lbs")

            }
        }
    }
}

#Preview {
    HealthDetailView()
}
