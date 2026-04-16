import SwiftUI

extension Color {
    // Brand
    static let academyBlue    = Color(hex: "#5168FF")
    static let academyPurple  = Color(hex: "#9B7ED9")

    // Backgrounds
    static let appBackground  = Color(hex: "#FBF8FF")
    static let surface        = Color.white
    static let surfaceMuted   = Color(hex: "#F3EEFF")

    // Text
    static let textPrimary    = Color(hex: "#1A1625")
    static let textSecondary  = Color(hex: "#6B5F85")
    static let textMuted      = Color(hex: "#9B8FB5")

    // Border
    static let borderLight    = Color(hex: "#E8E3F0")

    // Semantic
    static let sealGreen      = Color(hex: "#22C55E")
    static let warningAmber   = Color(hex: "#F5A623")

    // Week accent colors (weeks 1-12)
    static let weekColors: [Color] = [
        Color(hex: "#5168FF"), Color(hex: "#9B7ED9"), Color(hex: "#E85D3A"),
        Color(hex: "#62BE8F"), Color(hex: "#F5A623"), Color(hex: "#E85D9A"),
        Color(hex: "#3AB5E8"), Color(hex: "#8B5CF6"), Color(hex: "#EC4899"),
        Color(hex: "#14B8A6"), Color(hex: "#F97316"), Color(hex: "#6366F1"),
    ]

    static func weekColor(for week: Int) -> Color {
        guard week >= 1, week <= 12 else { return .academyBlue }
        return weekColors[week - 1]
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
