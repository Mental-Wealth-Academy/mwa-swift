import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var isSubmitting: Bool = false
    @State private var didSubmit: Bool = false
    @State private var errorMessage: String? = nil

    private let features: [(icon: String, title: String, description: String)] = [
        ("book.closed.fill",       "12-Week Program",      "Full access to every week of curated reading and reflection exercises"),
        ("sparkles",               "Azura AI Coach",       "Unlimited conversations with your personal mental wealth coach"),
        ("flame.fill",             "Streak Tracking",      "Daily accountability with streak calendar and practice history"),
        ("person.3.fill",          "Community Board",      "Connect with fellow scholars on the same journey"),
        ("diamond.fill",           "Earn Shards",          "Collect shards for completed days and climb the leaderboard"),
    ]

    private let api = APIClient.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                header

                // Features list
                VStack(spacing: 12) {
                    ForEach(features, id: \.title) { feature in
                        featureRow(feature)
                    }
                }

                Divider().foregroundStyle(Color.borderLight)

                // Email capture or success
                if didSubmit {
                    successView
                } else {
                    emailForm
                }

                // Back link
                Button {
                    dismiss()
                } label: {
                    Text("Maybe later")
                        .font(.body(14))
                        .foregroundStyle(Color.textMuted)
                }
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
            .padding(.bottom, 24)
        }
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
    }

    // MARK: - Sub-views

    private var header: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.academyBlue.opacity(0.12))
                    .frame(width: 72, height: 72)
                Image(systemName: "lock.open.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(Color.academyBlue)
            }

            Text("Unlock Full Access")
                .font(.headline(26))
                .foregroundStyle(Color.textPrimary)

            Text("Get unrestricted access to the complete 12-week Mental Wealth program.")
                .font(.body(15))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }

    private func featureRow(_ feature: (icon: String, title: String, description: String)) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.academyBlue.opacity(0.10))
                    .frame(width: 40, height: 40)
                Image(systemName: feature.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.academyBlue)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(feature.title)
                    .font(.body(15, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
                Text(feature.description)
                    .font(.body(13))
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(2)
            }

            Spacer()
        }
        .padding(14)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var emailForm: some View {
        VStack(spacing: 14) {
            Text("Join the waitlist")
                .font(.headline(17))
                .foregroundStyle(Color.textPrimary)

            Text("Enter your email to get early access and be notified when PRO launches.")
                .font(.body(13))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            if let err = errorMessage {
                Text(err)
                    .font(.body(13))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            TextField("your@email.com", text: $email)
                .font(.body(15))
                .foregroundStyle(Color.textPrimary)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .padding(.horizontal, 16)
                .padding(.vertical, 13)
                .background(Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.borderLight, lineWidth: 1)
                )

            Button {
                Task { await submit() }
            } label: {
                Group {
                    if isSubmitting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Get Early Access")
                            .font(.body(16, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(email.isValidEmail ? Color.academyBlue : Color.academyBlue.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(!email.isValidEmail || isSubmitting)
            .animation(.easeInOut(duration: 0.15), value: email.isValidEmail)
        }
    }

    private var successView: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.academyBlue)

            Text("You're on the list!")
                .font(.headline(20))
                .foregroundStyle(Color.textPrimary)

            Text("We'll notify you at \(email) when PRO access is available.")
                .font(.body(14))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 16)
    }

    // MARK: - Actions

    private func submit() async {
        guard email.isValidEmail else { return }
        isSubmitting = true
        errorMessage = nil

        struct SubscribeBody: Codable { let email: String }
        struct SubscribeResponse: Codable { let success: Bool? }

        do {
            _ = try await api.post(
                Endpoint.subscribe,
                body: SubscribeBody(email: email),
                as: SubscribeResponse.self
            )
            didSubmit = true
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }

        isSubmitting = false
    }
}

// MARK: - Email validation

private extension String {
    var isValidEmail: Bool {
        let pattern = #"^[^@\s]+@[^@\s]+\.[^@\s]+$"#
        return range(of: pattern, options: .regularExpression) != nil
    }
}
