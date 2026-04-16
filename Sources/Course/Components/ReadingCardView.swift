import SwiftUI

struct ReadingCardView: View {
    let reading: WeekReading
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Media thumbnail
                AsyncImage(url: URL(string: reading.mediaURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Color.surfaceMuted
                    default:
                        Color.borderLight.overlay(ProgressView().scaleEffect(0.7))
                    }
                }
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(reading.category)
                        .font(.body(11, weight: .semibold))
                        .foregroundStyle(Color.academyBlue)
                        .tracking(0.8)

                    Text(reading.title)
                        .font(.headline(15))
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(2)

                    Text(reading.description)
                        .font(.body(12))
                        .foregroundStyle(Color.textMuted)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.textMuted)
            }
            .padding(14)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.textPrimary.opacity(0.05), radius: 8, y: 3)
        }
        .buttonStyle(.plain)
    }
}
