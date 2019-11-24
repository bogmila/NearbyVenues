//
//  LocationServiceDelegate.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 22/11/2019.
//

protocol LocationServiceDelegate: AnyObject {
    func locationUpdateSuccess(location: Location)
    func locationUpdateError()
    func shouldEnableLocation()
    func authorized()
}
