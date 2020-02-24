import Foundation

typealias DataResult = Result<Data, Error>
typealias DataCompletion = (DataResult) -> Void

protocol NetworkingType {
    func get(url: URL, completion: @escaping DataCompletion)
}

class Networking {}

// MARK: - Structures
extension Networking {}

// MARK: - NetworkingType
extension Networking: NetworkingType {
    func get(url: URL, completion: @escaping DataCompletion) {
        guard let request = self.buildURLRequest(url: url, httpMethod: .get) else { return completion(.failure(Restler.Error.internalFrameworkError)) }
        self.runDataTask(request: request, completion: completion)
    }
}

// MARK: - Private
extension Networking {
    private func buildURLRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
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
        return Restler.Error(statusCode: result.response?.statusCode ?? 15)
    }
}

// MARK: - Private Structures
extension Networking {
    private enum HTTPMethod {
        case get
        
        var name: String {
            switch self {
            case .get: return "GET"
            }
        }
    }
    
    private struct HTTPRequestResponse {
        let data: Data?
        let response: HTTPURLResponseType?
        let error: Error?
    }
}
