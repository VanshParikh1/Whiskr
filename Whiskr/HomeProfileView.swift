//
//  HomeProfileView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-07-26.
//

import SwiftUI

struct HomeProfileView: View {
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    let healthStats: [HealthStat] = [
            HealthStat(title: "Weight",icon: "dumbbell"),
            HealthStat(title: "Age",icon: "calendar"),
            HealthStat(title: "Breed",icon: "pawprint"),
            HealthStat(title: "Last Vet Visit",icon: "stethoscope")]

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
                    Text("Edit")
                        .foregroundColor(Color(.whiskred))
                        .fontWeight(.bold)
                }
                .padding()
                Circle()
                    .frame(width:250)
                    .foregroundColor(.white)
                    .padding()
           
                LazyVGrid(columns: columns){
                    ForEach(healthStats) { stat in
                        HealthCell(stat: stat)
                    }
                    
                }
                .padding(.horizontal)
                HealthCell(stat: HealthStat(title: "Notes", icon: "text.document"))
                    .padding(.horizontal)
            }
            Spacer()
            
        }
    }
}

struct HealthStat: Identifiable {
    let id = UUID()
    var title: String
    var icon: String
}





#Preview {
    HomeProfileView()
}
