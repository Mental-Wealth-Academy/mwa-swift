import Foundation

struct SeasonResponse: Codable {
    let currentWeek: Int
    let weekEndsAt: String?
    let seasonActive: Bool
}

struct WeekStatus: Codable, Identifiable {
    let weekNumber: Int
    let isSealed: Bool
    let sealTxHash: String?

    var id: Int { weekNumber }
}

struct WeekStatusResponse: Codable {
    let weeks: [WeekStatus]
}

struct LeaderboardUser: Codable, Identifiable {
    let rank: Int
    let username: String
    let avatarUrl: String?
    let shards: Int

    var id: Int { rank }

    var avatarURL: URL? {
        guard let str = avatarUrl else { return nil }
        return URL(string: str)
    }
}

struct LeaderboardResponse: Codable {
    let users: [LeaderboardUser]
}

struct StreakResponse: Codable {
    let streak: Int
}
