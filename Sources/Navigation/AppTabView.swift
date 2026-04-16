import SwiftUI

enum AppTab: Int, CaseIterable {
    case course, companion, account

    var label: String {
        switch self {
        case .course:    return "Course"
        case .companion: return "Companion"
        case .account:   return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .course:    return "book.fill"
        case .companion: return "bubble.left.and.bubble.right.fill"
        case .account:   return "person.circle.fill"
        }
    }

    var inactiveIcon: String {
        switch self {
        case .course:    return "book"
        case .companion: return "bubble.left.and.bubble.right"
        case .account:   return "person.circle"
        }
    }
}

struct AppTabView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var selectedTab: AppTab = .course

    var body: some View {
        VStack(spacing: 0) {
            AppHeaderView()

            TabView(selection: $selectedTab) {
                CourseView()
                    .tag(AppTab.course)

                CompanionView()
                    .tag(AppTab.companion)

                AccountView()
                    .tag(AppTab.account)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.2), value: selectedTab)

            AppTabBarView(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.appBackground)
    }
}

// MARK: - Custom Tab Bar

struct AppTabBarView: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        VStack(spacing: 0) {
            Divider().foregroundStyle(Color.borderLight)

            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    tabButton(for: tab)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
            .background(Color.surface)
        }
    }

    private func tabButton(for tab: AppTab) -> some View {
        let isActive = selectedTab == tab

        return Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 3) {
                Image(systemName: isActive ? tab.icon : tab.inactiveIcon)
                    .font(.system(size: 24))
                    .foregroundStyle(isActive ? Color.academyBlue : Color.textMuted)

                Text(tab.label)
                    .font(.body(10, weight: isActive ? .semibold : .medium))
                    .foregroundStyle(isActive ? Color.academyBlue : Color.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
