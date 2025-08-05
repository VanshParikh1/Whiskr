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
            WhiskrTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
