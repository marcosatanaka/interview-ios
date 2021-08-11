import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case emptyResponse
    case jsonDecoding(message: String)
}
