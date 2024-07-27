import Foundation

struct MovieCategory: Decodable {

    // MARK: - Properties

    let category: String
    var open: Bool

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case category = "Category"
        case open = "Open"
    }
}
