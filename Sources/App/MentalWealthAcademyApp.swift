import SwiftUI

@main
struct MentalWealthAcademyApp: App {
    @StateObject private var auth = AuthManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
        }
    }
}

// MARK: - Root routing view

private struct RootView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        Group {
            if !auth.isReady {
                SplashView()
            } else if auth.isAuthenticated {
                AppTabView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: auth.isAuthenticated)
        .animation(.easeInOut(duration: 0.25), value: auth.isReady)
    }
}

// MARK: - Splash screen

private struct SplashView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            Image("logo-spacey2k")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .opacity(0.85)
        }
    }
}
