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
