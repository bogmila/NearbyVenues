//
//  HttpService.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//

import Foundation

protocol HttpServiceProtocol {
    func request<T: Decodable>(type: T.Type, parameters: [String: String], completion: @escaping (Result<T, NetworkError>) -> Void)
}

class HttpService: HttpServiceProtocol {
    private enum Constants {
        static let serviceURL = "https://api.foursquare.com/v2/venues/search"
        static let clientID = "CYEMKOM4OLTP5PHMOFVUJJAMWT5CH5G1JBCYREATW21XLLSZ"
        static let clientSecret = "TYPE_CLIENT_SECRET_HERE"
    }

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    private var previousTask: DataTaskProtocol?

    func request<T: Decodable>(type _: T.Type, parameters: [String: String], completion: @escaping (Result<T, NetworkError>) -> Void) {
        previousTask?.cancel()
        var components = URLComponents(string: Constants.serviceURL)!
        components.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        components.queryItems?.append(URLQueryItem(name: "client_id", value: Constants.clientID))
        components.queryItems?.append(URLQueryItem(name: "client_secret", value: Constants.clientSecret))
        components.queryItems?.append(URLQueryItem(name: "v", value: formattedDate()))

        let request = URLRequest(url: components.url!)

        let task = session.dataTask(request: request, completion: { data, response, error in
            guard (error as NSError?)?.code != NSURLErrorCancelled else { return }
            let httpResponse = response as? HTTPURLResponse
            self.handle(data: data, response: httpResponse, error: error, completion: completion)
        })
        task.resume()
        previousTask = task
    }

    private func handle<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard error == nil, let response = response else {
            if (error as NSError?)?.code == NSURLErrorNotConnectedToInternet {
                DispatchQueue.main.async { completion(.failure(.noInternetConnection)) }
            } else {
                DispatchQueue.main.async { completion(.failure(.unknown)) }
            }
            return
        }
        switch response.statusCode {
        case 200 ... 299:
            guard let data = data, let model = try? JSONDecoder().decode(T.self, from: data) else {
                DispatchQueue.main.async { completion(.failure(.unknown)) }
                return
            }
            DispatchQueue.main.async { completion(.success(model)) }
        default:
            DispatchQueue.main.async { completion(.failure(.unknown)) }
        }
    }

    private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMDD"
        return dateFormatter.string(from: Date())
    }
}
