#!/bin/bash

BASE="VentApp"

mkdir -p "$BASE"/Models
mkdir -p "$BASE"/Views
mkdir -p "$BASE"/Services

# VentAppApp.swift
cat <<EOL > "$BASE/VentAppApp.swift"
import SwiftUI
import Supabase

@main
struct VentAppApp: App {

    init() {
        SupabaseService.shared.setup()
    }

    var body: some Scene {
        WindowGroup {
            RoleSelectionView()
        }
    }
}
EOL

# Models/Post.swift
cat <<EOL > "$BASE/Models/Post.swift"
import Foundation

struct Post: Codable, Identifiable {
    var id: UUID? = UUID()
    var text: String
    var mood: String?
}
EOL

# Services/SupabaseService.swift
cat <<EOL > "$BASE/Services/SupabaseService.swift"
import Foundation
import Supabase

class SupabaseService {

    static let shared = SupabaseService()
    private init() {}

    private let url = URL(string: "https://cuxjvhnsugkkmvvuouyr.supabase.co")!
    private let key = "sb_publishable_pWbVjpym1AL8gAtxvcDmrQ_k2X3_sD3"

    var client: SupabaseClient!

    func setup() {
        client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }

    func createPost(_ post: Post) async throws {
        try await client.from("posts").insert(post).execute()
    }

    func fetchPosts() async throws -> [Post] {
        let response = try await client.from("posts").select().order("created_at", ascending: false).execute()
        return response.value ?? []
    }
}
EOL

# Views/RoleSelectionView.swift
cat <<EOL > "$BASE/Views/RoleSelectionView.swift"
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
        .fullScreenCover(item: \$role) { selectedRole in
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
EOL

# Views/VenterView.swift
cat <<EOL > "$BASE/Views/VenterView.swift"
import SwiftUI

struct VenterView: View {
    @State private var text = ""
    @State private var mood = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("How do you feel?", text: \$text)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Mood (optional)", text: \$mood)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Post") {
                Task {
                    let post = Post(text: text, mood: mood.isEmpty ? nil : mood)
                    do {
                        try await SupabaseService.shared.createPost(post)
                        text = ""
                        mood = ""
                    } catch {
                        print("Error posting: \\(error)")
                    }
                }
            }
        }
        .padding()
    }
}
EOL

# Views/HelperFeedView.swift
cat <<EOL > "$BASE/Views/HelperFeedView.swift"
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
                        Text("Mood: \\(mood)")
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
                        print("Error fetching posts: \\(error)")
                    }
                }
            }
        }
    }
}
EOL

echo "✅ VentApp files created successfully in $BASE/"
