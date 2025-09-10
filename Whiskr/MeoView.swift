import SwiftUI

struct MeoView: View {
    @AppStorage("name") var catName: String?
    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer: Bool = false
    @State private var showDisclaimer = false
    
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.whiskrYellow), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        
                        Text("Dr.Meo")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(.whiskred)
                        
                        Spacer()
                        
                        Image("MeoLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    }
                    .padding()
                    
                    Divider()
                }
                
                // Chat messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if messages.isEmpty {
                                VStack(spacing: 15) {
                                    Image(systemName: "heart.circle.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.whiskred.opacity(0.3))
                                    
                                    Text("Hi! I'm Dr.Meo, your virtual cat assistant. How can I help you today?")
                                        .font(.title3)
                                        .foregroundColor(.whiskred)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Describe any symptoms you noticed, and I'll provide guidance on what to do next.")
                                        .font(.body)
                                        .foregroundColor(.whiskred)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .padding(.top, 50)
                            } else {
                                ForEach(messages) { message in
                                    MessageBubble(message: message)
                                        .id(message.id)
                                }
                            }
                            
                            if isLoading {
                                LoadingBubble()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                    .onChange(of: isLoading) { _ in
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("loading", anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input Area
            VStack {
                Spacer()
                Divider()
                    .background(Color.whiskred.opacity(0.3))
                
                HStack(spacing: 12) {
                    TextField("Ask a question...", text: $inputText, axis: .vertical)
                        .lineLimit(1...4)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.8))
                        )
                        .disabled(isLoading)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(inputText.isEmpty || isLoading ? .gray : .whiskred)
                    }
                    .disabled(inputText.isEmpty || isLoading)
                }
                .padding()
            }
        }
        .onAppear {
            if !hasSeenDisclaimer {
                showDisclaimer = true
            }
        }
        .fullScreenCover(isPresented: $showDisclaimer) {
            DisclaimerView {
                hasSeenDisclaimer = true
                showDisclaimer = false
            }
        }
    }
    
    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(content: inputText.trimmingCharacters(in: .whitespacesAndNewlines), isFromUser: true)
        messages.append(userMessage)
        
        let messageToSend = inputText
        inputText = ""
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let aiResponse = ChatMessage(
                content: "Thank you for describing those symptoms. Based on what you've told me, I recommend monitoring \(catName ?? "your cat") closely and contacting your veterinarian if symptoms worsen. This is a placeholder response - we'll connect this to a real AI service next!",
                isFromUser: false
            )
            messages.append(aiResponse)
            isLoading = false
        }
    }
}

// Disclaimer screen
struct DisclaimerView: View {
    var onAgree: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.whiskrYellow), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.whiskred)
                
                Text("Important Info 🐾")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.whiskred)
                
                VStack(spacing: 12) {
                    Text("Dr. Meo can give you helpful guidance, but isn’t a replacement for a veterinarian.")
                    Text("For any serious symptoms or emergencies, please contact your vet right away.")
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.whiskred)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: onAgree) {
                    Text("Got it!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.whiskred)
                        .cornerRadius(20)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            
            // AI Message (Dr. Meo)
            if !message.isFromUser {
                Image("MeoLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.whiskred, lineWidth: 1))
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(message.isFromUser ? Color.white.opacity(0.9) : Color.whiskred.opacity(0.9))
                    )
                    .foregroundColor(message.isFromUser ? .whiskred : .white)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.whiskred.opacity(0.6))
                    .padding(.horizontal, 4)
            }
            
            // User Message (aligned right, no avatar)
            if message.isFromUser {
                Spacer(minLength: 40) // keeps spacing consistent
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isFromUser ? .trailing : .leading)
    }
}

struct LoadingBubble: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.whiskred.opacity(0.6))
                            .frame(width: 8, height: 8)
                            .scaleEffect(animationAmount)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: animationAmount
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.9))
                )
            }
            
            Spacer(minLength: 50)
        }
        .id("loading")
        .onAppear {
            animationAmount = 1.0
        }
    }
}

// MARK: - Chat Message Model
struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let timestamp: Date
    
    init(content: String, isFromUser: Bool) {
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = Date()
    }
}

#Preview {
    MeoView()
}
