import SwiftUI

struct WeekSelectorView: View {
    @Binding var viewWeek: Int
    let activeWeek: Int
    let weekStatuses: [WeekStatus]
    let isPro: Bool
    let onLockedWeekTapped: () -> Void

    private let totalWeeks = 12

    var body: some View {
        VStack(spacing: 12) {
            // Arrow navigation + week title
            HStack {
                arrowButton(direction: .prev)

                VStack(spacing: 2) {
                    Text("WEEK \(viewWeek)")
                        .font(.body(11, weight: .semibold))
                        .foregroundStyle(Color.textMuted)
                        .tracking(1.2)

                    Text(WeekReading.title(for: viewWeek))
                        .font(.headline(18))
                        .foregroundStyle(Color.textPrimary)
                }
                .frame(maxWidth: .infinity)

                arrowButton(direction: .next)
            }
            .padding(.horizontal, 12)

            // Dot selector
            HStack(spacing: 6) {
                ForEach(1...totalWeeks, id: \.self) { week in
                    dotButton(for: week)
                }
            }
            .padding(.horizontal, 12)
        }
    }

    // MARK: - Sub-views

    private func arrowButton(direction: Direction) -> some View {
        let disabled = direction == .prev ? viewWeek <= 1 : viewWeek >= totalWeeks

        return Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                if direction == .prev, viewWeek > 1 {
                    let target = viewWeek - 1
                    guard canAccess(week: target) else { onLockedWeekTapped(); return }
                    viewWeek = target
                } else if direction == .next, viewWeek < totalWeeks {
                    let target = viewWeek + 1
                    guard canAccess(week: target) else { onLockedWeekTapped(); return }
                    viewWeek = target
                }
            }
        } label: {
            Image(systemName: direction == .prev ? "chevron.left" : "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(disabled ? Color.textMuted.opacity(0.4) : Color.textSecondary)
                .frame(width: 36, height: 36)
        }
        .disabled(disabled)
    }

    private func dotButton(for week: Int) -> some View {
        let isActive = week == viewWeek
        let isSealed = weekStatuses.first(where: { $0.weekNumber == week })?.isSealed ?? false
        let isLocked = !canAccess(week: week)

        return Button {
            if isLocked {
                onLockedWeekTapped()
            } else {
                withAnimation(.easeInOut(duration: 0.15)) { viewWeek = week }
            }
        } label: {
            Circle()
                .fill(dotColor(active: isActive, sealed: isSealed, locked: isLocked))
                .frame(width: isActive ? 10 : 7, height: isActive ? 10 : 7)
                .opacity(isLocked ? 0.35 : 1)
                .animation(.spring(response: 0.3), value: isActive)
        }
        .buttonStyle(.plain)
    }

    private func dotColor(active: Bool, sealed: Bool, locked: Bool) -> Color {
        if sealed { return .sealGreen }
        if active { return .academyBlue }
        return .borderLight
    }

    private func canAccess(week: Int) -> Bool {
        week == 1 || isPro
    }

    enum Direction { case prev, next }
}
