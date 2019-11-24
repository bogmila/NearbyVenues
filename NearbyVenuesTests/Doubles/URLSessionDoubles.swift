//
//  URLSessiondoubles.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 23/11/2019.
//
import Foundation
@testable import NearbyVenues

final class URLSessionStub: URLSessionProtocol {
    private(set) var dataTaskCalled = false
    private(set) var request: URLRequest?
    private(set) var completion: DataTaskResult?
    var dataTask: DataTaskProtocol?

    func dataTask(request: URLRequest, completion: @escaping DataTaskResult) -> DataTaskProtocol {
        self.request = request
        dataTaskCalled = true
        self.completion = completion
        return dataTask ?? DataTaskDummy()
    }
}
