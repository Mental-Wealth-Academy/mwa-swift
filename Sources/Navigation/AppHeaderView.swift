import SwiftUI

struct AppHeaderView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Image("logo-spacey2k")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 34)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.surface)

            Divider()
                .foregroundStyle(Color.borderLight)
        }
    }
}
