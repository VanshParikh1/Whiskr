//
//  HomeProfileView.swift
//  Whiskr
//
//  Created by Vansh Parikh on 2025-07-26.
//

import SwiftUI



struct HomeProfileView: View {
    
    @AppStorage("name") var currentName: String?
    @AppStorage("gender") var currentGender: String?
    @AppStorage("age") var currentAge: Int?
    @AppStorage("breed") var currentBreed: String?
    @AppStorage("weight") var currentWeight: Double?
    @AppStorage("vetVisit")  var vetVisit: String = ""
    
    @State private var showingSheet: Bool = false
    @State private var selectedStat: HealthStat? = nil
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    let healthStats: [HealthStat] = [
        HealthStat(title: "Weight",icon: "dumbbell"),
        HealthStat(title: "Age",icon: "calendar"),
        HealthStat(title: "Breed",icon: "pawprint"),
        HealthStat(title: "Last Vet Visit",icon: "stethoscope"),
    ]
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.whiskrYellow), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack{
                HStack{
                    Text(currentName ?? "Your Cat")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.whiskred)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 100)
                
                Divider()
                    .padding(.bottom, 40)
                
                
                
                CatProfilePhotoView()
                    .padding()
                
                LazyVGrid(columns: columns) {
                    ForEach(healthStats) { stat in
                        HealthCell(stat: stat)
                            .onTapGesture {
                                selectedStat = stat
                                showingSheet = true
                            }
                    }
                }
                .padding(.horizontal)
                
                HealthCell(stat: HealthStat(title: "Notes", icon: "text.document"))
                .padding(.horizontal)
                .onTapGesture {
                    selectedStat = HealthStat(title: "Notes", icon: "text.document")
                    showingSheet = true
                }

                
                Spacer(minLength: 150)
                
            }
            .sheet(item: $selectedStat) { stat in
                switch stat.title {
                    case "Weight":
                        WeightDetailView()
                        CloseButton{
                            selectedStat = nil
                        }
                    case "Age":
                        AgeDetailView()
                        CloseButton{
                            selectedStat = nil
                        }
                    case "Breed":
                        BreedDetailView()
                        CloseButton{
                            selectedStat = nil
                        }
                    case "Last Vet Visit":
                        VetVisitDetailView()
                        CloseButton{
                            selectedStat = nil
                        }
                    case "Notes":
                        NotesDetailView()
                        CloseButton{
                            selectedStat = nil
                        }
                    default:
                        WeightDetailView()
                        CloseButton{
                            selectedStat = nil
                        }

                    }
                }
        }
    }
}

// Enum to track which health stat is being edited
enum HealthStatType: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    
    case weight
    case age
    case breed
    case vetVisit
    case notes
    
    var healthStat: HealthStat {
        switch self {
        case .weight: return HealthStat(title: "Weight", icon: "dumbbell")
        case .age: return HealthStat(title: "Age", icon: "calendar")
        case .breed: return HealthStat(title: "Breed", icon: "pawprint")
        case .vetVisit: return HealthStat(title: "Last Vet Visit", icon: "stethoscope")
        case .notes: return HealthStat(title: "Notes", icon: "text.document")
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
