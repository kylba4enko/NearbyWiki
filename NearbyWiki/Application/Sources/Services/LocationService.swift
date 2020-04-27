//
//  LocationService.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation

protocol LocationService {
    func startListenLocation(onUpdate: @escaping (CLLocation) -> Void, onFail: @escaping (Error) -> Void)
    func stopListenLocation()
}

class LocationServiceImpl: NSObject, LocationService {

    private let locationManager = CLLocationManager()
    private var onUpdateCallback: ((CLLocation) -> Void)?
    private var onFailCallback: ((Error) -> Void)?

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }

    deinit {
        stopListenLocation()
    }

    func startListenLocation(onUpdate: @escaping (CLLocation) -> Void, onFail: @escaping (Error) -> Void) {
        onUpdateCallback = onUpdate
        onFailCallback = onFail
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func stopListenLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            onUpdateCallback?(currentLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onFailCallback?(error)
    }
}
