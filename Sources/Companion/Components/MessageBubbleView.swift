import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage

    private var isUser: Bool { message.sender == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 48) }

            if !isUser {
                // Azura avatar
                Circle()
                    .fill(Color.academyBlue.opacity(0.12))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.academyBlue)
                    )
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 3) {
                Text(message.text)
                    .font(.body(15))
                    .foregroundStyle(isUser ? Color.white : Color.textPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isUser ? Color.academyBlue : Color.surface)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                    .shadow(color: Color.textPrimary.opacity(isUser ? 0 : 0.05), radius: 4, y: 2)

                Text(message.timestamp, style: .time)
                    .font(.body(10))
                    .foregroundStyle(Color.textMuted)
                    .padding(.horizontal, 4)
            }

            if !isUser { Spacer(minLength: 48) }
        }
    }
}

struct TypingIndicatorView: View {
    @State private var phase: Int = 0

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Circle()
                .fill(Color.academyBlue.opacity(0.12))
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.academyBlue)
                )

            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(Color.textMuted)
                        .frame(width: 7, height: 7)
                        .scaleEffect(phase == i ? 1.3 : 0.8)
                        .animation(
                            .easeInOut(duration: 0.4)
                                .repeatForever()
                                .delay(Double(i) * 0.15),
                            value: phase
                        )
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Color.textPrimary.opacity(0.05), radius: 4, y: 2)

            Spacer(minLength: 48)
        }
        .onAppear {
            withAnimation { phase = 0 }
            // Cycle 0→1→2→0...
            let timer = Timer.scheduledTimer(withTimeInterval: 0.45, repeats: true) { _ in
                Task { @MainActor in phase = (phase + 1) % 3 }
            }
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}
