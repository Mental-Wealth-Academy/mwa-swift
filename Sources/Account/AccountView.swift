import SwiftUI

struct AccountView: View {
    @EnvironmentObject var auth: AuthManager
    @StateObject private var vm = AccountViewModel()
    @State private var showSignOutAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile header
                profileHeader

                // Streak panel
                streakPanel

                // Calendar
                StreakCalendarView(completedDates: vm.completedDates)

                // Sign out
                Button {
                    showSignOutAlert = true
                } label: {
                    Text("Sign Out")
                        .font(.body(15, weight: .medium))
                        .foregroundStyle(Color.textMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
        }
        .background(Color.appBackground)
        .alert("Sign Out", isPresented: $showSignOutAlert) {
            Button("Sign Out", role: .destructive) {
                Task { await auth.logout() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You will need to log in again to continue your course.")
        }
        .task { await vm.load() }
        .refreshable { await vm.load() }
    }

    // MARK: - Sub-views

    private var profileHeader: some View {
        HStack(spacing: 14) {
            // Avatar
            Circle()
                .fill(Color(hex: auth.currentUser?.avatarColor ?? "#5168FF"))
                .frame(width: 56, height: 56)
                .overlay(
                    Text(auth.currentUser?.displayName.prefix(1).uppercased() ?? "?")
                        .font(.headline(22))
                        .foregroundStyle(.white)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(auth.currentUser?.displayName ?? "Scholar")
                    .font(.headline(18))
                    .foregroundStyle(Color.textPrimary)

                if let shards = auth.currentUser?.shardCount {
                    HStack(spacing: 4) {
                        Image(systemName: "diamond.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.academyBlue)
                        Text("\(shards) Shards")
                            .font(.body(13))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }

            Spacer()

            if auth.currentUser?.isPro == true {
                Text("PRO")
                    .font(.body(10, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.academyBlue)
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var streakPanel: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(vm.streak)")
                        .font(.headline(40))
                        .foregroundStyle(Color.academyBlue)
                    Text("day streak")
                        .font(.body(16))
                        .foregroundStyle(Color.textMuted)
                }

                Text(vm.streak > 0
                     ? "Keep going — write again tomorrow."
                     : "Write morning pages daily to build your streak.")
                    .font(.body(13))
                    .foregroundStyle(Color.textMuted)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "flame.fill")
                .font(.system(size: 48))
                .foregroundStyle(
                    LinearGradient(colors: [.orange, .yellow], startPoint: .bottom, endPoint: .top)
                )
                .opacity(vm.streak > 0 ? 1 : 0.25)
        }
        .padding(16)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
