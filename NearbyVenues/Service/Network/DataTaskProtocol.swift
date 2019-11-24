//
//  DataTaskProtocol.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 23/11/2019.
//
import Foundation

protocol DataTaskProtocol: class {
    func resume()
    func cancel()
}

extension URLSessionDataTask: DataTaskProtocol {}
