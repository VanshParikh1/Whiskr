//
//  HomeProfileView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-07-26.
//

import SwiftUI

struct HomeProfileView: View {
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient( colors: [Color(.whiskrYellow), .white]),
                startPoint:.topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Text("Romeo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.white))
                    Spacer()
                }
                .padding()
                Spacer()
                    .frame(height: 650)
                

            }
        }
    }
}

#Preview {
    HomeProfileView()
}
