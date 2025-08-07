//
//  OnboardingView.swift
//  bootcamp
//
//  Created by Vansh Parikh on 2025-07-27.
//

import SwiftUI


struct OnboardingView: View {
    /*
     0 - Welcome screen
     1 - Add name and gender
     2 - Add age
     3 - Add breed
     4 - Add weight
     */
    @State var onboardingState: Int = 4
    
    
    let transition1: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
    
    let transition2: AnyTransition = .asymmetric(
        insertion: .move(edge: .leading),
        removal: .move(edge: .trailing))
    
    @State var transitionState: Int = 0
    
    //onboarding inputs
    
    @State var name: String = ""
    // 0 is Male, 1 is Female
    @State var gender: Int = 0
    @State var birthdate = Date()
    @State var age : [Int] = [0, 0]
    
    @State private var selectedBreed: String = ""
    @State private var searchText = ""
    @State private var breeds: [String] = []
    
    var filteredBreeds: [String] {
        if searchText.isEmpty {
            return breeds
        } else {
            return breeds.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }


    
    //alerts
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    //app storage
    
    @AppStorage("name") var currentUserName: String?
    @AppStorage("gender") var currentGender: Int?
    @AppStorage("age") var currentAge: Int?
    @AppStorage("breed") var currentBreed: String?
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false

    
    var body: some View {
        ZStack {
            //content: changes based on the state we have
            

            ZStack{
                switch onboardingState {
                case 0:
                    welcomeSection
                        .transition(transition1)

                case 1:
                    LinearGradient(
                        gradient: Gradient(colors: [Color.whiskrYellow, Color.white]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                        )
                    if transitionState != 1 {
                        addNameSection
                            .transition(transition1)
                    } else {
                        addNameSection
                            .transition(transition2)
                    }
                    

                case 2:
                    LinearGradient(
                        gradient: Gradient(colors: [Color.whiskrYellow, Color.white]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                        )
                    if transitionState != 1 {
                        addAgeSection
                            .transition(transition1)
                    } else {
                        addAgeSection
                            .transition(transition2)
                    }
                case 3:
                    LinearGradient(
                        gradient: Gradient(colors: [Color.whiskrYellow, Color.white]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                        )
                    if transitionState != 1 {
                        addBreedSection
                            .transition(transition1)
                    } else {
                        addBreedSection
                            .transition(transition2)
                    }
                case 4:
                    LinearGradient(
                        gradient: Gradient(colors: [Color.whiskrYellow, Color.white]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                        )
                    if transitionState != 1 {
                        addWeightSection
                            .transition(transition1)
                    } else {
                        addWeightSection
                            .transition(transition2)
                    }
                    

                
                default:
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.green)
                    
                }
            }
            
            VStack{
                if onboardingState > 0{
                    backButton
                        .padding()
                    Spacer(minLength:640)
                    bottomButton
                    Spacer(minLength: 60)
                } else {
                    Spacer()
                    bottomButton
                }
                
                
            }
            .padding(30)
        }
        .alert(isPresented: $showAlert, content: {
            return Alert(title: Text(alertTitle))
        })
    }
    
    
    
    
}

#Preview {
    OnboardingView()
        .background(Color.whiskrYellow)
}

//: MARK: COMPONENTS
extension OnboardingView {
    //Buttons
    private var bottomButton: some View {
        Text(onboardingState == 0 ? "GET STARTED" :
             onboardingState == 4 ? "Start using Whiskr!" :
             "NEXT")
        .font(.title3)
        .fontWeight(.bold)
            .foregroundColor(.whiskred)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: Color.whiskred.opacity(0.3), radius: 6, x: 0, y: 4)
            .onTapGesture {
                handleNextButtonPressed()
            }
    }
    private var backButton: some View {
        HStack() {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.3))
                .clipShape(Circle())
                .onTapGesture {
                    handleBackButtonPRessed()
                }
            Spacer()
            }
        }
        
    
    //Screens
    private var welcomeSection: some View{
        VStack(spacing: 40){
            Spacer()
            Image("Logo")
            Text("Welcome to WHISKR")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .overlay(
                    Capsule(style: .continuous)
                        .frame(height:3)
                        .offset(y: 5)
                        .foregroundColor(.white)
                    ,alignment: .bottom
                )
            Text("Whiskr helps you keep track of your cat's health, reminds you when it's time to clean the little, and even gives advice when your cat's not feeling their best")
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal)
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
    }
    private var addNameSection: some View {
        VStack(spacing: 40){
            Spacer()
            
            Text("Whats your cat's name?")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            TextField("Your name here ...", text: $name)
                .multilineTextAlignment(.center)
                .font(.headline)
                .frame(height: 55)
                .background(Color.white)
                .cornerRadius(10)
            
            HStack(spacing: 0) {
                ZStack(alignment: gender == 0 ? .leading : .trailing) {
                    Capsule()
                        .fill(Color.white)
                        .frame(width: 150, height: 50)
                        .shadow(radius: 2)
                        .animation(.easeInOut(duration: 0.3), value: gender)
                    
                    HStack(spacing: 0) {
                        ForEach(0..<2) { index in
                            let option = index == 0 ? "Male" : "Female"
                            Text(option)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(gender == index ? .whiskrYellow : Color.white)
                                .font(.headline)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        gender = index
                                    }
                                }
                        }
                    }
                }
            } //Gender Picker
            .frame(height: 50)
            .background(Color.whiskred.opacity(0.8))
            .clipShape(Capsule())
            .padding(.horizontal, 30)
            
            
            
            
            Spacer()
        }
        .padding(30)
    }
    private var addAgeSection: some View{
        VStack(spacing: 20){
            Spacer()
            
            Text("When is \(name)'s birthday?")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            
            ZStack{
                Rectangle()
                    .frame(height: 320)
                    .cornerRadius(30)
                    .foregroundColor(.white)
                VStack{
                    CustomDatePicker(date: $birthdate)
                        .onChange(of: birthdate) {
                            let x = getAge(from: birthdate)
                            age[0] = x.years
                            age[1] = x.months
                        }
                    Text("\(name) is \(age[0]) years and \(age[1]) months old!")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.whiskred)
                }
                
                
            }
            
            
            
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    private var addBreedSection: some View {
        VStack {
            Spacer()
            Text("What is \(name)'s breed?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            TextField("Search for breed...", text: $searchText)
                .padding()
                .background(Color(.white))
                .cornerRadius(10)
                .padding()

            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .frame(height: 300)
                
                VStack {
                    List {
                        ForEach(filteredBreeds, id: \.self) { breed in
                            HStack {
                                Text(breed)
                                Spacer()
                                if breed == selectedBreed {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedBreed = breed
                            }
                        }
                    }
                    .foregroundColor(.whiskred)
                    .listStyle(.plain)
                    .frame(height: 250)
                }
                .padding()
            }

          Spacer(minLength: 250)

        }
        .padding(30)
        .onAppear {
            if breeds.isEmpty {
                breeds = loadBreeds()
            }
        
        }
    }
    private var addWeightSection: some View {
        VStack{
            Text("How much does \(name) weight?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
    
   

    
    
}

// MARK: FUNCTIONS

extension OnboardingView{
    

    func getAge(from birthdate: Date) -> (years: Int, months: Int) {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month], from: birthdate, to: now)
        
        return (components.year ?? 0, components.month ?? 0)
    }

    func handleNextButtonPressed() {
        
        //CHECK INPUTS
        switch onboardingState {
        case 1:
            guard name.count >= 1 else {
                showAlert(title: "Your name must be atleast 3 characters long 😜 ")
                return
            }
        case 2:
            guard age[0] > 0 || age[1] > 0 else {
                showAlert(title: "Please enter a valid birthdate 🥸")
                return
            }
        case 3:
            guard selectedBreed.count >= 1 else {
                showAlert(title: "Please select a breed 🐈")
                return

            }
        default:
            break
        }
    
        
        //GO TO NEXT SECTION
        if onboardingState == 4 {
            //sign in
            signIn()
        } else {
            transitionState = 0
            withAnimation(.spring()){
                onboardingState += 1
            }
        }
        
    }
    
    func handleBackButtonPRessed() {
        if onboardingState != 0 {
            transitionState = 1
            withAnimation(.spring()){
                onboardingState -= 1
            }
        }
    }
    
    func signIn() {
        currentAge = age[0]
        currentUserName = name
        currentGender = gender
        
        withAnimation(.spring()) {
            currentUserSignedIn = true
        }
    }
    
    func showAlert(title: String){
        alertTitle = title
        showAlert.toggle()
    }
    
    func loadBreeds() -> [String] {
        guard let url = Bundle.main.url(forResource: "cat-breeds", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            print("⚠️ Failed to load breeds.json")
            return []
        }
        return decoded
    }

}

