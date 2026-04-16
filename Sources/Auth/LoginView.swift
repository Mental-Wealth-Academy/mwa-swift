import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var email: String = ""
    @State private var code: String = ""
    @State private var step: Step = .email
    @State private var isLoading = false
    @State private var errorMessage: String?

    enum Step { case email, code }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo
                Image("logo-spacey2k")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                    .padding(.bottom, 48)

                // Card
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step == .email ? "Welcome back." : "Check your email.")
                            .font(.headline(24))
                            .foregroundStyle(Color.textPrimary)

                        Text(step == .email
                             ? "Enter your email to continue."
                             : "We sent a code to \(email)")
                            .font(.body(14))
                            .foregroundStyle(Color.textMuted)
                    }

                    if step == .email {
                        emailField
                    } else {
                        codeField
                    }

                    if let error = errorMessage {
                        Text(error)
                            .font(.body(13))
                            .foregroundStyle(.red)
                    }

                    primaryButton
                }
                .padding(24)
                .background(Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.textPrimary.opacity(0.06), radius: 20, y: 8)
                .padding(.horizontal, 24)

                Spacer()

                // Footer
                Text("A 12-week guided transformation program\nwith a built-in AI coach.")
                    .font(.body(12))
                    .foregroundStyle(Color.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Sub-views

    private var emailField: some View {
        TextField("your@email.com", text: $email)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            .padding(14)
            .background(Color.surfaceMuted)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .font(.body(15))
    }

    private var codeField: some View {
        HStack(spacing: 12) {
            TextField("6-digit code", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .padding(14)
                .background(Color.surfaceMuted)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .font(.body(15))

            Button("Resend") {
                Task { await sendCode() }
            }
            .font(.body(13, weight: .medium))
            .foregroundStyle(Color.academyBlue)
        }
    }

    private var primaryButton: some View {
        Button {
            Task {
                if step == .email { await sendCode() }
                else { await verifyCode() }
            }
        } label: {
            ZStack {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(step == .email ? "Continue" : "Verify Code")
                        .font(.body(15, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.academyBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isLoading || (step == .email ? email.isEmpty : code.isEmpty))
        .opacity((step == .email ? email.isEmpty : code.isEmpty) ? 0.6 : 1)
    }

    // MARK: - Actions

    private func sendCode() async {
        isLoading = true
        errorMessage = nil
        do {
            try await auth.sendEmailCode(to: email.trimmingCharacters(in: .whitespaces))
            step = .code
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func verifyCode() async {
        isLoading = true
        errorMessage = nil
        do {
            try await auth.loginWithEmailCode(code, sentTo: email)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
