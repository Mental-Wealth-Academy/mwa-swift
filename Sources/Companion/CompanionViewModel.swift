import Foundation
import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let sender: Sender
    let timestamp: Date

    enum Sender { case user, azura }
}

@MainActor
final class CompanionViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(
            text: "hey. what's on your mind?",
            sender: .azura,
            timestamp: Date()
        )
    ]
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false
    @Published var error: String?

    private let api = APIClient.shared

    func send() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        inputText = ""
        let userMsg = ChatMessage(text: text, sender: .user, timestamp: Date())
        messages.append(userMsg)
        isTyping = true

        do {
            let body = ChatRequest(message: text, conversationHistory: recentHistory())
            let response = try await api.post(Endpoint.chat, body: body, as: ChatResponse.self)
            isTyping = false
            let azuraMsg = ChatMessage(text: response.response, sender: .azura, timestamp: Date())
            messages.append(azuraMsg)
        } catch {
            isTyping = false
            self.error = error.localizedDescription
        }
    }

    private func recentHistory() -> [[String: String]] {
        messages.suffix(10).map { msg in
            ["role": msg.sender == .user ? "user" : "assistant", "content": msg.text]
        }
    }
}

private struct ChatRequest: Encodable {
    let message: String
    let conversationHistory: [[String: String]]
}

private struct ChatResponse: Decodable {
    let response: String
}
