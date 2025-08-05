//
//  HealthCell.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-07-27.
//

import SwiftUI

struct HealthCell: View{
    //Age, Breed, Weight, Photo,Notes,Last vet visit
    var stat: HealthStat
    
    
    
    var body: some View {
        ZStack{
            Rectangle()
                    .frame(height: 100)
                    .cornerRadius(20)
                    .foregroundColor(Color(.whiskred))
            Label(stat.title, systemImage: stat.icon)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        
    }
}



#Preview {
    HealthCell(stat: HealthStat(title: "Weight", icon: "dumbbell"))
}
