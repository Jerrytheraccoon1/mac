import Foundation

struct Post: Codable, Identifiable {
    var id: UUID? = UUID()
    var text: String
    var mood: String?
}
