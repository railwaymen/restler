import Foundation

enum Event {
    case requestCompleted(request: URLRequest, response: HTTPRequestResponse, elapsedTime: Milliseconds)
}
