import SwiftUI

struct VenterView: View {
    @State private var text = ""
    @State private var mood = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("How do you feel?", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Mood (optional)", text: $mood)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Post") {
                Task {
                    let post = Post(text: text, mood: mood.isEmpty ? nil : mood)
                    do {
                        try await SupabaseService.shared.createPost(post)
                        text = ""
                        mood = ""
                    } catch {
                        print("Error posting: \(error)")
                    }
                }
            }
        }
        .padding()
    }
}
