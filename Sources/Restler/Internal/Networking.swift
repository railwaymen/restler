import Foundation

typealias DataResult = Result<Data, Error>
typealias DataCompletion = (DataResult) -> Void

protocol NetworkingType: class {
    var header: [String: String] { get set }
    func makeRequest(url: URL, method: HTTPMethod, completion: @escaping DataCompletion)
}

class Networking {
    private let session: URLSessionType
    
    var header: [String: String] = [:]
    
    // MARK: - Initialization
    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }
}

// MARK: - NetworkingType
extension Networking: NetworkingType {
    func makeRequest(url: URL, method: HTTPMethod, completion: @escaping DataCompletion) {
        guard let request = self.buildURLRequest(url: url, httpMethod: method) else { return completion(.failure(Restler.Error.internalFrameworkError)) }
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
        request.allHTTPHeaderFields = self.header
        return request
    }
    
    private func runDataTask(request: URLRequest, completion: @escaping DataCompletion) {
        let task = self.session.dataTask(with: request) { [weak self] response in
            self?.handleResponse(response: response, completion: completion)
        }
        task.resume()
    }
    
    private func handleResponse(response: HTTPRequestResponse, completion: DataCompletion) {
        guard let data = response.data, response.error == nil, response.response?.isSuccessful ?? false else {
            completion(.failure(self.handle(result: response)))
            return
        }
        completion(.success(data))
    }
    
    private func handle(result: HTTPRequestResponse) -> Error {
        guard let statusCode = result.response?.statusCode else { return Restler.Error.noInternetConnection }
        return Restler.Error(statusCode: statusCode)
    }
}
