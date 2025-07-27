//
//  ContentView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-07-26.
//

import SwiftUI
import SwiftData

struct WhiskrTabView: View {
    
    var body: some View {
        ZStack{
            
            TabView{
                HomeProfileView()
                    .tabItem{
                        Label("HOME", systemImage: "house")

                    }
                MeoView()
                    .tabItem{
                        Label("Dr.MEO", systemImage: "cat")
                    }
                
                LitterCalendarView()
                    .tabItem{
                        Label("LITTER", systemImage: "toilet")
                    }
            }
            .accentColor(.white)
        }
        
        
    }
}

#Preview {
    WhiskrTabView()
        .modelContainer(for: Item.self, inMemory: true)
}
