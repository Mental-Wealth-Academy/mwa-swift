import Foundation
import SwiftUI

@MainActor
final class CourseViewModel: ObservableObject {
    @Published var activeWeek: Int = 1
    @Published var viewWeek: Int = 1
    @Published var weekStatuses: [WeekStatus] = []
    @Published var leaderboard: [LeaderboardUser] = []
    @Published var streakCount: Int = 0
    @Published var seasonActive: Bool = false
    @Published var isLoading: Bool = true
    @Published var error: String?

    private let api = APIClient.shared

    func load() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchSeason() }
            group.addTask { await self.fetchProgress() }
            group.addTask { await self.fetchLeaderboard() }
            group.addTask { await self.fetchStreak() }
        }
        isLoading = false
    }

    func weekStatus(for week: Int) -> WeekStatus? {
        weekStatuses.first { $0.weekNumber == week }
    }

    func canAccess(week: Int, isPro: Bool) -> Bool {
        week == 1 || isPro
    }

    // MARK: - Private fetches

    private func fetchSeason() async {
        do {
            let season = try await api.get(Endpoint.season, as: SeasonResponse.self)
            activeWeek = max(season.currentWeek, 1)
            viewWeek = max(season.currentWeek, 1)
            seasonActive = season.seasonActive
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func fetchProgress() async {
        do {
            let response = try await api.get(Endpoint.progressAll, as: WeekStatusResponse.self)
            weekStatuses = response.weeks
        } catch {}
    }

    private func fetchLeaderboard() async {
        do {
            let response = try await api.get(Endpoint.leaderboard, as: LeaderboardResponse.self)
            leaderboard = response.users
        } catch {}
    }

    private func fetchStreak() async {
        do {
            let response = try await api.get(Endpoint.streak, as: StreakResponse.self)
            streakCount = response.streak
        } catch {}
    }
}
