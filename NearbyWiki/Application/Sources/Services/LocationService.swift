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
    private var onUpdateCallback: ((CLLocation) -> Void)?
    private var onFailCallback: ((Error) -> Void)?

    private var variable = PublishSubject<CLLocation>()

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }

    deinit {
        stopListenLocation()
    }

    func startListenLocation() -> Observable<CLLocation> {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return variable.asObservable()
    }

    func stopListenLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            variable.onNext(currentLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        variable.onError(error)
    }
}
