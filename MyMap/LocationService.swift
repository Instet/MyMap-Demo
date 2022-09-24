//
//  LocationService.swift
//  MyMap
//
//  Created by Руслан Магомедов on 21.09.2022.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {

    func didUpdateLocation(withLocation location: CLLocationCoordinate2D)
    func alertError()

}

final class LocationService: NSObject {

    weak var delegate: LocationServiceDelegate?

    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    deinit {
        locationManager.stopUpdatingLocation()
    }


    func startLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 2
        locationManager.startUpdatingLocation()
    }


}


// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        self.delegate?.didUpdateLocation(withLocation: userLocation.coordinate)

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        DispatchQueue.global(qos: .default).sync {
            if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
                self.delegate?.alertError()
            }
        }

    }



}
