import Foundation

/// Implementa conformidade com o protocolo `NetworkSession`, onde simplesmente
/// executa o request utilizando os métodos padrão do `URLSession`.
extension URLSession: NetworkSession {

    func executeRequest(with url: URL, onComplete: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        let task = dataTask(with: url) { data, response, error in
            onComplete(data, response, error)
        }
        task.resume()
    }

}
