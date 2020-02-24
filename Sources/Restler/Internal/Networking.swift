import Foundation

typealias DataResult = Result<Data, Error>
typealias DataCompletion = (DataResult) -> Void

protocol NetworkingType {
    func get(url: URL, query: [String: String?], completion: @escaping DataCompletion)
}

class Networking {}

// MARK: - Structures
extension Networking {}

// MARK: - NetworkingType
extension Networking: NetworkingType {
    func get(url: URL, query: [String: String?], completion: @escaping DataCompletion) {
        guard let request = self.buildURLRequest(url: url, httpMethod: .get(query: query)) else { return completion(.failure(Restler.Error.internalFrameworkError)) }
        self.runDataTask(request: request, completion: completion)
    }
}

// MARK: - Private
extension Networking {
    private func buildURLRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComponents.queryItems = httpMethod.query?.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.name
        return request
    }
    
    private func runDataTask(request: URLRequest, completion: @escaping DataCompletion) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] (optionalData, optionalResponse, optionalError) in
            let response = HTTPRequestResponse(data: optionalData, response: optionalResponse as? HTTPURLResponseType, error: optionalError)
            self?.handleResponse(response: response, completion: completion)
        }
        task.resume()
    }
    
    private func handleResponse(response: HTTPRequestResponse, completion: DataCompletion) {
        guard let data = response.data, response.error == nil, response.response?.isSuccessful ?? false else {
            let error = self.handle(result: response)
            completion(.failure(error))
            return
        }
        completion(.success(data))
    }
    
    private func handle(result: HTTPRequestResponse) -> Error {
        guard let statusCode = result.response?.statusCode else { return Restler.Error.noInternetConnection }
        return Restler.Error(statusCode: statusCode)
    }
}

// MARK: - Private Structures
extension Networking {
    private enum HTTPMethod {
        case get(query: [String: String?])
        
        var name: String {
            switch self {
            case .get: return "GET"
            }
        }
        
        var query: [String: String?]? {
            switch self {
            case let .get(query): return query
            }
        }
    }
    
    private struct HTTPRequestResponse {
        let data: Data?
        let response: HTTPURLResponseType?
        let error: Error?
    }
}
