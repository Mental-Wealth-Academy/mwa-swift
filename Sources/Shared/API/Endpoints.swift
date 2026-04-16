import Foundation

enum Endpoint {
    static let baseURL = "https://mentalwealthacademy.world"

    // Auth & user
    static let me            = "/api/me"
    static let profile       = "/api/profile"
    static let season        = "/api/season"
    static let leaderboard   = "/api/leaderboard"

    // Course progress
    static let progressAll   = "/api/ethereal-progress/all"

    // Daily notes
    static let dailyNotes    = "/api/daily-notes"
    static let streak        = "/api/daily-notes/streak"

    // Chat
    static let chat          = "/api/chat/blue"

    // Paywall
    static let subscribe     = "/api/subscribe"

    static func url(_ path: String) -> URL {
        URL(string: baseURL + path)!
    }
}
