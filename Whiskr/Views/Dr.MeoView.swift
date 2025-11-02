import SwiftUI

let apiKey = Secrets.gptApiKey

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

// MARK: - OpenAI Response Model (GPT-5 format)
struct OpenAIResponse: Codable {
    struct Output: Codable {
        struct Content: Codable {
            let type: String
            let text: String?
        }
        let type: String
        let content: [Content]?
    }
    let output: [Output]
}

// MARK: - OpenAI Error Response Model
struct OpenAIErrorResponse: Codable {
    struct ErrorDetail: Codable {
        let message: String
        let type: String
        let param: String?
        let code: String?
    }
    let error: ErrorDetail
}

// MARK: - Main MeoView
struct DrMeoView: View {
    @AppStorage("name") var catName: String?
    @AppStorage("gender") var catGender: String?
    
    @AppStorage("age") var catAge: Int?
    
    @AppStorage("breed") var catBreed: String?
    @AppStorage("weight") var catWeight: Double?
    
    @AppStorage("lastVetVisit") var lastVetVisit: Double = Date().timeIntervalSince1970
    
    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer: Bool = false
    @State private var showDisclaimer = false
    
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isLoading = false
    
    //For keyboard input
    @FocusState private var isInputFocused: Bool

    
    // Dr.Meo personality prompt
    private let drMeoPersonality = """
    You are Dr.Meo, a friendly cat health assistant. Respond in under 100 words.
    """
    
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
                            .font(.system(size: 50))
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
                    .padding(.horizontal)
                    
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
                        .focused($isInputFocused)

                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(inputText.isEmpty || isLoading ? .gray : .whiskred)
                    }
                    .disabled(inputText.isEmpty || isLoading)
                }
                .padding()
            }
        }
        .onTapGesture {
            isInputFocused = false
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
    
    // MARK: - Send Message Function
    private func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let userMessage = ChatMessage(content: trimmed, isFromUser: true)
        messages.append(userMessage)
        
        let messageToSend = trimmed
        inputText = ""
        isLoading = true
        
        // Build cat info string
        let catInfo = """
    Cat: \(catName ?? "Unknown"), \(catGender ?? "Unknown"), \(catBreed ?? "Unknown breed"), \
    \(catWeight ?? 0)lbs, Age: \(catAge ?? 0) years
    """
        
        sendToGPT5Mini(userMessage: messageToSend, catInfo: catInfo) { responseText in
            DispatchQueue.main.async {
                let aiResponse = ChatMessage(content: responseText, isFromUser: false)
                messages.append(aiResponse)
                isLoading = false
            }
        }
    }
    
    // MARK: - GPT-5 Mini/Nano API Call
    private func sendToGPT5Mini(userMessage: String, catInfo: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/responses") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-5-mini",
            "input": [
                [
                    "role": "system",
                    "content": """
    You are Dr.Meo, a friendly cat health assistant.

    STRICT RULES:
    - Keep under 100 words
    - Use the cat's name (\(catName ?? "your kitty")) when giving advice
    - Format naturally: "[Cat name] may be [symptom] because of [causes]. Take [cat name] to the vet if [warning signs]."
    - Be conversational, not clinical
    - Avoid bullet points or arrows (→)
    - Conclude the conversation revolving around hoping the cat gets better
    
    For casual messages (greetings, thanks, chitchat):
    - Respond warmly and naturally
    - Keep it brief and friendly
    - Use cat puns occasionally 🐾
    - No need for medical format

    Cat Info: \(catInfo)
    """
                ],
                [
                    "role": "user",
                    "content": userMessage
                ]
            ],
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion("Error contacting Dr.Meo 😿")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API response: \(jsonString)")
            }
            
            if let decoded = try? JSONDecoder().decode(OpenAIResponse.self, from: data) {
                if let messageOutput = decoded.output.first(where: { $0.type == "message" }),
                   let text = messageOutput.content?.first(where: { $0.type == "output_text" })?.text {
                    // Truncate if still too long
                    let words = text.split(separator: " ")
                    if words.count > 100 {
                        let truncated = words.prefix(100).joined(separator: " ") + "..."
                        completion(truncated)
                    } else {
                        completion(text)
                    }
                } else {
                    completion("Dr.Meo didn't send a readable message 😿")
                }
            } else if let errorResponse = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data) {
                completion("Error: \(errorResponse.error.message)")
            } else {
                completion("Unexpected response from Dr.Meo 😿")
            }
        }.resume()
    }
// MARK: - DisclaimerView
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
                    Text("Dr. Meo can give you helpful guidance, but isn't a replacement for a veterinarian.")
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

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !message.isFromUser {
                Image("MeoLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.whiskred, lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.whiskred.opacity(0.9))
                        )
                        .foregroundColor(.white)
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.whiskred.opacity(0.6))
                        .padding(.horizontal, 4)
                }
                
                Spacer(minLength: 40)
            }
            
            if message.isFromUser {
                Spacer(minLength: 40)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.9))
                        )
                        .foregroundColor(.whiskred)
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.whiskred.opacity(0.6))
                        .padding(.horizontal, 4)
                }
            }
        }
    }
}

// MARK: - Loading Bubble
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
}
    

// MARK: - Preview
#Preview {
    DrMeoView()
}
