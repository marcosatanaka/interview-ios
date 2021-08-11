import XCTest
@testable import Interview

class ListContactServiceTests: XCTestCase {

    private var session: NetworkSessionMock!
    private var listContactService: ListContactService!

    private var mockResponseData: Data? = {
        """
        [{
          "id": 2,
          "name": "Beyonce",
          "photoURL": "https://api.adorable.io/avatars/285/a2.png"
        }]
        """.data(using: .utf8)
    }()

    private let expectedContact = Contact(id: 2,
                                          name: "Beyonce",
                                          photoURL: "https://api.adorable.io/avatars/285/a2.png")

    override func setUp() {
        session = NetworkSessionMock()
        listContactService = ListContactService(urlSession: session)
    }

    func testSuccessfulResponse() {
        session.data = mockResponseData

        listContactService.fetchContacts { result in
            switch result {
            case .failure(let error):
                XCTFail("Fetch contacts failed: \(error.localizedDescription)")
            case .success(let contacts):
                XCTAssertEqual(contacts, [self.expectedContact])
            }
        }
    }

}

// MARK: - NetworkSessionMock

class NetworkSessionMock: NetworkSession {
    var data: Data?
    var error: Error?

    func executeRequest(with url: URL, onComplete: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        onComplete(data, nil, error)
    }
}
