import Foundation

enum APIError: LocalizedError {
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case networkError(Error)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidResponse:       return "Invalid server response."
        case .httpError(let code):   return "Server error \(code)."
        case .decodingError(let e):  return "Data error: \(e.localizedDescription)"
        case .networkError(let e):   return "Network error: \(e.localizedDescription)"
        case .unauthorized:          return "Please log in to continue."
        }
    }
}

@MainActor
final class APIClient: ObservableObject {
    static let shared = APIClient()
    private let session = URLSession.shared

    // Injected by AuthManager after login
    var authToken: String?

    private init() {}

    // MARK: - Generic request

    func get<T: Decodable>(_ path: String, as type: T.Type = T.self) async throws -> T {
        let request = buildRequest(path: path, method: "GET")
        return try await perform(request, as: type)
    }

    func post<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body,
        as type: Response.Type = Response.self
    ) async throws -> Response {
        var request = buildRequest(path: path, method: "POST")
        request.httpBody = try JSONEncoder().encode(body)
        return try await perform(request, as: type)
    }

    // MARK: - Helpers

    private func buildRequest(path: String, method: String) -> URLRequest {
        var request = URLRequest(url: Endpoint.url(path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    private func perform<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T {
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if http.statusCode == 401 { throw APIError.unauthorized }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.httpError(http.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(type, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
