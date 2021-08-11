
struct Contact: Decodable, Equatable {
    let id: Int
    let name: String
    let photoURL: String

    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}
