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
                DrMeoView()
                    .tabItem{
                        Label("Dr.MEO", systemImage: "cat")
                    }
                
                RemindersView()
                    .tabItem{
                        Label("REMINDERS", systemImage: "alarm.fill")
                    }
            }
            .accentColor(.whiskred)
        }
        
        
    }
}

#Preview {
    WhiskrTabView()
        .modelContainer(for: Item.self, inMemory: true)
}
