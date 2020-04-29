//
//  LocationService.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import CoreLocation
import RxSwift

protocol LocationService {
    func startListenLocation() -> Observable<CLLocation>
    func stopListenLocation()
}

class LocationServiceImpl: NSObject, LocationService {

    private let locationManager = CLLocationManager()
    private var locationSubject = PublishSubject<CLLocation>()

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
    }

    deinit {
        stopListenLocation()
    }

    func startListenLocation() -> Observable<CLLocation> {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationSubject.asObservable()
    }

    func stopListenLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            locationSubject.onNext(currentLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject.onError(error)
    }
}
