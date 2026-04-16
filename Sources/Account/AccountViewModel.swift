import Foundation
import SwiftUI

struct DailyNotesResponse: Codable {
    let allWeekPages: [String: [DailyPageEntry]]?
}

struct DailyPageEntry: Codable {
    let day: Int
    let date: String
    let submittedAt: Int?
}

@MainActor
final class AccountViewModel: ObservableObject {
    @Published var streak: Int = 0
    @Published var completedDates: Set<String> = []
    @Published var isLoading: Bool = true

    private let api = APIClient.shared

    func load() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchStreak() }
            group.addTask { await self.fetchNotes() }
        }
        isLoading = false
    }

    private func fetchStreak() async {
        do {
            let r = try await api.get(Endpoint.streak, as: StreakResponse.self)
            streak = r.streak
        } catch {}
    }

    private func fetchNotes() async {
        do {
            let r = try await api.get(Endpoint.dailyNotes, as: DailyNotesResponse.self)
            var dates = Set<String>()
            r.allWeekPages?.values.forEach { entries in
                entries.forEach { entry in dates.insert(entry.date) }
            }
            completedDates = dates
        } catch {}
    }
}
