//
//  URLSessionProtocol.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 23/11/2019.
//
import Foundation

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> ()
    func dataTask(request: URLRequest, completion: @escaping DataTaskResult) -> DataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completion: @escaping DataTaskResult) -> DataTaskProtocol {
        return dataTask(with: request, completionHandler: completion)
    }
}
