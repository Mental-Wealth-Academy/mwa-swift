import SwiftUI

struct DailyNotesCardView: View {
    @State private var isExpanded = false
    @State private var noteText = ""
    let weekColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Compact header
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Morning Pages")
                            .font(.headline(15))
                            .foregroundStyle(Color.textPrimary)

                        Text("Daily writing — no prompts, no grades.")
                            .font(.body(12))
                            .foregroundStyle(Color.textMuted)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.textMuted)
                }
                .padding(14)
                .background(Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(weekColor.opacity(0.25), lineWidth: 1.5)
                )
            }
            .buttonStyle(.plain)

            // Expanded editor
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    TextEditor(text: $noteText)
                        .font(.body(15))
                        .foregroundStyle(Color.textPrimary)
                        .frame(minHeight: 160)
                        .padding(4)

                    HStack {
                        Spacer()
                        Button("Save") {
                            // Save note — hook into API
                            withAnimation { isExpanded = false }
                        }
                        .font(.body(14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(weekColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(14)
                .background(Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
