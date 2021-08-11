import Foundation

/// Abstração para permitir mocar o `ListContactService` nos testes unitários.
protocol ListContactServiceProtocol {
    func fetchContacts(completion: @escaping (Result<[Contact], NetworkErrors>) -> Void)
}

class ListContactService: ListContactServiceProtocol {

    private let session: NetworkSession
    private let decoder: JSONDecoder

    init(urlSession: NetworkSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = urlSession
        self.decoder = decoder
    }

    func fetchContacts(completion: @escaping (Result<[Contact], NetworkErrors>) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/1d9c3bbe-eb63-4d09-980a-989ad740a9ac") else {
            completion(.failure(.invalidURL))
            return
        }

        session.executeRequest(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard let jsonData = data else {
                completion(.failure(.emptyResponse))
                return
            }

            do {
                let decoded = try self.decoder.decode([Contact].self, from: jsonData)
                completion(.success(decoded))
            } catch let error {
                completion(.failure(.jsonDecoding(message: error.localizedDescription)))
            }
        }
    }
}

