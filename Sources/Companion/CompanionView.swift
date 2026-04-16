import SwiftUI

struct CompanionView: View {
    @StateObject private var vm = CompanionViewModel()
    @FocusState private var inputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.messages) { msg in
                            MessageBubbleView(message: msg)
                                .id(msg.id)
                        }

                        if vm.isTyping {
                            TypingIndicatorView()
                                .id("typing")
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                }
                .onChange(of: vm.messages.count) { _ in
                    withAnimation(.easeOut(duration: 0.25)) {
                        if let last = vm.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: vm.isTyping) { typing in
                    if typing {
                        withAnimation { proxy.scrollTo("typing", anchor: .bottom) }
                    }
                }
            }

            Divider().foregroundStyle(Color.borderLight)

            // Input bar
            inputBar
        }
        .background(Color.appBackground)
        .alert("Error", isPresented: Binding(
            get: { vm.error != nil },
            set: { if !$0 { vm.error = nil } }
        )) {
            Button("OK") { vm.error = nil }
        } message: {
            Text(vm.error ?? "")
        }
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask anything...", text: $vm.inputText, axis: .vertical)
                .font(.body(15))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1...5)
                .focused($inputFocused)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.borderLight, lineWidth: 1)
                )
                .onSubmit {
                    Task { await vm.send() }
                }

            Button {
                Task { await vm.send() }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(vm.inputText.isEmpty ? Color.borderLight : Color.academyBlue)
            }
            .disabled(vm.inputText.isEmpty || vm.isTyping)
            .animation(.easeInOut(duration: 0.15), value: vm.inputText.isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.surface)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
    }
}
