import Foundation

/// Abstração para permitir mocar o `URLSession` nos testes unitários.
protocol NetworkSession {
    func executeRequest(with url: URL, onComplete: @escaping ((Data?, URLResponse?, Error?) -> Void))
}
