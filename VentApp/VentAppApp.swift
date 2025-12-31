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
