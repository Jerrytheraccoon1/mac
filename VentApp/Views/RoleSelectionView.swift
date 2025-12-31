import SwiftUI

struct RoleSelectionView: View {
    @State private var role: String?

    var body: some View {
        VStack(spacing: 40) {
            Text("Choose your role")
                .font(.largeTitle)

            Button("I want to Vent") {
                role = "venter"
            }

            Button("I want to Help") {
                role = "helper"
            }
        }
        .fullScreenCover(item: $role) { selectedRole in
            if selectedRole == "venter" {
                VenterView()
            } else {
                HelperFeedView()
            }
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}
