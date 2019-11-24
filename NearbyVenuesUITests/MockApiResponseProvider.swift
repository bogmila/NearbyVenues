//
//  MockApiResponseProvider.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 24/11/2019.
//

import Foundation

class MockApiResponseProvider {
    
    static func load(_ name: String!) -> NSDictionary? {
        let testBundle = Bundle(for: type(of: MockApiResponseProvider()))
        let path = testBundle.path(forResource: name, ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
            return dictionary as NSDictionary?
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    static func loadAsData(_ name: String!) -> Data? {
        let testBundle = Bundle(for: type(of: MockApiResponseProvider()))
        let path = testBundle.path(forResource: name, ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        return data
    }
}
