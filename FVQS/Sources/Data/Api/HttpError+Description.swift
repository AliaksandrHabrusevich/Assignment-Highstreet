import Foundation

extension HttpServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest(let error):
            return error?.localizedDescription ?? NSLocalizedString("Invalid request", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "")
        case .jsonDecodingError(let error):
            return error.localizedDescription
        case .dataLoadingError(_, let data):
            let decoder = JSONDecoder()
            do {
                let errorModel = try decoder.decode(ErrorModel.self, from: data)
                return errorModel.message
            } catch {
                return NSLocalizedString("Someting went wrong", comment: "")
            }
        }
    }
}

private struct ErrorModel: Decodable {
    let error: Int
    let message: String
}
