import Foundation
import Privy

// AuthManager wraps the Privy iOS SDK and exposes a clean interface
// to the rest of the app via @EnvironmentObject.

@MainActor
final class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isReady: Bool = false
    @Published var currentUser: AppUser?
    @Published var authError: String?

    private let privy: Privy
    private let api = APIClient.shared

    init() {
        privy = Privy(config: PrivyConfig(
            appId: Configuration.privyAppId,
            appClientId: Configuration.privyClientId
        ))

        // Listen for auth state changes
        Task {
            await refreshAuthState()
        }
    }

    // MARK: - Login

    func sendEmailCode(to email: String) async throws {
        try await privy.email.sendCode(to: email)
    }

    func loginWithEmailCode(_ code: String, sentTo email: String) async throws {
        let authState = try await privy.email.loginWithCode(code, sentTo: email)
        await handleAuthState(authState)
    }

    func logout() async {
        await privy.logout()
        isAuthenticated = false
        currentUser = nil
        api.authToken = nil
    }

    // MARK: - Token

    var accessToken: String? {
        get async {
            try? await privy.fetchAuthToken()
        }
    }

    // MARK: - Private

    private func refreshAuthState() async {
        let state = await privy.authState
        await handleAuthState(state)
        isReady = true
    }

    private func handleAuthState(_ state: AuthState) async {
        switch state {
        case .authenticated(let session):
            isAuthenticated = true
            let token = session.authToken
            api.authToken = token
            await fetchCurrentUser()
        case .unauthenticated:
            isAuthenticated = false
            api.authToken = nil
            currentUser = nil
        case .notReady:
            break
        @unknown default:
            break
        }
    }

    private func fetchCurrentUser() async {
        do {
            let response = try await api.get(Endpoint.me, as: MeResponse.self)
            currentUser = response.user
        } catch {
            authError = error.localizedDescription
        }
    }
}

// MARK: - Config

enum Configuration {
    static let privyAppId: String = {
        ProcessInfo.processInfo.environment["PRIVY_APP_ID"]
        ?? Bundle.main.infoDictionary?["PRIVY_APP_ID"] as? String
        ?? ""
    }()

    static let privyClientId: String = {
        ProcessInfo.processInfo.environment["PRIVY_CLIENT_ID"]
        ?? Bundle.main.infoDictionary?["PRIVY_CLIENT_ID"] as? String
        ?? ""
    }()
}
