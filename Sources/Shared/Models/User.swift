import Foundation

struct AppUser: Codable, Identifiable {
    let id: String
    let username: String?
    let avatarUrl: String?
    let shardCount: Int
    let isPro: Bool
    let createdAt: String?

    var displayName: String {
        guard let name = username, !name.hasPrefix("user_") else { return "Scholar" }
        return name.prefix(1).uppercased() + name.dropFirst()
    }

    var avatarURL: URL? {
        guard let urlStr = avatarUrl else { return nil }
        return URL(string: urlStr)
    }

    // Deterministic avatar color based on username
    var avatarColor: String {
        let colors = ["#5168FF", "#E85D3A", "#62BE8F", "#9B7ED9", "#F5A623"]
        let name = username ?? "user"
        var hash = 0
        for char in name.unicodeScalars {
            hash = Int(char.value) + ((hash << 5) - hash)
        }
        return colors[abs(hash) % colors.count]
    }
}

struct MeResponse: Codable {
    let user: AppUser?
}
