import SwiftUI

struct CourseView: View {
    @EnvironmentObject var auth: AuthManager
    @StateObject private var vm = CourseViewModel()
    @State private var showLeaderboard = false
    @State private var showPaywall = false
    @State private var dragOffset: CGFloat = 0

    private var isPro: Bool { auth.currentUser?.isPro ?? false }
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let time = hour < 12 ? "Morning" : hour < 18 ? "Afternoon" : "Evening"
        if let name = auth.currentUser?.displayName { return "Good \(time), \(name)" }
        return "Good \(time)"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                heroRow
                DailyNotesCardView(weekColor: .weekColor(for: vm.viewWeek))
                WeekSelectorView(
                    viewWeek: $vm.viewWeek,
                    activeWeek: vm.activeWeek,
                    weekStatuses: vm.weekStatuses,
                    isPro: isPro,
                    onLockedWeekTapped: { showPaywall = true }
                )
                weekContent
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
        }
        .background(Color.appBackground)
        .gesture(swipeGesture)
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardSheet(
                users: vm.leaderboard,
                activeWeek: vm.activeWeek,
                seasonActive: vm.seasonActive
            )
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .task { await vm.load() }
        .refreshable { await vm.load() }
    }

    // MARK: - Sub-views

    private var heroRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.headline(20))
                    .foregroundStyle(Color.textPrimary)

                HStack(spacing: 4) {
                    Text("\(vm.streakCount)")
                        .font(.body(22, weight: .bold))
                        .foregroundStyle(Color.academyBlue)
                    Text("day streak")
                        .font(.body(14))
                        .foregroundStyle(Color.textMuted)
                }
            }

            Spacer()

            Button { showLeaderboard = true } label: {
                HStack(spacing: -6) {
                    ForEach(vm.leaderboard.prefix(3)) { user in
                        Circle()
                            .fill(Color(hex: user.avatarColor))
                            .frame(width: 30, height: 30)
                            .overlay(Circle().stroke(Color.surface, lineWidth: 2))
                            .overlay(
                                Text(user.username.prefix(1).uppercased())
                                    .font(.body(11, weight: .semibold))
                                    .foregroundStyle(.white)
                            )
                    }
                }
            }
        }
    }

    private var weekContent: some View {
        VStack(spacing: 16) {
            if vm.isLoading {
                weekContentSkeleton
            } else {
                let reading = WeekReading.all[min(vm.viewWeek, WeekReading.all.count - 1)]
                ReadingCardView(reading: reading) {
                    // Open reader / visual novel
                }

                WeekTasksPlaceholder(
                    weekNumber: vm.viewWeek,
                    weekColor: .weekColor(for: vm.viewWeek)
                )
            }
        }
    }

    private var weekContentSkeleton: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.borderLight)
                .frame(height: 100)
                .shimmer()
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.borderLight)
                .frame(height: 200)
                .shimmer()
        }
    }

    // MARK: - Swipe gesture

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 40, coordinateSpace: .local)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = abs(value.translation.height)
                guard abs(horizontal) > vertical else { return }

                if horizontal < 0, vm.viewWeek < 12 {
                    let next = vm.viewWeek + 1
                    if next > 1 && !isPro { showPaywall = true; return }
                    withAnimation(.easeInOut(duration: 0.2)) { vm.viewWeek = next }
                } else if horizontal > 0, vm.viewWeek > 1 {
                    withAnimation(.easeInOut(duration: 0.2)) { vm.viewWeek -= 1 }
                }
            }
    }
}

// Placeholder until WeekTasksView is fully ported
struct WeekTasksPlaceholder: View {
    let weekNumber: Int
    let weekColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Week \(weekNumber) Tasks")
                    .font(.headline(16))
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Text("IN PROGRESS")
                    .font(.body(10, weight: .semibold))
                    .tracking(0.8)
                    .foregroundStyle(weekColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(weekColor.opacity(0.1))
                    .clipShape(Capsule())
            }

            ForEach(0..<3) { i in
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.borderLight)
                        .frame(width: 20, height: 20)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.borderLight)
                        .frame(height: 14)
                }
            }
        }
        .padding(16)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(weekColor.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Shimmer modifier

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: phase - 0.2),
                        .init(color: .white.opacity(0.5), location: phase),
                        .init(color: .clear, location: phase + 0.2),
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .animation(.linear(duration: 1.2).repeatForever(autoreverses: false), value: phase)
            )
            .onAppear { phase = 1.2 }
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
