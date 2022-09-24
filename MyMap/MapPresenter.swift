//
//  MapPresenter.swift
//  MyMap
//
//  Created by Руслан Магомедов on 21.09.2022.
//

import Foundation
import CoreLocation

protocol MapViewProtocol: AnyObject {
    func requestLocation(_ location: CLLocationCoordinate2D)
    func alertErrorMap()
}

protocol MapPresenterProtocol {
    var view: MapViewProtocol? { get set }
    var location: CLLocationCoordinate2D? { get set }
    func requestLocation(completion: @escaping () -> Void)


}

final class MapPresenter: MapPresenterProtocol {

    weak var view: MapViewProtocol?
    var location: CLLocationCoordinate2D?
    let locationService = LocationService()

    init() {
        locationService.delegate = self
        locationService.startLocation()
    }

    func requestLocation(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            if self.locationService.locationManager.authorizationStatus == .authorizedWhenInUse {
                completion()
            }
        }
    }
}


extension MapPresenter: LocationServiceDelegate {


    func didUpdateLocation(withLocation location: CLLocationCoordinate2D) {
        self.location = location
        view?.requestLocation(location)
    }

    func alertError() {
        view?.alertErrorMap()
    }


}
