import SwiftUI

struct HelperFeedView: View {
    @State private var posts: [Post] = []

    var body: some View {
        NavigationView {
            List(posts) { post in
                VStack(alignment: .leading, spacing: 5) {
                    Text(post.text)
                        .font(.body)
                    if let mood = post.mood {
                        Text("Mood: \(mood)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Vent Feed")
            .onAppear {
                Task {
                    do {
                        posts = try await SupabaseService.shared.fetchPosts()
                    } catch {
                        print("Error fetching posts: \(error)")
                    }
                }
            }
        }
    }
}
