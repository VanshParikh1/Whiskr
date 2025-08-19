//
//  WhiskrApp.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-07-26.
//

import SwiftUI
import SwiftData

@main


struct WhiskrApp: App {
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false



    init(){
       

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color(.tabYellow))
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if currentUserSignedIn {
                    WhiskrTabView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .top),
                            removal: .move(edge: .bottom)))
                        .ignoresSafeArea()
                } else {
                    OnboardingView()
                        .background(.whiskrYellow)
                        .ignoresSafeArea()
                        .transition(.asymmetric(
                            insertion: .move(edge: .top),
                            removal: .move(edge: .bottom)))
                }
            }
            .animation(.easeInOut, value: currentUserSignedIn)
        }
        .modelContainer(sharedModelContainer)
    }
}
