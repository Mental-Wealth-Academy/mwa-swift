import SwiftUI

struct LeaderboardSheet: View {
    let users: [LeaderboardUser]
    let activeWeek: Int
    let seasonActive: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Podium — top 3
                    if users.count >= 3 {
                        PodiumView(users: Array(users.prefix(3)))
                            .padding(.vertical, 20)
                    }

                    Divider().padding(.horizontal)

                    // Full list
                    LazyVStack(spacing: 0) {
                        ForEach(users) { user in
                            LeaderboardRowView(user: user)
                            Divider().padding(.leading, 60)
                        }
                    }
                }
            }
            .navigationTitle("Top Academics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body(15, weight: .medium))
                }
            }
            .safeAreaInset(edge: .top) {
                if seasonActive {
                    Text("Week \(activeWeek) of 12")
                        .font(.body(12))
                        .foregroundStyle(Color.textMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Color.surface)
                }
            }
        }
    }
}

struct PodiumView: View {
    let users: [LeaderboardUser]

    var body: some View {
        HStack(alignment: .bottom, spacing: 20) {
            if users.count > 1 { podiumSlot(user: users[1], height: 56, rank: 2) }
            if users.count > 0 { podiumSlot(user: users[0], height: 72, rank: 1) }
            if users.count > 2 { podiumSlot(user: users[2], height: 44, rank: 3) }
        }
    }

    private func podiumSlot(user: LeaderboardUser, height: CGFloat, rank: Int) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(Color(hex: user.avatarColor))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(user.username.prefix(1).uppercased())
                        .font(.headline(16))
                        .foregroundStyle(.white)
                )
                .overlay(Circle().stroke(Color.academyBlue.opacity(rank == 1 ? 1 : 0), lineWidth: 2))

            Text(user.username)
                .font(.body(11, weight: .medium))
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.academyBlue.opacity(rank == 1 ? 1 : 0.4))
                .frame(width: 48, height: height)
        }
    }
}

struct LeaderboardRowView: View {
    let user: LeaderboardUser

    var body: some View {
        HStack(spacing: 12) {
            Text("\(user.rank)")
                .font(.mono(14))
                .foregroundStyle(Color.textMuted)
                .frame(width: 24, alignment: .trailing)

            Circle()
                .fill(Color(hex: user.avatarColor))
                .frame(width: 36, height: 36)
                .overlay(
                    Text(user.username.prefix(1).uppercased())
                        .font(.headline(14))
                        .foregroundStyle(.white)
                )

            Text(user.username)
                .font(.body(14, weight: .medium))
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Text("\(user.shards) Shards")
                .font(.body(13))
                .foregroundStyle(Color.textMuted)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

extension LeaderboardUser {
    var avatarColor: String {
        let colors = ["#5168FF", "#E85D3A", "#62BE8F", "#9B7ED9", "#F5A623"]
        var hash = 0
        for char in username.unicodeScalars {
            hash = Int(char.value) + ((hash << 5) - hash)
        }
        return colors[abs(hash) % colors.count]
    }
}
