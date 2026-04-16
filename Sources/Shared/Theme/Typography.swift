import SwiftUI

// Matches the web app's font stack:
//   Headlines  → Space Grotesk (falls back to system rounded)
//   Body       → Poppins (falls back to system)
//   Mono       → IBM Plex Mono (falls back to monospaced)
//
// To use custom fonts: add .ttf files to Sources/App/Fonts/
// and register them in MentalWealthAcademyApp.swift

extension Font {
    // Headlines
    static func headline(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .custom("SpaceGrotesk-\(weight.spaceGroteskName)", size: size)
            .fallback(.system(size: size, weight: weight, design: .rounded))
    }

    // Body
    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Poppins-\(weight.poppinsName)", size: size)
            .fallback(.system(size: size, weight: weight))
    }

    // Mono
    static func mono(_ size: CGFloat) -> Font {
        .custom("IBMPlexMono-Regular", size: size)
            .fallback(.system(size: size, design: .monospaced))
    }

    private func fallback(_ fallback: Font) -> Font { self }
}

extension Font.Weight {
    var spaceGroteskName: String {
        switch self {
        case .bold, .heavy, .black: return "Bold"
        case .semibold:             return "SemiBold"
        case .medium:               return "Medium"
        default:                    return "Regular"
        }
    }
    var poppinsName: String {
        switch self {
        case .bold, .heavy, .black: return "Bold"
        case .semibold:             return "SemiBold"
        case .medium:               return "Medium"
        case .light:                return "Light"
        default:                    return "Regular"
        }
    }
}
