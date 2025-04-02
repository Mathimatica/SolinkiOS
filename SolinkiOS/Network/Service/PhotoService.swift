import Combine
import Foundation

class PhotoService {
    static let shared = PhotoService()
    private let baseURL = "https://api.pexels.com/"
    private let session: URLSession
    
    func request<T: Decodable>(
        _ endpoint: String,
        method: String,
        queryParams: [String: Any]? = nil,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) -> AnyPublisher<T, Error> {
        guard let url = buildURL(endpoint: endpoint, queryParams: queryParams) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        do {
            let request = try buildRequest(
                url: url,
                method: method,
                headers: headers,
                parameters: parameters
            )
            
            return session.dataTaskPublisher(for: request)
                .tryMap { data, response -> Data in
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                        let errorString = String(data: data, encoding: .utf8) ?? "Unknown error"
                        throw NetworkError.httpError(statusCode, errorString)
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        session = URLSession(configuration: configuration)
    }
    
    private func buildURL(endpoint: String, queryParams: [String: Any]? = nil) -> URL? {
        var urlComponents = URLComponents(string: "\(baseURL)\(endpoint)")
        
        if let queryParams = queryParams {
            urlComponents?.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: "\(String(describing: $0.value))")
            }
        }
        
        return urlComponents?.url
    }
    
    private func buildRequest(
        url: URL,
        method: String,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.jsonEncodingError(error)
            }
        }
        
        return request
    }
}
