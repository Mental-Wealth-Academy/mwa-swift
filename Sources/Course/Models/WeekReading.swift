import Foundation

struct WeekReading: Identifiable {
    let id: Int           // 0 = intro, 1-12 = weeks
    let title: String
    let category: String
    let description: String
    let mediaURL: String
    let slug: String
    let markdownPath: String

    var isVideo: Bool { mediaURL.hasSuffix(".mp4") }
}

extension WeekReading {
    static let all: [WeekReading] = [
        WeekReading(id: 0, title: "Art is a Spiritual Warfare", category: "Introduction",
                    description: "This week initiates your creative recovery.",
                    mediaURL: "https://i.imgur.com/KkpN9as.png", slug: "art-is-spiritual-warfare",
                    markdownPath: "/readings/art-is-spiritual-warfare.md"),
        WeekReading(id: 1, title: "Recovering a Sense of Safety", category: "Week 1",
                    description: "Establish a foundation of safety to explore your creativity without fear.",
                    mediaURL: "https://i.imgur.com/sRcnrJB.mp4", slug: "recovering-safety",
                    markdownPath: "/readings/recovering-safety.md"),
        WeekReading(id: 2, title: "Recovering a Sense of Identity", category: "Week 2",
                    description: "The gap between human perception and machine processing.",
                    mediaURL: "https://i.imgur.com/0gghyGS.jpeg", slug: "week-two",
                    markdownPath: "/readings/week-two.md"),
        WeekReading(id: 3, title: "Recovering a Sense of Power", category: "Week 3",
                    description: "Anger, synchronicity, and shame surface here.",
                    mediaURL: "https://i.imgur.com/MMb9MTw.png", slug: "recovering-power",
                    markdownPath: "/readings/recovering-power.md"),
        WeekReading(id: 4, title: "Recovering a Sense of Integrity", category: "Week 4",
                    description: "Align your actions with your deepest values.",
                    mediaURL: "https://i.imgur.com/sRNfQyg.png", slug: "recovering-integrity",
                    markdownPath: "/readings/recovering-integrity.md"),
        WeekReading(id: 5, title: "Recovering a Sense of Possibility", category: "Week 5",
                    description: "Dismantle the limits you inherited.",
                    mediaURL: "https://i.imgur.com/rHLvipb.mp4", slug: "recovering-possibility",
                    markdownPath: "/readings/recovering-possibility.md"),
        WeekReading(id: 6, title: "Recovering a Sense of Abundance", category: "Week 6",
                    description: "Scarcity is a story. Rewrite it.",
                    mediaURL: "https://i.imgur.com/DqnZ4P5.jpeg", slug: "recovering-abundance",
                    markdownPath: "/readings/recovering-abundance.md"),
        WeekReading(id: 7, title: "Recovering a Sense of Connection", category: "Week 7",
                    description: "Creativity is not solitary.",
                    mediaURL: "https://i.imgur.com/Nk7ppHa.mp4", slug: "recovering-connection",
                    markdownPath: "/readings/recovering-connection.md"),
        WeekReading(id: 8, title: "Recovering a Sense of Strength", category: "Week 8",
                    description: "Surviving loss of faith. The creative life demands resilience.",
                    mediaURL: "https://i.imgur.com/6x026dv.jpeg", slug: "recovering-strength",
                    markdownPath: "/readings/recovering-strength.md"),
        WeekReading(id: 9, title: "Recovering a Sense of Compassion", category: "Week 9",
                    description: "Fear disguises itself as laziness.",
                    mediaURL: "https://i.imgur.com/Wiv0PnM.png", slug: "recovering-compassion",
                    markdownPath: "/readings/recovering-compassion.md"),
        WeekReading(id: 10, title: "Recovering a Sense of Self-Protection", category: "Week 10",
                    description: "Guard your creative energy.",
                    mediaURL: "https://i.imgur.com/86MQLAz.jpeg", slug: "recovering-self-protection",
                    markdownPath: "/readings/recovering-self-protection.md"),
        WeekReading(id: 11, title: "Recovering a Sense of Autonomy", category: "Week 11",
                    description: "Own your process.",
                    mediaURL: "https://i.imgur.com/RAs9HJk.png", slug: "recovering-autonomy",
                    markdownPath: "/readings/recovering-autonomy.md"),
        WeekReading(id: 12, title: "Recovering a Sense of Faith", category: "Week 12",
                    description: "Trust the path. Faith is what remains when the evidence hasn't arrived yet.",
                    mediaURL: "https://i.imgur.com/Gd2fbry.png", slug: "recovering-faith",
                    markdownPath: "/readings/recovering-faith.md"),
    ]

    static let weekTitles = [
        "Introduction", "Safety", "Identity", "Power", "Integrity",
        "Possibility", "Abundance", "Connection", "Strength",
        "Compassion", "Protection", "Autonomy", "Faith",
    ]

    static func title(for week: Int) -> String {
        guard week >= 0, week < weekTitles.count else { return "" }
        return weekTitles[week]
    }
}
