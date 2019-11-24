//
//  DataTaskDoubles.swift
//  NearbyVenuesTests
//
//  Created by Bogumiła Kochańska-Nawojczyk on 23/11/2019.
//
@testable import NearbyVenues

final class DataTaskDummy: DataTaskProtocol {
    func resume() {}
    func cancel() {}
}

final class DataTaskSpy: DataTaskProtocol {
    private(set) var resumeCalled = false
    private(set) var cancelCalled = false

    func resume() {
        resumeCalled = true
    }

    func cancel() {
        cancelCalled = true
    }
}
